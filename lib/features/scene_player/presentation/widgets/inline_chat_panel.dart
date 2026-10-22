import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../dialog/domain/models/dialog_message.dart';
import '../../../dialog/presentation/providers/dialog_session_provider.dart';
import '../../../dialog/presentation/widgets/message_bubble.dart';
import '../../../dialog/presentation/widgets/message_input_bar.dart';
import '../../../dialog/presentation/widgets/session_limit_badge.dart';
import '../../../dialog/presentation/widgets/thinking_bubble.dart';
import '../theme/scene_player_skin.dart';
import 'dialogue_box.dart';
import 'skin_panel.dart';

/// Free conversation inside the scene, in place of the choices: the character's latest line sits in the usual
/// dialogue box (so the character stays on screen behind it), the player's input is below, and a small,
/// unobtrusive link returns to the scripted choices. The session stays open when the player goes back, so
/// the talk can be resumed where it stopped.
class InlineChatPanel extends StatelessWidget {
  const InlineChatPanel({
    super.key,
    required this.characterName,
    required this.state,
    required this.onSend,
    required this.onBackToChoices,
  });

  final String characterName;

  /// Null while the session is still being started.
  final DialogSessionState? state;
  final ValueChanged<String> onSend;
  final VoidCallback onBackToChoices;

  @override
  Widget build(BuildContext context) {
    final s = state;
    final name = characterName.isEmpty ? 'dialog.thinkingFallbackName'.tr() : characterName;
    final canSend = s != null && !s.isSessionEnded && s.awaitingReplySince == null && !s.isSending;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TopRow(
          state: s,
          onBackToChoices: onBackToChoices,
          onShowHistory: () => _showHistory(context, name, s?.messages ?? const []),
        ),
        _LastPlayerLine(text: _lastPlayerText(s)),
        _CharacterLine(name: name, state: s),
        SkinPanel(
          padding: EdgeInsets.zero,
          child: MessageInputBar(enabled: canSend, onSend: onSend, messageCost: s?.session.messageCost),
        ),
      ],
    );
  }

  String? _lastPlayerText(DialogSessionState? s) {
    if (s == null) return null;
    for (final message in s.messages.reversed) {
      if (message.sender == 'user') return message.text;
      // A character line after the player's: their own words are already answered, nothing to repeat.
      return null;
    }
    return null;
  }
}

class _TopRow extends StatelessWidget {
  const _TopRow({required this.state, required this.onBackToChoices, required this.onShowHistory});

  final DialogSessionState? state;
  final VoidCallback onBackToChoices;
  final VoidCallback onShowHistory;

  @override
  Widget build(BuildContext context) {
    final skin = ScenePlayerSkin.of(context);
    final s = state;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: Row(
        children: [
          _PillButton(icon: LucideIcons.cornerUpLeft, label: 'dialog.backToChoices'.tr(), onPressed: onBackToChoices),
          const SizedBox(width: 6),
          _PillButton(icon: LucideIcons.history, label: 'dialog.history'.tr(), onPressed: onShowHistory),
          const Spacer(),
          if (s != null) SessionLimitBadge(limitType: s.session.limitType, remaining: s.remainingLimit),
          if (s == null) SizedBox.square(dimension: 14, child: CircularProgressIndicator(strokeWidth: 2, color: skin.accentColor)),
        ],
      ),
    );
  }
}

/// The player's last line, small and out of the way, so it's clear what the character is answering.
class _LastPlayerLine extends StatelessWidget {
  const _LastPlayerLine({required this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    if (text == null) return const SizedBox.shrink();
    final colors = context.colors;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.fromLTRB(48, 0, 16, 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: colors.accent, borderRadius: BorderRadius.circular(16)),
        child: Text(text!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
      ),
    );
  }
}

/// What the character says now: the reply as it streams in, a "thinking" row while it is awaited, the last
/// finished reply, or an invitation to speak when there is nothing yet.
class _CharacterLine extends StatelessWidget {
  const _CharacterLine({required this.name, required this.state});

  final String name;
  final DialogSessionState? state;

  @override
  Widget build(BuildContext context) {
    final s = state;
    if (s != null && s.streamingBuffer != null) {
      return DialogueBox(speaker: name, text: s.streamingBuffer!);
    }
    if (s != null && s.awaitingReplySince != null) {
      return SkinPanel(
        child: Align(
          alignment: Alignment.centerLeft,
          child: ThinkingBubble(characterName: name, since: s.awaitingReplySince!),
        ),
      );
    }
    final lastReply = s?.messages.lastWhereOrNull((m) => m.sender == 'character');
    if (lastReply != null) return DialogueBox(speaker: name, text: lastReply.text);
    return DialogueBox(
      speaker: '',
      text: 'dialog.inlineHint'.tr(args: [name]),
      style: DialogueStyle.narration,
    );
  }
}

extension _LastWhere<T> on List<T> {
  T? lastWhereOrNull(bool Function(T) test) {
    for (final item in reversed) {
      if (test(item)) return item;
    }
    return null;
  }
}

/// A small translucent pill over the scene: unobtrusive controls that don't compete with the dialogue box.
class _PillButton extends StatelessWidget {
  const _PillButton({required this.icon, required this.label, required this.onPressed});

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 14),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: Colors.white.withValues(alpha: 0.85),
        backgroundColor: Colors.black38,
        visualDensity: VisualDensity.compact,
        textStyle: Theme.of(context).textTheme.labelMedium,
        shape: const StadiumBorder(),
      ),
    );
  }
}

/// The conversation so far (this session), oldest first, in a sheet over the scene.
void _showHistory(BuildContext context, String characterName, List<DialogMessage> messages) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (_, controller) => messages.isEmpty
          ? Center(child: Text('dialog.historyEmpty'.tr(), style: Theme.of(sheetContext).textTheme.bodyMedium))
          : ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: [
                for (final message in messages) ...[
                  if (message.sender != 'user')
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 4),
                      child: Text(characterName, style: Theme.of(sheetContext).textTheme.labelMedium),
                    ),
                  MessageBubble(text: message.text, isUser: message.sender == 'user'),
                ],
              ],
            ),
    ),
  );
}