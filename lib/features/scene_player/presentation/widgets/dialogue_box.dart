import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Semi-transparent panel: speaker name + line text, tap-anywhere-on-scene
/// to advance (project spec §8.4 layer 3). Text appears whole — no
/// typewriter effect; that's reserved for the free-dialogue WS stream
/// (§8.5), not this static, pre-authored script.
class DialogueBox extends StatelessWidget {
  const DialogueBox({super.key, required this.speaker, required this.text});

  final String speaker;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.92),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (speaker.isNotEmpty && speaker != 'narrator')
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                speaker,
                style: textTheme.titleMedium?.copyWith(color: colors.accent, fontWeight: FontWeight.w700),
              ),
            ),
          Text(
            text,
            style: speaker == 'narrator'
                ? textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic, color: colors.textSecondary)
                : textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
