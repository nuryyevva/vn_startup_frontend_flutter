import '../../../core/network/error_mapper.dart';
import '../../stories/data/story_repository.dart';
import '../../stories/domain/models/story.dart';
import 'bundled_content.dart';
import 'local_store.dart';
import 'local_wallet.dart';

/// [StoryRepository] for the offline build: content from the app bundle,
/// the player's state from the device. It applies the same rules the
/// backend's story service does (paid choices and scene unlocks debit the
/// wallet, one-time choices disappear once used, progress follows the
/// chosen branch), so a story plays identically either way.
class BundledStoryRepository implements StoryRepository {
  BundledStoryRepository({
    required BundledContent content,
    required LocalStore store,
    required LocalWallet wallet,
    DateTime Function() now = DateTime.now,
  }) : _content = content,
       _store = store,
       _wallet = wallet,
       _now = now;

  final BundledContent _content;
  final LocalStore _store;
  final LocalWallet _wallet;
  final DateTime Function() _now;

  static const _progressKey = 'story.progress';
  static const _unlockedKey = 'story.unlocked_scenes';
  static const _bookmarksKey = 'story.bookmarks';

  // --- catalog ---

  @override
  Future<StoryPage> getStories({String? genre, int page = 1, int? pageSize}) async {
    final size = pageSize ?? 20;
    final matching = _content.stories.where((s) => genre == null || s.genre == genre).toList();
    final items = matching.skip((page - 1) * size).take(size).toList();
    return StoryPage(items: items, total: matching.length, page: page, pageSize: size);
  }

  @override
  Future<Story> getStory(String storyId) async => _story(storyId);

  @override
  Future<List<SceneSummary>> getStoryScenes(String storyId) async {
    _story(storyId);
    final unlocked = unlockedSceneIds;
    return [
      for (final scene in _content.scenesOf(storyId))
        SceneSummary(
          id: scene.id,
          orderIndex: scene.orderIndex,
          unlockCostDiamonds: scene.unlockCostDiamonds,
          isUnlocked: scene.unlockCostDiamonds == null || unlocked.contains(scene.id),
          chapterTitle: scene.chapterTitle,
          title: scene.title,
        ),
    ];
  }

  // --- playing ---

  @override
  Future<Scene> getScene(String sceneId) async {
    final scene = _scene(sceneId);
    if (scene.unlockCostDiamonds != null && !unlockedSceneIds.contains(scene.id)) {
      throw const AppException.sceneLocked();
    }
    final used = _usedOneTimeChoices(scene);
    if (used.isEmpty) return scene;
    final available = scene.choices.where((c) => !used.contains(c.id)).toList();
    // Never leave a scene with nothing to choose — the story couldn't go on.
    return available.isEmpty ? scene : scene.copyWith(choices: available);
  }

  @override
  Future<PlayerProgress> submitChoice(String sceneId, String choiceId) async {
    final scene = _scene(sceneId);
    final choice = scene.choices.where((c) => c.id == choiceId).firstOrNull;
    if (choice == null) throw const AppException.notFound();

    final used = _usedOneTimeChoices(scene);
    if (used.contains(choice.id) && used.length < scene.choices.length) {
      throw const AppException.validation('Этот вариант уже был выбран');
    }
    if (choice.isPaid) await _wallet.debit(choice.costDiamonds);

    final previous = _progressOf(scene.storyId);
    final progress = PlayerProgress(
      storyId: scene.storyId,
      currentSceneId: choice.nextSceneId ?? scene.id,
      choicesMade: [...?previous?.choicesMade, choice.id],
      updatedAt: _now(),
    );
    await _saveProgress(progress);
    return progress;
  }

  @override
  Future<void> unlockScene(String sceneId) async {
    final scene = _scene(sceneId);
    final cost = scene.unlockCostDiamonds;
    if (cost == null) throw const AppException.validation('Эта глава не требует разблокировки');
    final unlocked = unlockedSceneIds;
    if (unlocked.contains(scene.id)) return;
    await _wallet.debit(cost);
    await _store.writeList(_unlockedKey, [...unlocked, scene.id]);
  }

