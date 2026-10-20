import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/media/media_source.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/motion.dart';
import '../../../dialog/presentation/providers/dialog_session_provider.dart';
import '../../../dialog/presentation/widgets/session_ended_dialog.dart';
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
import '../widgets/inline_chat_panel.dart';
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
  /// Free conversation with the scene's character (only in scenes the author enabled it for): the session is started
  /// the first time the player picks the talk option and kept until the scene changes, so going back to the
  /// scripted choices and returning to the chat doesn't lose the conversation.
  bool _chatStarted = false;

  /// The chat panel is shown instead of the scripted choices.
  bool _chatOpen = false;
  bool _chatEndedShown = false;
  DialogSessionNotifier? _chatNotifier;

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
      unawaited(precacheImage(mediaImageProvider(url), context, onError: (_, _) {}));
    }
  }

  @override
  void didUpdateWidget(covariant _ScenePlaybackBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    final sceneChanged = !identical(widget.state.scene, oldWidget.state.scene);
    if (sceneChanged) {
      unawaited(_setMusic(widget.state.scene?.backgroundMusicUrl));
      _precacheArt();
      _endChat();
    }
    if (sceneChanged || widget.state.dialogueIndex != oldWidget.state.dialogueIndex) {
      _maybePlaySfxForLine(widget.state);
    }
  }

  @override
  void dispose() {
    try {
      unawaited(_chatNotifier?.leave());
    } catch (_) {
      // The provider may already be gone; the backend closes an abandoned session by itself.
    }
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
      await _musicPlayer.play(mediaAudioSource(url));
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
      await _sfxPlayer.play(mediaAudioSource(url));
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
    final dialogState = _chatStarted ? ref.watch(dialogSessionProvider) : null;
    _maybeShowChatEnded(dialogState);
    final backgroundUrl = line?.backgroundUrl ?? scene.backgroundUrl;
    // While talking, the character on screen is the scene's own character, in the sprite the AI picked for the
    // emotion of its latest reply (the scene's script may have last shown somebody else).
    final spriteUrl = _chatOpen
        ? (dialogState?.spriteUrl ?? scene.characterSpriteUrl)
        : (line == null ? scene.characterSpriteUrl : line.spriteUrl);
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
        _buildScene(context, state, notifier, scene, balance, backgroundUrl, spriteUrl, characterSprite, dialogState),
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
    DialogSessionState? dialogState,
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
                    ScenePlayerPhase.choices when _chatOpen && _canTalk(scene, dialogState) => InlineChatPanel(
                      key: const ValueKey('chat'),
                      characterName: _partnerName(scene, state.lines) ?? '',
                      state: dialogState,
                      onSend: _sendChatMessage,
                      onBackToChoices: () => setState(() => _chatOpen = false),
                    ),
                    ScenePlayerPhase.choices => ChoicesPanel(
                      key: const ValueKey('choices'),
                      choices: scene.choices,
                      walletBalance: balance,
                      pendingChoiceId: state.pendingChoiceId,
                      onSelect: (choice) => _selectChoice(choice),
                      onTalk: _canTalk(scene, dialogState) ? () => _openChat(scene) : null,
                      talkLabel: _talkLabel(_partnerName(scene, state.lines)),
                    ),
                    ScenePlayerPhase.ended => _StoryEndPanel(key: const ValueKey('ended'), onBack: () => context.pop()),
                    _ => _DialogueSection(key: ValueKey('dialogue-${scene.id}-${state.dialogueIndex}'), state: state),
                  },
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SceneTopBar(
                  onBack: () => context.pop(),
                  onShowLog: () => showSceneLogSheet(context, lines: _logLines(scene, state, dialogState)),
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
      for (final url in urls) precacheImage(mediaImageProvider(url), context, onError: (_, _) {}),
    ]).timeout(_artTimeout, onTimeout: () => const []);
  }

  /// Name of the character a free dialog in [scene] would be held with: whoever speaks under the scene's own
  /// character sprite. Null when no line of the scene shows them (a pure hub beat).
  String? _partnerName(Scene scene, List<DialogueLine> lines) {
    final partnerSprite = scene.characterSpriteUrl;
    if (partnerSprite == null) return null;
    for (final line in lines) {
      if (line.spriteUrl == partnerSprite && line.speakerName.isNotEmpty) return line.speakerName;
    }
    return null;
  }

  /// What the scene's history shows: the script read so far, then the free conversation held in this scene (the
  /// player's own lines and the character's replies), so nothing said out loud is missing from the log.
  List<DialogueLine> _logLines(Scene scene, ScenePlayerState state, DialogSessionState? dialogState) {
    final lines = state.lines.take(state.dialogueIndex + 1).toList();
    final messages = dialogState?.messages ?? const [];
    if (messages.isEmpty) return lines;
    final partner = _partnerName(scene, state.lines) ?? 'dialog.thinkingFallbackName'.tr();
    return [
      ...lines,
      for (final message in messages)
        DialogueLine(speaker: message.sender == 'user' ? 'dialog.you'.tr() : partner, text: message.text),
    ];
  }

  /// The talk option is offered only in the scenes the story's author marked for a free conversation (the
  /// character stays in the scene for its whole length) and only while the conversation hasn't been ended by its
  /// limit; in every other scene it never appears.
  bool _canTalk(Scene scene, DialogSessionState? dialogState) =>
      scene.freeDialogEnabled && scene.characterId != null && !(dialogState?.isSessionEnded ?? false);

  String _talkLabel(String? name) =>
      name == null || name.isEmpty ? 'scenePlayer.talkToGeneric'.tr() : 'scenePlayer.talkTo'.tr(args: [name]);

  void _openChat(Scene scene) {
    final first = !_chatStarted;
    setState(() {
      _chatStarted = true;
      _chatOpen = true;
    });
    if (!first) return;
    // After the frame: by then build() is watching the provider, so it can't be disposed before the session starts.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_chatStarted) return;
      _chatNotifier = ref.read(dialogSessionProvider.notifier);
      unawaited(_chatNotifier!.start(scene.characterId!, scene.id).catchError(_failChatStart));
    });
  }

  void _failChatStart(Object error) {
    if (!mounted) return;
    setState(() {
      _chatStarted = false;
      _chatOpen = false;
    });
    _showError(error);
  }

  Future<void> _sendChatMessage(String text) async {
    try {
      await ref.read(dialogSessionProvider.notifier).sendMessage(text);
    } catch (error) {
      _showError(error);
    }
  }

  /// The backend's reason, in words (e.g. not enough diamonds for another message), not a bare "something went
  /// wrong"; anything unrecognised falls back to the generic text.
  void _showError(Object error) {
    if (!mounted) return;
    final message = error is AppException ? error.localizedMessage() : 'errors.unknownError'.tr();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Leaves the conversation when the scene changes: the session is closed on the backend and the choices come back.
  void _endChat() {
    if (_chatStarted) {
      try {
        unawaited(_chatNotifier?.leave());
      } catch (_) {
        // Already disposed: nothing left to close on this side.
      }
    }
    _chatStarted = false;
    _chatOpen = false;
    _chatEndedShown = false;
    _chatNotifier = null;
  }

  /// The conversation ran into its limit (messages or time): say so once, then the choices take over again.
  void _maybeShowChatEnded(DialogSessionState? dialogState) {
    if (dialogState == null || !dialogState.isSessionEnded || dialogState.endReason == null || _chatEndedShown) return;
    _chatEndedShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => SessionEndedDialog(
          reason: dialogState.endReason!,
          characterName: _partnerName(widget.state.scene!, widget.state.lines) ?? '',
          onBackToStory: () {
            Navigator.of(dialogContext).pop();
            if (mounted) setState(() => _chatOpen = false);
          },
        ),
      );
    });
  }
}
class _DialogueSection extends StatelessWidget {
  const _DialogueSection({super.key, required this.state});

  final ScenePlayerState state;

  @override
  Widget build(BuildContext context) {
    final line = state.currentLine;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
