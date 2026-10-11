import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Everything the offline build keeps about the player — what the server's
/// database holds otherwise: story progress, unlocked scenes, bookmarks,
/// the wallet, the profile, reading stats and achievements. Stored as JSON
/// in shared preferences: it's a handful of small records for one player on
/// one device, read and written whole.
///
/// Uninstalling the app (or clearing its data) erases all of it; there's no
/// account to restore it from.
class LocalStore {
  LocalStore(this._prefs);

  final SharedPreferences _prefs;

  static const _prefix = 'offline.v1.';

  Map<String, dynamic> readMap(String key) {
    final raw = _prefs.getString('$_prefix$key');
    if (raw == null) return {};
    final decoded = jsonDecode(raw);
    return decoded is Map<String, dynamic> ? decoded : {};
  }

  Future<void> writeMap(String key, Map<String, dynamic> value) => _prefs.setString('$_prefix$key', jsonEncode(value));

  List<String> readList(String key) => _prefs.getStringList('$_prefix$key') ?? const [];

  Future<void> writeList(String key, List<String> value) => _prefs.setStringList('$_prefix$key', value);

  int readInt(String key) => _prefs.getInt('$_prefix$key') ?? 0;

  Future<void> writeInt(String key, int value) => _prefs.setInt('$_prefix$key', value);
}
