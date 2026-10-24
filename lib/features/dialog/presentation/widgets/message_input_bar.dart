import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';

/// The longest message the backend accepts in a free dialog (`dialog.MaxMessageLength`); a longer text is refused
/// there, so the field stops it here.
const maxMessageLength = 1000;

/// Text field + send button. The button carries the price of a message
/// ([messageCost], from the session — the backend's own number) as a quiet
/// part of itself, "send · 10 💎": what it costs is visible before sending,
/// without a warning or a confirmation step around it. Disables itself while
/// a send is in flight.
class MessageInputBar extends StatefulWidget {
  const MessageInputBar({super.key, required this.onSend, required this.enabled, this.messageCost});

  final ValueChanged<String> onSend;
  final bool enabled;

  /// Diamonds per message; null hides the price (an older backend).
  final int? messageCost;

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty || !widget.enabled) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: widget.enabled,
                maxLength: maxMessageLength,
                // The counter only shows when the limit is near, so it does not clutter every message.
                buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>
                    currentLength > maxMessageLength * 0.8 ? Text('$currentLength / $maxLength') : null,
                decoration: InputDecoration(hintText: 'dialog.messageHint'.tr()),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submit(),
              ),
            ),
            const SizedBox(width: 8),
            _SendButton(enabled: widget.enabled, messageCost: widget.messageCost, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.enabled, required this.messageCost, required this.onPressed});

  final bool enabled;
  final int? messageCost;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = enabled ? Colors.white : colors.textMuted;
    final cost = messageCost;
    final label = cost == null ? 'dialog.send'.tr() : 'dialog.sendWithCost'.tr(args: ['$cost']);

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: enabled ? colors.accent : colors.accentMuted,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: cost == null ? 12 : 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.send, size: 18, color: foreground),
                if (cost != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    '$cost',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: foreground, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 3),
                  Icon(LucideIcons.gem, size: 14, color: foreground),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