  /// Which of [scene]'s one-time choices are used up in the player's
  /// current visit to it. A visit starts with the last choice made on an
  /// earlier scene; a choice is used if it — or another with the same
  /// `once_key` — was made since. Mirrors the backend's
  /// `internal/story/one_time_choices.go`.
  Set<String> _usedOneTimeChoices(Scene scene) {
    final keyed = {
      for (final c in scene.choices)
        if (_content.choice(c.id)?.onceKey case final String key) c.id: key,
    };
    if (keyed.isEmpty) return const {};

    final made = _progressOf(scene.storyId)?.choicesMade ?? const <String>[];
    var visitStart = 0;
    for (var i = made.length - 1; i >= 0; i--) {
      final madeOn = _content.sceneOfChoice(made[i]);
      if (madeOn != null && madeOn.orderIndex < scene.orderIndex) {
        visitStart = i;
        break;
      }
    }
    final usedKeys = {
      for (final id in made.skip(visitStart))
        if (_content.choice(id)?.onceKey case final String key) key,
    };
    return {
      for (final entry in keyed.entries)
        if (usedKeys.contains(entry.value)) entry.key,
    };
  }

  // --- progress ---

  @override
  Future<PlayerProgress> getStoryProgress(String storyId) async {
    final existing = _progressOf(storyId);
    if (existing != null) return existing;

    _story(storyId);
    final first = _content.scenesOf(storyId).firstOrNull;
    if (first == null) throw const AppException.notFound();
    final created = PlayerProgress(storyId: storyId, currentSceneId: first.id, updatedAt: _now());
    await _saveProgress(created);
    return created;
  }

  @override
  Future<List<ProgressSummary>> getMyProgress() async => progressSummaries;

  /// Every story the player has opened, most recently played first.
  List<ProgressSummary> get progressSummaries {
    final summaries = <ProgressSummary>[];
    for (final entry in _store.readMap(_progressKey).entries) {
      final story = _content.story(entry.key);
      if (story == null) continue; // a story dropped from a newer bundle
      final progress = PlayerProgress.fromJson(entry.value as Map<String, dynamic>);
      final scenes = _content.scenesOf(story.id);
      final index = _content.scene(progress.currentSceneId)?.orderIndex ?? 0;
      summaries.add(
        ProgressSummary(
          story: story,
          currentSceneId: progress.currentSceneId,
          choicesMade: progress.choicesMade,
          updatedAt: progress.updatedAt,
          currentSceneOrderIndex: index,
          totalScenes: scenes.length,
          isFinished: index >= scenes.length - 1,
        ),
      );
    }
    return summaries..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Set<String> get unlockedSceneIds => _store.readList(_unlockedKey).toSet();

  PlayerProgress? _progressOf(String storyId) {
    final raw = _store.readMap(_progressKey)[storyId];
    if (raw is! Map<String, dynamic>) return null;
    final progress = PlayerProgress.fromJson(raw);
    // The saved position may point at a scene a newer bundle no longer has.
    return _content.scene(progress.currentSceneId) == null ? null : progress;
  }

  Future<void> _saveProgress(PlayerProgress progress) {
    final all = _store.readMap(_progressKey);
    all[progress.storyId] = progress.toJson();
    return _store.writeMap(_progressKey, all);
  }

  // --- bookmarks ---

  @override
  Future<List<Story>> getBookmarks() async =>
      _store.readList(_bookmarksKey).reversed.map(_content.story).nonNulls.toList();

  @override
  Future<void> addBookmark(String storyId) async {
    _story(storyId);
    final ids = _store.readList(_bookmarksKey);
    if (!ids.contains(storyId)) await _store.writeList(_bookmarksKey, [...ids, storyId]);
  }

  @override
  Future<void> removeBookmark(String storyId) =>
      _store.writeList(_bookmarksKey, _store.readList(_bookmarksKey).where((id) => id != storyId).toList());

  Story _story(String id) => _content.story(id) ?? (throw const AppException.notFound());

  Scene _scene(String id) => _content.scene(id) ?? (throw const AppException.notFound());
}
