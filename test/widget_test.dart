import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nocturne/app.dart';
import 'package:nocturne/core/config/app_config.dart';
import 'package:nocturne/features/settings/presentation/providers/theme_mode_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App boots to the auth screen and shows the configured app name', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await EasyLocalization.ensureInitialized();

    const config = AppConfig(
      appName: 'Nocturne Test',
      environment: AppEnvironment.dev,
      apiBaseUrl: 'http://localhost:8080',
      wsBaseUrl: 'ws://localhost:8080',
      apiTimeout: Duration(seconds: 10),
      tokenRefreshMargin: Duration(seconds: 30),
      storiesPageSize: 10,
      defaultLocale: 'en',
      supportedLocales: ['en', 'ru'],
      defaultThemeMode: ThemeMode.dark,
      enableDevWalletGrant: true,
      termsPrivacyUrl: 'https://example.com',
    );

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ru')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        startLocale: const Locale('en'),
        child: ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(config),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const LoveCityApp(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nocturne Test'), findsOneWidget);
  });
}
