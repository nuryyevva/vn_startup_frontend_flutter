import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';

/// Semi-transparent scrim + lock icon (and optional diamond cost) over a
/// paid, not-yet-unlocked chapter's cover or list row.
class LockedOverlay extends StatelessWidget {
  const LockedOverlay({super.key, this.costDiamonds, this.compact = false});

  final int? costDiamonds;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      color: colors.lockOverlay,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.lock, color: Colors.white, size: compact ? 18 : 28),
          if (costDiamonds != null) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.gem, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text(
                  '$costDiamonds',
                  style: textTheme.labelMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
