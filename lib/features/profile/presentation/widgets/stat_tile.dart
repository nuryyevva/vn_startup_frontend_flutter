import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';

/// One tile of the profile screen's 2x2 stats grid. [value] is `null` for
/// stats the backend doesn't track yet (day streak, hours read — see
/// project spec §11.4) and renders as an em dash instead of a fabricated
/// number.
class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.icon, required this.value, required this.label, this.comingSoon = false});

  final IconData icon;
  final String? value;
  final String label;
  final bool comingSoon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colors.accent),
          const SizedBox(height: 8),
          Text(value ?? '—', style: textTheme.titleLarge),
          const SizedBox(height: 2),
          Row(
            children: [
              Flexible(
                child: Text(label, style: textTheme.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              if (comingSoon) ...[
                const SizedBox(width: 4),
                Icon(LucideIcons.clock, size: 12, color: colors.textMuted),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
