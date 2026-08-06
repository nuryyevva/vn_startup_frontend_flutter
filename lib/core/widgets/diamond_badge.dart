import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';
import 'pressable_scale.dart';
import 'shimmer_placeholder.dart';

/// Diamond icon + balance pill shown in headers. [balance] is `null` while
/// still loading — the caller (via `walletBalanceProvider`) decides that,
/// this widget only renders it.
class DiamondBadge extends StatelessWidget {
  const DiamondBadge({super.key, required this.balance, this.onTap});

  final int? balance;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.gem, size: 16, color: colors.accent),
            const SizedBox(width: 6),
            if (balance == null)
              const SizedBox(
                width: 28,
                height: 14,
                child: ShimmerPlaceholder(borderRadius: BorderRadius.all(Radius.circular(4))),
              )
            else
              Text(
                '$balance',
                style: textTheme.titleMedium?.copyWith(fontSize: 14, color: colors.textPrimary),
              ),
          ],
        ),
      ),
    );
  }
}
