import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/genres.dart';
import 'diamond_bundle_config.dart';

enum AppEnvironment { dev, staging, prod }

/// Single source of truth for every environment-dependent or otherwise
/// globally-configurable value in the app. Nothing else in the codebase
/// should hardcode a base URL, timeout, page size, or theme default —
/// read it from here via [appConfigProvider] instead.
///
/// Built once in `main.dart` from `--dart-define-from-file`, then injected
/// through `ProviderScope(overrides: [appConfigProvider.overrideWithValue(...)])`.
class AppConfig {
  const AppConfig({
    required this.appName,
    required this.environment,
    required this.apiBaseUrl,
    required this.wsBaseUrl,
    required this.apiTimeout,
    required this.tokenRefreshMargin,
    required this.storiesPageSize,
    required this.defaultLocale,
    required this.supportedLocales,
    required this.defaultThemeMode,
    required this.enableDevWalletGrant,
    required this.termsPrivacyUrl,
    this.offline = false,
    this.diamondBundles = kDiamondBundles,
    this.genres = kGenres,
  });

  final String appName;
  final AppEnvironment environment;
  final String apiBaseUrl;
  final String wsBaseUrl;
  final Duration apiTimeout;

  /// How long before an access token expires to start a silent refresh.
  final Duration tokenRefreshMargin;
  final int storiesPageSize;
  final String defaultLocale;
  final List<String> supportedLocales;
  final ThemeMode defaultThemeMode;

  /// Mirrors the backend's `ENABLE_DEV_ENDPOINTS` flag — gates the
  /// temporary "buy with dev grant" flow in the shop (see §11.5 of the
  /// project spec / README "known limitations").
  final bool enableDevWalletGrant;
  final String termsPrivacyUrl;

  /// Run without a server: stories from the app bundle, the player's state
  /// on the device (see `features/offline`). `apiBaseUrl`/`wsBaseUrl` are
  /// never used in this mode. Needs the `offline` flavor, which is what
  /// bundles the content.
  final bool offline;
  final List<DiamondBundleConfig> diamondBundles;
  final List<GenreConfig> genres;

  factory AppConfig.fromEnvironment() {
    const appName = String.fromEnvironment('APP_NAME', defaultValue: 'Город любви');
    const envRaw = String.fromEnvironment('APP_ENV', defaultValue: 'development');
    const apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8080');
    const wsBaseUrl = String.fromEnvironment('WS_BASE_URL', defaultValue: 'ws://localhost:8080');
    const apiTimeoutMs = int.fromEnvironment('API_TIMEOUT_MS', defaultValue: 10000);
    const tokenRefreshMarginMs = int.fromEnvironment('TOKEN_REFRESH_MARGIN_MS', defaultValue: 30000);
    const storiesPageSize = int.fromEnvironment('STORIES_PAGE_SIZE', defaultValue: 10);
    const defaultLocale = String.fromEnvironment('DEFAULT_LOCALE', defaultValue: 'ru');
    const supportedLocalesRaw = String.fromEnvironment('SUPPORTED_LOCALES', defaultValue: 'ru,en');
    const defaultThemeModeRaw = String.fromEnvironment('DEFAULT_THEME_MODE', defaultValue: 'dark');
    const enableDevWalletGrant = bool.fromEnvironment('ENABLE_DEV_WALLET_GRANT');
    const offline = bool.fromEnvironment('OFFLINE_MODE');
    const termsPrivacyUrl = String.fromEnvironment(
      'TERMS_PRIVACY_URL',
      defaultValue: 'https://example.com/legal/terms',
    );

    return AppConfig(
      appName: appName,
      environment: _parseEnvironment(envRaw),
      apiBaseUrl: apiBaseUrl,
      wsBaseUrl: wsBaseUrl,
      apiTimeout: const Duration(milliseconds: apiTimeoutMs),
      tokenRefreshMargin: const Duration(milliseconds: tokenRefreshMarginMs),
      storiesPageSize: storiesPageSize,
      defaultLocale: defaultLocale,
      supportedLocales: _splitCsv(supportedLocalesRaw),
      defaultThemeMode: _parseThemeMode(defaultThemeModeRaw),
      enableDevWalletGrant: enableDevWalletGrant,
      termsPrivacyUrl: termsPrivacyUrl,
      offline: offline,
    );
  }

  static List<String> _splitCsv(String raw) =>
      raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(growable: false);

  static AppEnvironment _parseEnvironment(String raw) {
    switch (raw) {
      case 'production':
        return AppEnvironment.prod;
      case 'staging':
        return AppEnvironment.staging;
      default:
        return AppEnvironment.dev;
    }
  }

  static ThemeMode _parseThemeMode(String raw) {
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.dark;
    }
  }
}

/// Must be overridden in `ProviderScope(overrides: [...])` at app startup —
/// there is no sensible default, reading it before that override lands is
/// a programming error and should fail loudly.
final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError(
    'appConfigProvider was read before ProviderScope overrode it with a real AppConfig — '
    'see main.dart',
  );
});
