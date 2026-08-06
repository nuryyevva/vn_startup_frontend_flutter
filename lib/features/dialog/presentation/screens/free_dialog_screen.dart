import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/network/websocket_client.dart';
import '../../../../core/network/websocket_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../providers/dialog_session_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input_bar.dart';
import '../widgets/session_ended_dialog.dart';
import '../widgets/session_limit_badge.dart';

/// Rendered as an overlay *inside* the current scene (a `Positioned.fill`
/// stacked on top of the VN scene's background/character layers), not a
/// separate go_router route — see project spec §8.5 and the architecture
/// doc: closing it returns straight to the still-mounted scene underneath.
class FreeDialogScreen extends ConsumerStatefulWidget {
  const FreeDialogScreen({
    super.key,
    required this.characterId,
    required this.sceneId,
    required this.characterName,
    required this.onClose,
  });

  final String characterId;
  final String sceneId;
  final String characterName;
  final VoidCallback onClose;

  @override
  ConsumerState<FreeDialogScreen> createState() => _FreeDialogScreenState();
}

class _FreeDialogScreenState extends ConsumerState<FreeDialogScreen> {
  final _scrollController = ScrollController();
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      Future.microtask(() => ref.read(dialogSessionProvider.notifier).start(widget.characterId, widget.sceneId));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _closeAndLeave() async {
    await ref.read(dialogSessionProvider.notifier).leave();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dialogSessionProvider);
    final connectionStatus = ref.watch(connectionStatusProvider).valueOrNull;
    final colors = context.colors;

    if (state != null && state.isSessionEnded && state.endReason != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) => SessionEndedDialog(
            reason: state.endReason!,
            characterName: widget.characterName,
            onBackToStory: () {
              Navigator.of(context).pop();
              widget.onClose();
            },
          ),
        );
      });
    }

    _scrollToBottom();

    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    AppIconButton(icon: LucideIcons.x, onTap: _closeAndLeave, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.characterName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                      ),
                    ),
                    if (connectionStatus == WsConnectionStatus.reconnecting)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text('common.reconnecting'.tr(), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ),
                    if (state != null) SessionLimitBadge(limitType: state.session.limitType, remaining: state.remainingLimit),
                  ],
                ),
              ),
              Expanded(
                child: state == null
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(color: colors.background, borderRadius: BorderRadius.circular(20)),
                        child: ListView(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          children: [
                            for (final message in state.messages)
                              MessageBubble(text: message.text, isUser: message.sender == 'user'),
                            if (state.streamingBuffer != null)
                              MessageBubble(text: state.streamingBuffer!, isUser: false, isStreaming: true),
                          ],
                        ),
                      ),
              ),
              if (state != null)
                MessageInputBar(
                  enabled: !state.isSessionEnded && !state.isSending,
                  onSend: (text) => ref.read(dialogSessionProvider.notifier).sendMessage(text),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
