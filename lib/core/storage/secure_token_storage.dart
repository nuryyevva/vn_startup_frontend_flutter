import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wraps [FlutterSecureStorage] (Keychain/Keystore) for JWT access/refresh
/// tokens specifically — anything non-sensitive (theme choice, etc.) should
/// use `shared_preferences` instead, not this class.
class SecureTokenStorage {
  SecureTokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'nocturne.access_token';
  static const _refreshTokenKey = 'nocturne.refresh_token';

  /// Writes both tokens sequentially, not via `Future.wait` — on web,
  /// `flutter_secure_storage`'s first-ever write has to generate and persist
  /// its encryption key, and two concurrent first writes race on that: one
  /// value ends up encrypted with a key immediately superseded by the
  /// other write, so reading it back throws (a Web Crypto `OperationError`)
  /// until the next save "fixes" it by writing both under the now-settled
  /// key. Sequential writes make the key deterministic before the second
  /// write ever starts.
  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> clear() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}

final secureTokenStorageProvider = Provider<SecureTokenStorage>((ref) {
  return SecureTokenStorage(const FlutterSecureStorage());
});
