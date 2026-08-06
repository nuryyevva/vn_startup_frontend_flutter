import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/config/app_config.dart';

/// Overridden in `main.dart` with the `SharedPreferences` instance obtained
/// before `runApp`. Non-critical settings (theme choice) live here, not in
/// `flutter_secure_storage` — that's reserved for tokens (see
/// `SecureTokenStorage`).
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider was read before main.dart overrode it');
});

const _themeModeKey = 'nocturne.theme_mode';

/// Local-first so the theme paints correctly before the first `/users/me`
/// response ever lands; the settings screen additionally PATCHes the
/// backend's `theme` field once the user profile provider exists (see
/// features/settings), keeping the two in sync in the background.
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._prefs, AppConfig config) : super(config.defaultThemeMode) {
    final stored = _prefs.getString(_themeModeKey);
    if (stored != null) {
      state = ThemeMode.values.firstWhere((mode) => mode.name == stored, orElse: () => state);
    }
  }

  final SharedPreferences _prefs;

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(_themeModeKey, mode.name);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref.watch(sharedPreferencesProvider), ref.watch(appConfigProvider));
});
