import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/motion.dart';

/// A single genre/filter chip: filled accent when [selected], outline
/// otherwise. Purely presentational — the caller owns selection state.
class GenreChip extends StatelessWidget {
  const GenreChip({super.key, required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: AnimatedContainer(
          duration: Motion.microDuration,
          curve: Motion.microCurve,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? colors.accent : Colors.transparent,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: selected ? colors.accent : colors.border),
          ),
          child: AnimatedDefaultTextStyle(
            duration: Motion.microDuration,
            curve: Motion.microCurve,
            style:
                textTheme.labelMedium?.copyWith(
                  color: selected ? Colors.white : colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ) ??
                const TextStyle(),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
