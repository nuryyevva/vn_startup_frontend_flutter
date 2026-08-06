import '../../../core/storage/secure_token_storage.dart';
import '../domain/models/auth_user.dart';
import 'auth_api.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  // Named parameters `api`/`tokenStorage` (not `_api`/`_tokenStorage`) so
  // call sites in other files can use them — a private initializing formal
  // like `this._api` would make the parameter itself private too (see
  // analysis_options.yaml, where `prefer_initializing_formals` is disabled
  // project-wide for this reason).
  AuthRepositoryImpl({required AuthApi api, required SecureTokenStorage tokenStorage})
    : _api = api,
      _tokenStorage = tokenStorage;

  final AuthApi _api;
  final SecureTokenStorage _tokenStorage;

  @override
  Future<AuthUser> register(String email, String password) async {
    final response = await _api.register(EmailPasswordRequest(email: email, password: password));
    await _saveTokens(response);
    return response.user;
  }

  @override
  Future<AuthUser> login(String email, String password) async {
    final response = await _api.login(EmailPasswordRequest(email: email, password: password));
    await _saveTokens(response);
    return response.user;
  }

  Future<void> _saveTokens(AuthResponse response) {
    return _tokenStorage.saveTokens(
      accessToken: response.tokens.accessToken,
      refreshToken: response.tokens.refreshToken,
    );
  }

  @override
  Future<void> logout() => _tokenStorage.clear();

  @override
  Future<bool> hasStoredSession() async => await _tokenStorage.readRefreshToken() != null;
}
