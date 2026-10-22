import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nocturne/core/config/app_config.dart';
import 'package:nocturne/features/shop/presentation/screens/shop_screen.dart';
import 'package:nocturne/features/wallet/data/wallet_repository.dart';
import 'package:nocturne/features/wallet/presentation/providers/wallet_balance_provider.dart';

import 'golden_helpers.dart';

class _MockWalletRepository extends Mock implements WalletRepository {}

const _testConfig = AppConfig(
  appName: 'Nocturne',
  environment: AppEnvironment.dev,
  apiBaseUrl: 'http://localhost:8080',
  wsBaseUrl: 'ws://localhost:8080',
  apiTimeout: Duration(seconds: 10),
  tokenRefreshMargin: Duration(seconds: 30),
  storiesPageSize: 10,
  defaultLocale: 'en',
  supportedLocales: ['en', 'ru'],
  defaultThemeMode: ThemeMode.dark,
  termsPrivacyUrl: 'https://example.com',
);

void main() {
  testGoldens('ShopScreen — dark', (tester) async {
    final walletRepository = _MockWalletRepository();
    when(() => walletRepository.getBalance()).thenAnswer((_) async => 1240);

    await pumpGolden(
      tester,
      'shop_screen_dark',
      surfaceSize: const Size(400, 900),
      overrides: [
        appConfigProvider.overrideWithValue(_testConfig),
        walletRepositoryProvider.overrideWithValue(walletRepository),
      ],
      child: const ShopScreen(),
    );
  });
}
