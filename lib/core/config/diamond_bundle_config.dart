/// A purchasable diamond bundle shown in the shop. The backend has no
/// bundle catalog endpoint (see project README, "known limitations"), so
/// this list is a static product-catalog constant compiled into the app.
class DiamondBundleConfig {
  const DiamondBundleConfig({
    required this.id,
    required this.diamonds,
    required this.bonusPercent,
    required this.priceUsd,
    this.badgeLabelKey,
  });

  final String id;
  final int diamonds;
  final int bonusPercent;
  final double priceUsd;

  /// Localization key for an optional highlight badge (e.g. "Most Popular").
  /// Null means no badge is shown.
  final String? badgeLabelKey;
}

const List<DiamondBundleConfig> kDiamondBundles = [
  DiamondBundleConfig(id: 'bundle_100', diamonds: 100, bonusPercent: 0, priceUsd: 0.99),
  DiamondBundleConfig(id: 'bundle_550', diamonds: 550, bonusPercent: 10, priceUsd: 4.99),
  DiamondBundleConfig(
    id: 'bundle_1200',
    diamonds: 1200,
    bonusPercent: 15,
    priceUsd: 9.99,
    badgeLabelKey: 'shop.badge.mostPopular',
  ),
  DiamondBundleConfig(
    id: 'bundle_2600',
    diamonds: 2600,
    bonusPercent: 20,
    priceUsd: 19.99,
    badgeLabelKey: 'shop.badge.bestValue',
  ),
  DiamondBundleConfig(id: 'bundle_6500', diamonds: 6500, bonusPercent: 25, priceUsd: 44.99),
  DiamondBundleConfig(id: 'bundle_14000', diamonds: 14000, bonusPercent: 30, priceUsd: 89.99),
];
