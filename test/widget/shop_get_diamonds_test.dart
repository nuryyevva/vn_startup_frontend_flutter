import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nocturne/core/config/app_config.dart';
import 'package:nocturne/core/theme/app_theme.dart';
import 'package:nocturne/features/profile/data/user_repository.dart';
import 'package:nocturne/features/profile/domain/models/user_profile.dart';
import 'package:nocturne/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:nocturne/features/shop/presentation/screens/shop_screen.dart';
import 'package:nocturne/features/wallet/data/wallet_repository.dart';
import 'package:nocturne/features/wallet/presentation/providers/wallet_balance_provider.dart';

class _MockWalletRepository extends Mock implements WalletRepository {}

class _MockUserRepository extends Mock implements UserRepository {}

const _config = AppConfig(
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

UserProfile _profile(String role) => UserProfile(
  userId: 'u',
  email: 'reader@example.com',
  role: role,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

Future<_MockWalletRepository> _pumpShop(WidgetTester tester, {required String role}) async {
  tester.view.physicalSize = const Size(900, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final wallet = _MockWalletRepository();
  final users = _MockUserRepository();
  when(wallet.getBalance).thenAnswer((_) async => 600);
  when(() => wallet.devGrant(any())).thenAnswer((invocation) async => invocation.positionalArguments.first as int);
  when(users.getMe).thenAnswer((_) async => _profile(role));

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(_config),
        walletRepositoryProvider.overrideWithValue(wallet),
        userRepositoryProvider.overrideWithValue(users),
      ],
      child: MaterialApp(theme: AppTheme.dark(), home: const ShopScreen()),
    ),
  );
  await tester.pumpAndSettle();
  return wallet;
}

void main() {
  // No EasyLocalization in this test: .tr() returns the key itself.
  testWidgets('a player taps "get": coming soon, and no top-up is even asked for', (tester) async {
    final wallet = await _pumpShop(tester, role: 'user');

    await tester.tap(find.text('shop.get').first);
    await tester.pumpAndSettle();

    expect(find.text('shop.comingSoon'), findsOneWidget);
    verifyNever(() => wallet.devGrant(any()));
  });

  testWidgets('an admin taps "get": the wallet is topped up', (tester) async {
    final wallet = await _pumpShop(tester, role: 'admin');

    await tester.tap(find.text('shop.get').first);
    await tester.pumpAndSettle();

    verify(() => wallet.devGrant(any())).called(1);
    expect(find.text('shop.comingSoon'), findsNothing);
  });
}
