import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/config/diamond_bundle_config.dart';
import '../../../../core/theme/app_colors.dart';

/// One bundle row in the shop list. Its button says "get", not a price:
/// there are no payments yet — see the shop screen for what a tap does.
///
/// Horizontal layout: gem count on the left, buy button on the right. The
/// highlight badge (when present) floats above the card's top-right corner
/// as a little tab, via [Stack]/[Positioned] rather than sitting inline —
/// same badge styling as before, just repositioned for the wider card.
class DiamondBundleCard extends StatelessWidget {
  const DiamondBundleCard({super.key, required this.bundle, required this.isPurchasing, required this.onBuy});

  final DiamondBundleConfig bundle;
  final bool isPurchasing;
  final VoidCallback? onBuy;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final hasBadge = bundle.badgeLabelKey != null;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.only(top: hasBadge ? 10 : 0),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              Icon(LucideIcons.gem, size: 28, color: colors.accent),
              const SizedBox(width: 12),
              Text('${bundle.diamonds}', style: textTheme.headlineLarge?.copyWith(fontSize: 22)),
              if (bundle.bonusPercent > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: colors.accentMuted, borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    'shop.bonus'.tr(args: ['${bundle.bonusPercent}']),
                    style: textTheme.labelSmall?.copyWith(color: colors.accent, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
              const Spacer(),
              ElevatedButton(
                onPressed: isPurchasing ? null : onBuy,
                child: isPurchasing
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text('shop.get'.tr()),
              ),
            ],
          ),
        ),
        if (hasBadge)
          Positioned(
            top: 0,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: colors.accent, borderRadius: BorderRadius.circular(6)),
              child: Text(
                bundle.badgeLabelKey!.tr(),
                style: textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
      ],
    );
  }
}
