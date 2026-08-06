import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:nocturne/core/config/app_config.dart';
import 'package:nocturne/features/auth/presentation/screens/auth_screen.dart';

import 'golden_helpers.dart';

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
  enableDevWalletGrant: true,
  termsPrivacyUrl: 'https://example.com',
);

void main() {
  testGoldens('AuthScreen — light', (tester) async {
    await pumpGolden(
      tester,
      'auth_screen_light',
      brightness: Brightness.light,
      surfaceSize: const Size(400, 700),
      overrides: [appConfigProvider.overrideWithValue(_testConfig)],
      child: const AuthScreen(),
    );
  });
}
