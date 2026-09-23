import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/motion.dart';
import '../../../dialog/presentation/screens/free_dialog_screen.dart';
import '../../../stats/presentation/providers/reading_stats_provider.dart';
import '../../../stories/domain/models/story.dart';
import '../../../wallet/presentation/providers/wallet_balance_provider.dart';
import '../../domain/character_sprite.dart';
import '../../domain/scene_player_args.dart';
import '../providers/scene_player_provider.dart';
import '../widgets/choices_panel.dart';
import '../widgets/dialogue_box.dart';
import '../widgets/scene_background_layer.dart';
import '../widgets/scene_log_sheet.dart';
import '../widgets/scene_top_bar.dart';
import '../widgets/unlock_scene_prompt.dart';

/// The visual-novel playback screen (project spec §8.4): background →
/// character → dialogue/choices, layered via a plain `Stack` (a
/// `CustomPainter` would only pay for itself if this needed custom
/// drawing — it doesn't; it's images and text). One [ScenePlayerNotifier]
/// instance per scene, created fresh by go_router pushing a new route on
/// every scene transition rather than mutated in place.
class ScenePlayerScreen extends ConsumerWidget {
  const ScenePlayerScreen({super.key, required this.sceneId, this.args});

  final String sceneId;
  final ScenePlayerArgs? args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (sceneId: sceneId, args: args);
    final state = ref.watch(scenePlayerProvider(key));
    final notifier = ref.watch(scenePlayerProvider(key).notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: switch (state.phase) {
        ScenePlayerPhase.loading => const Center(child: CircularProgressIndicator(color: Colors.white)),
        ScenePlayerPhase.error => _ErrorBody(message: state.errorMessage, onBack: () => context.pop()),
        ScenePlayerPhase.locked => Stack(
          children: [
            UnlockScenePrompt(
              costDiamonds: state.unlockCostDiamonds,
              isUnlocking: state.isUnlocking,
              onUnlock: notifier.unlock,
              onBack: () => context.pop(),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SceneTopBar(onBack: () => context.pop(), onShowLog: () {}),
            ),
          ],
        ),
        ScenePlayerPhase.dialogue || ScenePlayerPhase.choices => _ScenePlaybackBody(
          sceneKey: key,
          state: state,
          notifier: notifier,
        ),
      },
    );
  }
}

class _ScenePlaybackBody extends ConsumerStatefulWidget {
  const _ScenePlaybackBody({required this.sceneKey, required this.state, required this.notifier});

  final ({String sceneId, ScenePlayerArgs? args}) sceneKey;
  final ScenePlayerState state;
  final ScenePlayerNotifier notifier;

  @override
  ConsumerState<_ScenePlaybackBody> createState() => _ScenePlaybackBodyState();
}

class _ScenePlaybackBodyState extends ConsumerState<_ScenePlaybackBody> {
  bool _showFreeDialog = false;
  String _freeDialogCharacterName = '';

  /// Reports elapsed reading time to the backend every 30s while this scene
  /// is on screen — the only source of "day streak"/"hours read" data (see
  /// `ReadingStatsNotifier`); nothing is inferred client-side.
  static const _heartbeatInterval = Duration(seconds: 30);
  Timer? _heartbeatTimer;

  @override
  void initState() {
    super.initState();
    _heartbeatTimer = Timer.periodic(
      _heartbeatInterval,
      (_) => ref.read(readingStatsProvider.notifier).sendHeartbeat(_heartbeatInterval.inSeconds),
    );
  }

  @override
  void dispose() {
    _heartbeatTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final notifier = widget.notifier;
    final scene = state.scene!;
    final balance = ref.watch(walletBalanceProvider).valueOrNull;
    const characterSprite = ImageCharacterSprite();

    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: state.phase == ScenePlayerPhase.dialogue ? notifier.advance : null,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SceneBackgroundLayer(backgroundUrl: scene.backgroundUrl),
              if (scene.characterId != null) characterSprite.build(context),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedSwitcher(
                  duration: Motion.microDuration,
                  child: state.phase == ScenePlayerPhase.choices
                      ? ChoicesPanel(
                          key: const ValueKey('choices'),
                          choices: scene.choices,
                          walletBalance: balance,
                          onSelect: (choice) => _selectChoice(choice),
                        )
                      : _DialogueSection(
                          key: ValueKey('dialogue-${state.dialogueIndex}'),
                          state: state,
                          onTalkToCharacter: scene.freeDialogEnabled ? _openFreeDialog : null,
                        ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SceneTopBar(
                  onBack: () => context.pop(),
                  onShowLog: () => showSceneLogSheet(
                    context,
                    lines: scene.dialogueScript.take(state.dialogueIndex + 1).cast<Map<String, dynamic>>().toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_showFreeDialog && scene.characterId != null)
          FreeDialogScreen(
            characterId: scene.characterId!,
            sceneId: widget.sceneKey.sceneId,
            characterName: _freeDialogCharacterName,
            onClose: () => setState(() => _showFreeDialog = false),
          ),
      ],
    );
  }

  Future<void> _selectChoice(Choice choice) async {
    try {
      final nextSceneId = await widget.notifier.submitChoice(choice);
      unawaited(ref.read(walletBalanceProvider.notifier).refresh());
      if (mounted) {
        context.pushReplacement(
          '/play/$nextSceneId',
          extra: ScenePlayerArgs(storyId: widget.sceneKey.args?.storyId ?? ''),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('errors.unknownError'.tr())));
      }
    }
  }

  void _openFreeDialog() {
    final speaker = widget.state.currentLine?['speaker'] as String?;
    setState(() {
      _freeDialogCharacterName = (speaker == null || speaker == 'narrator') ? '' : speaker;
      _showFreeDialog = true;
    });
  }
}

class _DialogueSection extends StatelessWidget {
  const _DialogueSection({super.key, required this.state, required this.onTalkToCharacter});

  final ScenePlayerState state;
  final VoidCallback? onTalkToCharacter;

  @override
  Widget build(BuildContext context) {
    final line = state.currentLine;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onTalkToCharacter != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: onTalkToCharacter,
                icon: const Icon(LucideIcons.messageCircle, size: 16),
                label: Text('scenePlayer.talkTo'.tr(args: [(line?['speaker'] as String?) ?? ''])),
              ),
            ),
          ),
        DialogueBox(
          speaker: (line?['speaker'] as String?) ?? '',
          text: (line?['text'] as String?) ?? '',
        ),
      ],
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onBack});

  final String? message;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message ?? 'errors.unknownError'.tr(),
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onBack, child: Text('common.back'.tr())),
          ],
        ),
      ),
    );
  }
}
