import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'features/settings/presentation/providers/theme_mode_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final config = AppConfig.fromEnvironment();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    EasyLocalization(
      supportedLocales: config.supportedLocales.map(Locale.new).toList(),
      path: 'assets/translations',
      fallbackLocale: Locale(config.defaultLocale),
      startLocale: Locale(config.defaultLocale),
      child: ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(config),
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const LoveCityApp(),
      ),
    ),
  );
}
