import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/motion.dart';
import '../../../dialog/presentation/screens/free_dialog_screen.dart';
import '../../../stats/presentation/providers/reading_stats_provider.dart';
import '../../../stories/domain/models/story.dart';
import '../../../wallet/presentation/providers/wallet_balance_provider.dart';
import '../../domain/character_sprite.dart';
import '../../domain/dialogue_line.dart';
import '../../domain/scene_player_args.dart';
import '../providers/scene_player_provider.dart';
import '../theme/scene_player_skin.dart';
import '../widgets/choices_panel.dart';
import '../widgets/dialogue_box.dart';
import '../widgets/scene_background_layer.dart';
import '../widgets/scene_log_sheet.dart';
import '../widgets/scene_top_bar.dart';
import '../widgets/skin_panel.dart';
import '../widgets/unlock_scene_prompt.dart';

/// The visual-novel playback screen (project spec §8.4): background →
/// character → dialogue/choices, layered via a plain `Stack` (a
/// `CustomPainter` would only pay for itself if this needed custom
/// drawing — it doesn't; it's images and text). The route is the story's
/// entry point: choices move on to the next scene in place (see
/// [ScenePlayerNotifier]), so this screen — and its music — lives for the
/// whole reading session.
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
        // The story's skin is scoped to playback only: loading, error and
        // unlock screens — and the log sheet, which lives on the navigator
        // above this subtree — stay in the app's own look.
        ScenePlayerPhase.dialogue || ScenePlayerPhase.choices || ScenePlayerPhase.ended => Theme(
          data: Theme.of(context).copyWith(
            extensions: [
              ...Theme.of(context).extensions.values,
              ScenePlayerSkin.resolve(context.colors, state.playerTheme),
            ],
          ),
          child: _ScenePlaybackBody(sceneKey: key, state: state, notifier: notifier),
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

class _ScenePlaybackBodyState extends ConsumerState<_ScenePlaybackBody> with WidgetsBindingObserver {
  bool _showFreeDialog = false;
  String _freeDialogCharacterName = '';

  /// Reports elapsed reading time to the backend every 30s while this scene
  /// is on screen — the only source of "day streak"/"hours read" data (see
  /// `ReadingStatsNotifier`); nothing is inferred client-side.
  static const _heartbeatInterval = Duration(seconds: 30);
  Timer? _heartbeatTimer;

  /// Looping scene ambience and one-shot sound effects. Two separate
  /// players so a sound effect (e.g. a door knock) can play over the music
  /// without cutting it off. Sample content wires these up via
  /// `scene.backgroundMusicUrl` and a per-line `sfx_url` in
  /// `dialogueScript` — see `cmd/seed` on the backend for where those come
  /// from today.
  final _musicPlayer = AudioPlayer();
  final _sfxPlayer = AudioPlayer();

  /// The track currently looping, so a scene change with the same
  /// `background_music_url` leaves it playing untouched.
  String? _musicUrl;

  /// How long a scene waits for its first background and sprite before
  /// being shown anyway.
  static const _artTimeout = Duration(seconds: 3);

  /// False until the first scene's opening frame is loaded: the scene then
  /// fades in whole, instead of its text appearing over a black screen
  /// while the background is still on its way.
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _heartbeatTimer = Timer.periodic(
      _heartbeatInterval,
      (_) => ref.read(readingStatsProvider.notifier).sendHeartbeat(_heartbeatInterval.inSeconds),
    );
    WidgetsBinding.instance.addObserver(this);
    unawaited(_setMusic(widget.state.scene?.backgroundMusicUrl));
    _maybePlaySfxForLine(widget.state);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _precacheArt();
      await _precacheOpeningFrame(widget.state);
      if (mounted) setState(() => _revealed = true);
    });
  }

  /// Music must not keep playing once the app is in the background.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_musicUrl == null) return;
    if (state == AppLifecycleState.resumed) {
      unawaited(_musicPlayer.resume());
    } else {
      unawaited(_musicPlayer.pause());
    }
  }

  /// Backgrounds and sprites can change mid-scene (per-line
  /// `background_url`/`sprite_url`); fetch them all up front so a switch
  /// crossfades into a loaded image rather than a placeholder.
  void _precacheArt() {
    if (!mounted) return;
    final urls = <String>{
      for (final line in widget.state.lines) ...[line.backgroundUrl, line.spriteUrl].nonNulls,
    }..removeWhere((url) => url.isEmpty);
    for (final url in urls) {
      unawaited(precacheImage(NetworkImage(url), context, onError: (_, _) {}));
    }
  }

  @override
  void didUpdateWidget(covariant _ScenePlaybackBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    final sceneChanged = !identical(widget.state.scene, oldWidget.state.scene);
    if (sceneChanged) {
      unawaited(_setMusic(widget.state.scene?.backgroundMusicUrl));
      _precacheArt();
    }
    if (sceneChanged || widget.state.dialogueIndex != oldWidget.state.dialogueIndex) {
      _maybePlaySfxForLine(widget.state);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _heartbeatTimer?.cancel();
    unawaited(_musicPlayer.dispose());
    unawaited(_sfxPlayer.dispose());
    super.dispose();
  }

  /// Loops [url] as the scene's music; a no-op if it's already playing, so
  /// consecutive scenes sharing a track don't restart it.
  Future<void> _setMusic(String? url) async {
    if (url == _musicUrl) return;
    _musicUrl = url;
    try {
      if (url == null) {
        await _musicPlayer.stop();
        return;
      }
      await _musicPlayer.setPlayerMode(_playerMode);
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(0.6);
      await _musicPlayer.play(UrlSource(url));
    } on Exception {
      // A track that fails to load must not take the scene down with it;
      // forget it so the next scene gets a fresh attempt.
      if (_musicUrl == url) _musicUrl = null;
    }
  }

  /// On web, lowLatency decodes the whole file up front via the Web Audio
  /// API instead of streaming it through an HTML `<audio>` element — needed
  /// because hotlinked sample tracks (see cmd/seed) don't reliably work
  /// with the default mediaPlayer mode there: some fail range requests the
  /// `<audio>` element sends for its default streaming mode, and Wikimedia
  /// serves `.ogg` files as `application/ogg` rather than `audio/ogg`,
  /// which the element's format-sniffing can reject outright.
  /// decodeAudioData doesn't care about either. Off the web, lowLatency
  /// means a sound pool built for short effects — a multi-minute track
  /// needs the real media player.
  static PlayerMode get _playerMode => kIsWeb ? PlayerMode.lowLatency : PlayerMode.mediaPlayer;

  void _maybePlaySfxForLine(ScenePlayerState state) {
    if (state.phase != ScenePlayerPhase.dialogue) return;
    final sfxUrl = state.currentLine?.sfxUrl;
    if (sfxUrl != null && sfxUrl.isNotEmpty) {
      unawaited(_playSfx(sfxUrl));
    }
  }

  Future<void> _playSfx(String url) async {
    // Short one-shots: lowLatency everywhere (see _playerMode for why the
    // web needs it regardless).
    try {
      await _sfxPlayer.setPlayerMode(PlayerMode.lowLatency);
      await _sfxPlayer.play(UrlSource(url));
    } on Exception {
      // A missing sound effect is not worth interrupting the scene for.
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final notifier = widget.notifier;
    final scene = state.scene!;
    final balance = ref.watch(walletBalanceProvider).valueOrNull;
    final line = state.currentLine;
    final backgroundUrl = line?.backgroundUrl ?? scene.backgroundUrl;
    final spriteUrl = line == null ? scene.characterSpriteUrl : line.spriteUrl;
    // An explicit empty sprite_url hides the character; a scene with a
    // character but no art at all keeps the placeholder silhouette.
    final CharacterSprite? characterSprite = switch (spriteUrl) {
      final String url when url.isNotEmpty => ImageCharacterSprite(imageUrl: url),
      null when scene.characterId != null => const ImageCharacterSprite(),
      _ => null,
    };

    return Stack(
      fit: StackFit.expand,
      children: [
        if (!_revealed) const Center(child: CircularProgressIndicator(color: Colors.white)),
        _buildScene(context, state, notifier, scene, balance, backgroundUrl, spriteUrl, characterSprite),
        if (_showFreeDialog && scene.characterId != null)
          FreeDialogScreen(
            characterId: scene.characterId!,
            sceneId: scene.id,
            characterName: _freeDialogCharacterName,
            onClose: () => setState(() => _showFreeDialog = false),
          ),
      ],
    );
  }

  Widget _buildScene(
    BuildContext context,
    ScenePlayerState state,
    ScenePlayerNotifier notifier,
    Scene scene,
    int? balance,
    String? backgroundUrl,
    String? spriteUrl,
    CharacterSprite? characterSprite,
  ) {
    return IgnorePointer(
      ignoring: !_revealed,
      child: AnimatedOpacity(
        opacity: _revealed ? 1 : 0,
        duration: Motion.screenDuration,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: state.phase == ScenePlayerPhase.dialogue ? notifier.advance : null,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SceneBackgroundLayer(backgroundUrl: backgroundUrl),
              AnimatedSwitcher(
                duration: Motion.microDuration,
                child: KeyedSubtree(
                  key: ValueKey(characterSprite == null ? null : spriteUrl),
                  child: characterSprite?.build(context) ?? const SizedBox.expand(),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedSwitcher(
                  duration: Motion.microDuration,
                  child: switch (state.phase) {
                    ScenePlayerPhase.choices => ChoicesPanel(
                      key: const ValueKey('choices'),
                      choices: scene.choices,
                      walletBalance: balance,
                      pendingChoiceId: state.pendingChoiceId,
                      onSelect: (choice) => _selectChoice(choice),
                    ),
                    ScenePlayerPhase.ended => _StoryEndPanel(key: const ValueKey('ended'), onBack: () => context.pop()),
                    _ => _DialogueSection(
                      key: ValueKey('dialogue-${scene.id}-${state.dialogueIndex}'),
                      state: state,
                      onTalkToCharacter: scene.freeDialogEnabled ? _openFreeDialog : null,
                    ),
                  },
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SceneTopBar(
                  onBack: () => context.pop(),
                  onShowLog: () =>
                      showSceneLogSheet(context, lines: state.lines.take(state.dialogueIndex + 1).toList()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectChoice(Choice choice) async {
    try {
      final transition = await widget.notifier.submitChoice(choice);
      if (!mounted) return;
      unawaited(ref.read(walletBalanceProvider.notifier).refresh());

      final next = transition.next;
      if (next == null) {
        // A paid scene: only a fresh route can show its unlock prompt.
        context.pushReplacement(
          '/play/${transition.sceneId}',
          extra: ScenePlayerArgs(storyId: widget.sceneKey.args?.storyId ?? ''),
        );
        return;
      }

      // Hold the current scene until the next one's opening frame can be
      // drawn, so the change is a crossfade between two finished pictures.
      await _precacheOpeningFrame(next);
      if (mounted) widget.notifier.show(next);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('errors.unknownError'.tr())));
      }
    }
  }

  Future<void> _precacheOpeningFrame(ScenePlayerState next) async {
    final first = next.lines.firstOrNull;
    final urls = {
      first?.backgroundUrl ?? next.scene?.backgroundUrl,
      first?.spriteUrl,
    }.nonNulls.where((u) => u.isNotEmpty);
    await Future.wait([
      for (final url in urls) precacheImage(NetworkImage(url), context, onError: (_, _) {}),
    ]).timeout(_artTimeout, onTimeout: () => const []);
  }

  void _openFreeDialog() {
    setState(() {
      _freeDialogCharacterName = widget.state.currentLine?.speakerName ?? '';
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
                label: Text('scenePlayer.talkTo'.tr(args: [line?.speakerName ?? ''])),
              ),
            ),
          ),
        DialogueBox(
          speaker: line?.speakerName ?? '',
          text: line?.text ?? '',
          style: switch (line) {
            DialogueLine(isThought: true) => DialogueStyle.thought,
            DialogueLine(isNarration: true) => DialogueStyle.narration,
            _ => DialogueStyle.speech,
          },
        ),
      ],
    );
  }
}

/// Shown instead of the dialogue box on a story's last scene, once its
/// script is over — otherwise the player is left tapping a scene that no
/// longer responds.
class _StoryEndPanel extends StatelessWidget {
  const _StoryEndPanel({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final skin = ScenePlayerSkin.of(context);
    final textTheme = Theme.of(context).textTheme;
    return SkinPanel(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'scenePlayer.endTitle'.tr(),
              style: skin.bodyStyle(textTheme.titleLarge)?.copyWith(color: skin.textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'scenePlayer.endBody'.tr(),
              style: skin.bodyStyle(textTheme.bodyMedium)?.copyWith(color: skin.narrationColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SkinButton(onPressed: onBack, child: Text('scenePlayer.backToStory'.tr())),
          ],
        ),
      ),
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
