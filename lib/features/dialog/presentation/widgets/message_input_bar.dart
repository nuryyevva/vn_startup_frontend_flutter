import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';

/// Text field + send button. Shows a diamond hint icon (not an exact
/// price — the backend's per-message cost is a flat server-side config
/// value never exposed to the client ahead of time; the real charge only
/// appears after sending, on the message's `cost_diamonds`) and disables
/// itself while a send is in flight.
class MessageInputBar extends StatefulWidget {
  const MessageInputBar({super.key, required this.onSend, required this.enabled});

  final ValueChanged<String> onSend;
  final bool enabled;

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
    final colors = context.colors;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(LucideIcons.gem, size: 16, color: colors.accent),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: widget.enabled,
                decoration: InputDecoration(hintText: 'dialog.messageHint'.tr()),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submit(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: widget.enabled ? _submit : null,
              icon: Icon(LucideIcons.send, color: widget.enabled ? colors.accent : colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
