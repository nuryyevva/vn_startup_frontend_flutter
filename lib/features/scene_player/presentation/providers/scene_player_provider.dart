import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/error_mapper.dart';
import '../../../stories/domain/models/story.dart';
import '../../../stories/presentation/providers/stories_providers.dart';
import '../../../wallet/presentation/providers/wallet_balance_provider.dart';
import '../../domain/dialogue_line.dart';
import '../../domain/scene_player_args.dart';

/// `ended` is the last scene of a story: its script is exhausted and there
/// are no choices left to make.
enum ScenePlayerPhase { loading, locked, dialogue, choices, ended, error }

class ScenePlayerState {
  const ScenePlayerState({
    required this.phase,
    this.scene,
    this.lines = const [],
    this.playerTheme,
    this.dialogueIndex = 0,
    this.unlockCostDiamonds,
    this.isUnlocking = false,
    this.pendingChoiceId,
    this.errorMessage,
  });

  final ScenePlayerPhase phase;
  final Scene? scene;

  /// The scene's script as resolved for this player (see
  /// [DialogueLine.resolveScript]) — what's actually played, as opposed to
  /// the raw `scene.dialogueScript`.
  final List<DialogueLine> lines;

  /// The story's `player_theme` (see `ScenePlayerSkin`), null for the
  /// default look.
  final Map<String, dynamic>? playerTheme;
  final int dialogueIndex;
  final int? unlockCostDiamonds;
  final bool isUnlocking;

  /// The choice the player just made, while the next scene is being
  /// fetched — the current scene stays on screen meanwhile.
  final String? pendingChoiceId;
  final String? errorMessage;

  ScenePlayerState copyWith({
    ScenePlayerPhase? phase,
    Scene? scene,
    List<DialogueLine>? lines,
    Map<String, dynamic>? playerTheme,
    int? dialogueIndex,
    int? unlockCostDiamonds,
    bool? isUnlocking,
    String? errorMessage,
  }) {
    return ScenePlayerState(
      phase: phase ?? this.phase,
      scene: scene ?? this.scene,
      lines: lines ?? this.lines,
      playerTheme: playerTheme ?? this.playerTheme,
      dialogueIndex: dialogueIndex ?? this.dialogueIndex,
      unlockCostDiamonds: unlockCostDiamonds ?? this.unlockCostDiamonds,
      isUnlocking: isUnlocking ?? this.isUnlocking,
      errorMessage: errorMessage,
    );
  }

  ScenePlayerState withPendingChoice(String? choiceId) => ScenePlayerState(
    phase: phase,
    scene: scene,
    lines: lines,
    playerTheme: playerTheme,
    dialogueIndex: dialogueIndex,
    unlockCostDiamonds: unlockCostDiamonds,
    isUnlocking: isUnlocking,
    pendingChoiceId: choiceId,
  );

  /// The line on screen, or the last one once the choices/ending panel has
  /// replaced the dialogue box (so the background and sprite stay put).
  DialogueLine? get currentLine {
    if (lines.isEmpty) return null;
    return lines[dialogueIndex.clamp(0, lines.length - 1)];
  }
}

/// Where a choice leads: the next scene, ready to show — or, if it's a paid
/// scene the player hasn't unlocked, just its id ([next] is null), for the
/// unlock prompt.
class SceneTransition {
  const SceneTransition({required this.sceneId, this.next});

  final String sceneId;
  final ScenePlayerState? next;
}

/// Plays a story starting at `sceneId`. A choice moves on to the next
/// scene *in place* ([submitChoice] then [show]) rather than through a new
/// route: the scene on screen stays up while the next one loads, so the
/// change is a crossfade instead of a blank loading screen, and the music
/// keeps playing.
class ScenePlayerNotifier extends StateNotifier<ScenePlayerState> {
  ScenePlayerNotifier(this._ref, this.sceneId, this.args)
    : super(const ScenePlayerState(phase: ScenePlayerPhase.loading)) {
    _load();
  }

  final Ref _ref;
  final String sceneId;
  final ScenePlayerArgs? args;

  Future<void> _load() async {
    state = ScenePlayerState(phase: ScenePlayerPhase.loading, unlockCostDiamonds: args?.unlockCostDiamonds);
    try {
      final repository = _ref.read(storyRepositoryProvider);
      final scene = await repository.getScene(sceneId);
      // Both are per-story and independent of each other — fetch together.
      final (choicesMade, playerTheme) = await (_choicesMade(scene.storyId), _playerTheme(scene.storyId)).wait;
      final lines = DialogueLine.resolveScript(scene, choicesMade);
      state = ScenePlayerState(
        phase: _phaseAfterScript(scene, lines, 0),
        scene: scene,
        lines: lines,
        playerTheme: playerTheme,
      );
    } on AppException catch (e) {
      if (e is SceneLockedException) {
        state = ScenePlayerState(phase: ScenePlayerPhase.locked, unlockCostDiamonds: args?.unlockCostDiamonds);
      } else {
        state = ScenePlayerState(phase: ScenePlayerPhase.error, errorMessage: e.localizedMessage());
      }
    }
  }

