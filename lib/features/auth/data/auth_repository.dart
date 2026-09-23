import '../domain/models/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> register(String email, String password);
  Future<AuthUser> login(String email, String password);
  Future<void> logout();
  Future<void> changePassword(String currentPassword, String newPassword);

  /// Whether a refresh token is already on disk — used at app startup to
  /// decide between the unauthenticated and authenticated initial route
  /// without making a network call.
  Future<bool> hasStoredSession();
}
