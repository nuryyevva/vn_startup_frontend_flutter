import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/config/diamond_bundle_config.dart';
import '../../../../core/theme/app_colors.dart';

/// One bundle tile in the shop grid. [isDevMode] switches the button
/// between the real (currently non-functional — no payment provider
/// exists yet, see README "known limitations") price and the explicit
/// "(dev mode)" free-grant label, so a dev/staging build never implies a
/// real charge is happening.
class DiamondBundleCard extends StatelessWidget {
  const DiamondBundleCard({super.key, required this.bundle, required this.isDevMode, required this.isPurchasing, required this.onBuy});

  final DiamondBundleConfig bundle;
  final bool isDevMode;
  final bool isPurchasing;
  final VoidCallback? onBuy;

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (bundle.badgeLabelKey != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: colors.accent, borderRadius: BorderRadius.circular(6)),
                child: Text(
                  bundle.badgeLabelKey!.tr(),
                  style: textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Icon(LucideIcons.gem, size: 28, color: colors.accent),
          const SizedBox(height: 8),
          Text('${bundle.diamonds}', style: textTheme.headlineLarge?.copyWith(fontSize: 22)),
          if (bundle.bonusPercent > 0)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: colors.accentMuted, borderRadius: BorderRadius.circular(6)),
              child: Text(
                'shop.bonus'.tr(args: ['${bundle.bonusPercent}']),
                style: textTheme.labelSmall?.copyWith(color: colors.accent, fontWeight: FontWeight.w700),
              ),
            ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: isPurchasing ? null : onBuy,
            child: isPurchasing
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(isDevMode ? 'shop.getFreeDevMode'.tr() : '\$${bundle.priceUsd.toStringAsFixed(2)}'),
          ),
        ],
      ),
    );
  }
}