  /// The player's choices so far, which conditional script lines depend
  /// on. A failure here only means those lines fall back to their
  /// "nothing chosen yet" variant — not worth blocking playback over.
  Future<List<String>> _choicesMade(String storyId) async {
    try {
      final progress = await _ref.read(storyRepositoryProvider).getStoryProgress(storyId);
      return progress.choicesMade;
    } on Exception {
      return const [];
    }
  }

  /// The story's look. Read through [storyByIdProvider], so it's fetched
  /// once per story rather than on every scene; if that fails the scene
  /// simply plays in the default look.
  Future<Map<String, dynamic>?> _playerTheme(String storyId) async {
    try {
      return (await _ref.read(storyByIdProvider(storyId).future)).playerTheme;
    } on Exception {
      return null;
    }
  }

  /// Phase to show once the line at [index] is reached: dialogue while
  /// there are lines left, then choices, or the ending if there are none.
  static ScenePlayerPhase _phaseAfterScript(Scene scene, List<DialogueLine> lines, int index) {
    if (index < lines.length) return ScenePlayerPhase.dialogue;
    return scene.choices.isNotEmpty ? ScenePlayerPhase.choices : ScenePlayerPhase.ended;
  }

  Future<void> unlock() async {
    final cost = state.unlockCostDiamonds;
    state = state.copyWith(isUnlocking: true);
    try {
      await _ref.read(storyRepositoryProvider).unlockScene(sceneId);
      if (cost != null) {
        _ref.read(walletBalanceProvider.notifier).applyOptimisticDelta(-cost);
      }
      await _load();
    } on AppException catch (e) {
      state = state.copyWith(isUnlocking: false, errorMessage: e.localizedMessage());
    }
  }

  /// Advances to the next dialogue line, or reveals the choices panel (or
  /// the ending) once the script is exhausted.
  void advance() {
    final scene = state.scene;
    if (scene == null || state.phase != ScenePlayerPhase.dialogue) return;
    final next = state.dialogueIndex + 1;
    if (next < state.lines.length) {
      state = state.copyWith(dialogueIndex: next);
    } else {
      state = state.copyWith(phase: _phaseAfterScript(scene, state.lines, next));
    }
  }

  /// Submits the choice and loads the scene it leads to, without showing
  /// it yet — the screen first makes sure that scene's art is ready, then
  /// calls [show]. Until then the current scene stays up with the choice
  /// marked as pending.
  Future<SceneTransition> submitChoice(Choice choice) async {
    final current = state.scene;
    if (current == null || state.pendingChoiceId != null) {
      throw StateError('no scene to choose on, or a choice is already being submitted');
    }
    state = state.withPendingChoice(choice.id);
    try {
      final repository = _ref.read(storyRepositoryProvider);
      final progress = await repository.submitChoice(current.id, choice.id);
      // Story detail / "continue reading" show the current scene — keep
      // them in step instead of serving the cached position from when the
      // story was opened.
      _ref.invalidate(storyProgressProvider(progress.storyId));
      _ref.invalidate(myProgressProvider);

      final Scene scene;
      try {
        scene = await repository.getScene(progress.currentSceneId);
      } on SceneLockedException {
        return SceneTransition(sceneId: progress.currentSceneId);
      }
      final lines = DialogueLine.resolveScript(scene, progress.choicesMade);
      return SceneTransition(
        sceneId: scene.id,
        next: ScenePlayerState(
          phase: _phaseAfterScript(scene, lines, 0),
          scene: scene,
          lines: lines,
          playerTheme: state.playerTheme,
        ),
      );
    } catch (_) {
      if (mounted) state = state.withPendingChoice(null);
      rethrow;
    }
  }

  /// Switches to a scene prepared by [submitChoice].
  void show(ScenePlayerState next) => state = next;
}

final scenePlayerProvider =
    StateNotifierProvider.family<ScenePlayerNotifier, ScenePlayerState, ({String sceneId, ScenePlayerArgs? args})>((
      ref,
      key,
    ) {
      return ScenePlayerNotifier(ref, key.sceneId, key.args);
    });
