import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/motion.dart';

/// A single chat bubble. [isStreaming] renders [text] as-is — the caller
/// passes the growing `streamingBuffer` in directly, chunk by chunk — with
/// only an [AnimatedSize] around the bubble so its height grows smoothly
/// instead of jumping on every WS chunk (project spec §8.5 / the
/// architecture doc's explicit test requirement).
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.text,
    required this.isUser,
    this.isStreaming = false,
    this.isError = false,
  });

  final String text;
  final bool isUser;
  final bool isStreaming;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    final bubbleColor = isError
        ? colors.error.withValues(alpha: 0.15)
        : isUser
        ? colors.accent
        : colors.surface;
    final textColor = isError ? colors.error : (isUser ? Colors.white : colors.textPrimary);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: AnimatedSize(
        duration: Motion.microDuration,
        alignment: Alignment.topLeft,
        curve: Motion.microCurve,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
          decoration: BoxDecoration(color: bubbleColor, borderRadius: BorderRadius.circular(18)),
          child: Text(text, style: textTheme.bodyMedium?.copyWith(color: textColor)),
        ),
      ),
    );
  }
}
