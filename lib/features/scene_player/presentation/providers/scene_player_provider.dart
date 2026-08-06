import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/error_mapper.dart';
import '../../../stories/domain/models/story.dart';
import '../../../stories/presentation/providers/stories_providers.dart';
import '../../../wallet/presentation/providers/wallet_balance_provider.dart';
import '../../domain/scene_player_args.dart';

enum ScenePlayerPhase { loading, locked, dialogue, choices, error }

class ScenePlayerState {
  const ScenePlayerState({
    required this.phase,
    this.scene,
    this.dialogueIndex = 0,
    this.unlockCostDiamonds,
    this.isUnlocking = false,
    this.errorMessage,
  });

  final ScenePlayerPhase phase;
  final Scene? scene;
  final int dialogueIndex;
  final int? unlockCostDiamonds;
  final bool isUnlocking;
  final String? errorMessage;

  ScenePlayerState copyWith({
    ScenePlayerPhase? phase,
    Scene? scene,
    int? dialogueIndex,
    int? unlockCostDiamonds,
    bool? isUnlocking,
    String? errorMessage,
  }) {
    return ScenePlayerState(
      phase: phase ?? this.phase,
      scene: scene ?? this.scene,
      dialogueIndex: dialogueIndex ?? this.dialogueIndex,
      unlockCostDiamonds: unlockCostDiamonds ?? this.unlockCostDiamonds,
      isUnlocking: isUnlocking ?? this.isUnlocking,
      errorMessage: errorMessage,
    );
  }

  Map<String, dynamic>? get currentLine {
    final scene = this.scene;
    if (scene == null || dialogueIndex >= scene.dialogueScript.length) return null;
    final line = scene.dialogueScript[dialogueIndex];
    return line is Map<String, dynamic> ? line : null;
  }
}

/// One instance per `sceneId` — created fresh by go_router pushing a new
/// `/play/:sceneId` route on every scene transition (see
/// `ScenePlayerScreen`), not mutated in place, so there's no risk of
/// carrying stale dialogue-index state across scenes.
class ScenePlayerNotifier extends StateNotifier<ScenePlayerState> {
  ScenePlayerNotifier(this._ref, this.sceneId, this.args) : super(const ScenePlayerState(phase: ScenePlayerPhase.loading)) {
    _load();
  }

  final Ref _ref;
  final String sceneId;
  final ScenePlayerArgs? args;

  Future<void> _load() async {
    state = ScenePlayerState(phase: ScenePlayerPhase.loading, unlockCostDiamonds: args?.unlockCostDiamonds);
    try {
      final scene = await _ref.read(storyRepositoryProvider).getScene(sceneId);
      state = ScenePlayerState(phase: ScenePlayerPhase.dialogue, scene: scene);
    } on AppException catch (e) {
      if (e is SceneLockedException) {
        state = ScenePlayerState(phase: ScenePlayerPhase.locked, unlockCostDiamonds: args?.unlockCostDiamonds);
      } else {
        state = ScenePlayerState(phase: ScenePlayerPhase.error, errorMessage: e.localizedMessage());
      }
    }
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

  /// Advances to the next dialogue line, or reveals the choices panel once
  /// the script is exhausted.
  void advance() {
    final scene = state.scene;
    if (scene == null) return;
    if (state.dialogueIndex + 1 < scene.dialogueScript.length) {
      state = state.copyWith(dialogueIndex: state.dialogueIndex + 1);
    } else if (scene.choices.isNotEmpty) {
      state = state.copyWith(phase: ScenePlayerPhase.choices);
    }
  }

  /// Submits the choice and returns the id of the next scene to navigate
  /// to — navigation itself is the screen's job (a fresh provider instance
  /// for the new sceneId), not this notifier's.
  Future<String> submitChoice(Choice choice) async {
    final progress = await _ref.read(storyRepositoryProvider).submitChoice(sceneId, choice.id);
    return progress.currentSceneId;
  }
}

final scenePlayerProvider = StateNotifierProvider.family<ScenePlayerNotifier, ScenePlayerState, ({String sceneId, ScenePlayerArgs? args})>((
  ref,
  key,
) {
  return ScenePlayerNotifier(ref, key.sceneId, key.args);
});
