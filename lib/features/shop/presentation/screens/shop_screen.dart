import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../wallet/presentation/providers/wallet_balance_provider.dart';
import '../widgets/diamond_bundle_card.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  String? _purchasingBundleId;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final config = ref.watch(appConfigProvider);
    final balanceAsync = ref.watch(walletBalanceProvider);
    final isDevMode = config.enableDevWalletGrant;

    return Scaffold(
      appBar: AppBar(title: Text('nav.shop'.tr())),
      body: RefreshIndicator(
        onRefresh: () => ref.read(walletBalanceProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                children: [
                  Icon(LucideIcons.gem, size: 40, color: colors.accent),
                  const SizedBox(height: 8),
                  balanceAsync.when(
                    data: (balance) => Text('$balance', style: textTheme.displayLarge),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stackTrace) => Text('—', style: textTheme.displayLarge),
                  ),
                  const SizedBox(height: 4),
                  Text('shop.yourBalance'.tr(), style: textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('shop.diamondBundles'.tr(), style: textTheme.titleLarge),
            const SizedBox(height: 16),
            for (final bundle in config.diamondBundles)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DiamondBundleCard(
                  bundle: bundle,
                  isDevMode: isDevMode,
                  isPurchasing: _purchasingBundleId == bundle.id,
                  onBuy: isDevMode ? () => _buy(bundle.id, bundle.diamonds) : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _buy(String bundleId, int diamonds) async {
    setState(() => _purchasingBundleId = bundleId);
    try {
      // TODO: replace with a real payment flow once a PaymentProvider
      // exists on the backend — this dev-grant endpoint is a deliberate,
      // temporary stand-in (see project README "known limitations").
      final granted = await ref.read(walletRepositoryProvider).devGrant(diamonds);
      ref.read(walletBalanceProvider.notifier).applyOptimisticDelta(granted);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('shop.purchaseSuccess'.tr(args: ['$granted']))));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('shop.purchaseFailed'.tr())));
      }
    } finally {
      if (mounted) setState(() => _purchasingBundleId = null);
    }
  }
}
