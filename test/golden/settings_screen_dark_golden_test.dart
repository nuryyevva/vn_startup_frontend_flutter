import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nocturne/core/config/app_config.dart';
import 'package:nocturne/features/profile/data/user_repository.dart';
import 'package:nocturne/features/profile/domain/models/user_profile.dart';
import 'package:nocturne/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:nocturne/features/settings/presentation/providers/theme_mode_provider.dart';
import 'package:nocturne/features/settings/presentation/screens/settings_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'golden_helpers.dart';

class _MockUserRepository extends Mock implements UserRepository {}

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
  testGoldens('SettingsScreen — dark', (tester) async {
    PackageInfo.setMockInitialValues(
      appName: 'Nocturne',
      packageName: 'com.nocturne.nocturne',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final userRepository = _MockUserRepository();
    when(() => userRepository.getMe()).thenAnswer(
      (_) async => UserProfile(
        userId: 'u1',
        email: 'wren.castellan@example.com',
        role: 'user',
        createdAt: DateTime(2024, 3, 1),
        updatedAt: DateTime(2024, 3, 1),
        theme: 'dark',
        language: 'en',
      ),
    );

    await pumpGolden(
      tester,
      'settings_screen_dark',
      surfaceSize: const Size(400, 900),
      overrides: [
        appConfigProvider.overrideWithValue(_testConfig),
        sharedPreferencesProvider.overrideWithValue(prefs),
        userRepositoryProvider.overrideWithValue(userRepository),
      ],
      child: const SettingsScreen(),
    );
  });
}
