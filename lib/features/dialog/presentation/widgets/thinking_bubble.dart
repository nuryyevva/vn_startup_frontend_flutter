import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Shown in the chat between the player's message and the first chunk of the character's reply: a small spinner,
/// how long the reply has been awaited and how long it usually takes, so a slow model doesn't look like a hang.
class ThinkingBubble extends StatefulWidget {
  const ThinkingBubble({super.key, required this.characterName, required this.since});

  final String characterName;
  final DateTime since;

  @override
  State<ThinkingBubble> createState() => _ThinkingBubbleState();
}

class _ThinkingBubbleState extends State<ThinkingBubble> {
  static const _slowAfterSeconds = 60;

  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final seconds = DateTime.now().difference(widget.since).inSeconds;
    final name = widget.characterName.isEmpty ? 'dialog.thinkingFallbackName'.tr() : widget.characterName;
    final hint = seconds >= _slowAfterSeconds ? 'dialog.thinkingSlow'.tr() : 'dialog.thinkingHint'.tr();

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(18)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: colors.textSecondary),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${'dialog.thinking'.tr(args: [name])} ${'dialog.seconds'.tr(args: [seconds.toString()])}',
                    style: textTheme.bodyMedium?.copyWith(color: colors.textPrimary),
                  ),
                  Text(hint, style: textTheme.bodySmall?.copyWith(color: colors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
