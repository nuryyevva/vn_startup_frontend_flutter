import 'package:flutter_test/flutter_test.dart';
import 'package:nocturne/core/network/error_mapper.dart';
import 'package:nocturne/features/achievements/domain/models/achievement.dart';
import 'package:nocturne/features/offline/data/bundled_content.dart';
import 'package:nocturne/features/offline/data/bundled_story_repository.dart';
import 'package:nocturne/features/offline/data/local_player_repositories.dart';
import 'package:nocturne/features/offline/data/local_store.dart';
import 'package:nocturne/features/offline/data/local_wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic> _choice(String id, String next, {String? onceKey, int cost = 0}) => {
  'id': id,
  'text': id,
  'is_paid': cost > 0,
  'cost_diamonds': cost,
  'next_scene_id': next,
  'once_key': ?onceKey,
};

Map<String, dynamic> _scene(String id, int order, List<Map<String, dynamic>> choices, {int? unlockCost}) => {
  'id': id,
  'story_id': 'story',
  'order_index': order,
  'background_url': '/media/bg.webp',
  'dialogue_script': [
    {'speaker': 'narrator', 'text': id, 'sprite_url': '/media/sprite.webp'},
  ],
  'free_dialog_enabled': true,
  'unlock_cost_diamonds': ?unlockCost,
  'choices': choices,
};

/// start -> hub (coat / photo loop back, exit -> paid -> end)
final _content = {
  'stories': [
    {
      'id': 'story',
      'title': 'Story',
      'cover_url': '/media/cover.webp',
      'genre': 'mystery',
      'status': 'ongoing',
      'created_at': '2026-01-01T00:00:00Z',
      'player_theme': {'preset': 'mist'},
      'scenes': [
        _scene('start', 0, [_choice('enter', 'hub'), _choice('buy', 'hub', cost: 10)]),
        _scene('hub', 1, [
          _choice('coat', 'hub', onceKey: 'coat'),
          _choice('photo', 'hub', onceKey: 'photo'),
          _choice('exit', 'paid'),
        ]),
        _scene('paid', 2, [_choice('finish', 'end')], unlockCost: 25),
        _scene('end', 3, []),
      ],
    },
  ],
};

void main() {
  late LocalStore store;
  late LocalWallet wallet;
  late BundledStoryRepository repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = LocalStore(await SharedPreferences.getInstance());
    wallet = LocalWallet(store);
    repo = BundledStoryRepository(content: BundledContent.parse(_content), store: store, wallet: wallet);
  });

  Future<List<String>> offered(String sceneId) async => (await repo.getScene(sceneId)).choices.map((c) => c.id).toList();

  test('content is served from the bundle: asset URLs, catalog, no free dialogue', () async {
    final page = await repo.getStories();
    expect(page.items.single.coverUrl, 'asset:assets/content/media/cover.webp');
    expect(page.items.single.playerTheme, {'preset': 'mist'});

    final scene = await repo.getScene('start');
    expect(scene.backgroundUrl, 'asset:assets/content/media/bg.webp');
    expect((scene.dialogueScript.single as Map)['sprite_url'], 'asset:assets/content/media/sprite.webp');
    expect(scene.freeDialogEnabled, isFalse);
    expect((await repo.getStories(genre: 'romance')).total, 0);
  });

  test('progress follows choices and survives a new repository over the same store', () async {
    expect((await repo.getStoryProgress('story')).currentSceneId, 'start');

    await repo.submitChoice('start', 'enter');
    final reopened = BundledStoryRepository(content: BundledContent.parse(_content), store: store, wallet: wallet);

    final progress = await reopened.getStoryProgress('story');
    expect(progress.currentSceneId, 'hub');
    expect(progress.choicesMade, ['enter']);
    final summary = (await reopened.getMyProgress()).single;
    expect(summary.currentSceneOrderIndex, 1);
    expect(summary.totalScenes, 4);
    expect(summary.isFinished, isFalse);
  });

  test('one-time choices disappear once used and come back on a new visit', () async {
    await repo.submitChoice('start', 'enter');
    expect(await offered('hub'), ['coat', 'photo', 'exit']);

    await repo.submitChoice('hub', 'coat');
    expect(await offered('hub'), ['photo', 'exit']);
    await expectLater(repo.submitChoice('hub', 'coat'), throwsA(isA<ValidationException>()));

    await repo.submitChoice('hub', 'photo');
    expect(await offered('hub'), ['exit']);

    // Replaying from the start is a fresh visit to the hub.
    await repo.submitChoice('start', 'enter');
    expect(await offered('hub'), ['coat', 'photo', 'exit']);
  });

  // Wallets start at LocalWallet.startingBalance and can't be topped up;
  // tests that need a particular balance set it directly.
  Future<void> setBalance(int diamonds) async {
    await store.writeInt('wallet.startingBalanceApplied', 1);
    await store.writeInt('wallet.balance', diamonds);
  }

  test('paid choices and scene unlocks debit the local wallet', () async {
    await setBalance(0);
    await expectLater(repo.submitChoice('start', 'buy'), throwsA(isA<InsufficientDiamondsException>()));
    expect((await repo.getStoryProgress('story')).choicesMade, isEmpty);

    await setBalance(40);
    await repo.submitChoice('start', 'buy');
    expect(wallet.balance, 30);

    await expectLater(repo.getScene('paid'), throwsA(isA<SceneLockedException>()));
    expect((await repo.getStoryScenes('story'))[2].isUnlocked, isFalse);
    await repo.unlockScene('paid');
    await repo.unlockScene('paid'); // idempotent: no second charge
    expect(wallet.balance, 5);
    expect((await repo.getScene('paid')).id, 'paid');
    expect(wallet.spent, 35);
  });

  test('finishing a story and spending diamonds unlock achievements', () async {
    final stats = LocalStatsRepository(store);
    final achievements = LocalAchievementsRepository(store: store, stories: repo, wallet: wallet, stats: stats);
    bool unlocked(List<Achievement> all, String id) => all.firstWhere((a) => a.id == id).unlocked;

    expect(unlocked(await achievements.getAchievements(), 'first_story_finished'), isFalse);

    await setBalance(25);
    await repo.submitChoice('start', 'enter');
    await repo.submitChoice('hub', 'exit');
    await repo.unlockScene('paid');
    await repo.submitChoice('paid', 'finish');

    final all = await achievements.getAchievements();
    expect(unlocked(all, 'first_story_finished'), isTrue);
    expect(unlocked(all, 'generous'), isTrue);
    expect(unlocked(all, 'first_words'), isFalse);
  });

  test('the day streak grows on consecutive days and resets after a gap', () async {
    var now = DateTime.utc(2026, 3, 1, 22);
    final stats = LocalStatsRepository(store, now: () => now);

    await stats.heartbeat(30);
    await stats.heartbeat(30);
    expect((await stats.getStats()).dayStreak, 1);
    expect((await stats.getStats()).totalReadingSeconds, 60);

    now = DateTime.utc(2026, 3, 2, 9);
    expect((await stats.heartbeat(30)).dayStreak, 2);

    now = DateTime.utc(2026, 3, 5, 9);
    expect((await stats.getStats()).dayStreak, 0);
    final after = await stats.heartbeat(30);
    expect(after.dayStreak, 1);
    expect(after.longestStreak, 2);
  });
}
