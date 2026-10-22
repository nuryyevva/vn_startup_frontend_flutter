import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/coming_soon_snack_bar.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';
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
                  isPurchasing: _purchasingBundleId == bundle.id,
                  onBuy: () => _get(bundle.id, bundle.diamonds),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Diamonds can't be bought yet: an admin can top a wallet up, for
  /// everyone else getting more is "coming soon" — said right away, with no
  /// request. The server checks the role on its own either way.
  Future<void> _get(String bundleId, int diamonds) async {
    final role = await ref.read(userProfileNotifierProvider.future).then((p) => p.role, onError: (_) => null);
    if (role != 'admin') {
      _showComingSoon();
      return;
    }

    setState(() => _purchasingBundleId = bundleId);
    try {
      final granted = await ref.read(walletRepositoryProvider).devGrant(diamonds);
      ref.read(walletBalanceProvider.notifier).applyOptimisticDelta(granted);
      _showSnack(Text('shop.purchaseSuccess'.tr(args: ['$granted'])));
    } on Object catch (error) {
      final mapped = error is DioException ? mapDioException(error) : error;
      if (mapped is TopUpUnavailableException) {
        _showComingSoon();
      } else {
        _showSnack(Text('shop.purchaseFailed'.tr()));
      }
    } finally {
      if (mounted) setState(() => _purchasingBundleId = null);
    }
  }

  void _showComingSoon() {
    if (mounted) showComingSoonSnackBar(context, 'shop.comingSoon'.tr());
  }

  void _showSnack(Widget content) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: content, behavior: SnackBarBehavior.floating));
  }
}
