import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../config/app_config.dart';
import '../storage/secure_token_storage.dart';
import 'jwt_utils.dart';

/// Extra-options key: requests tagged with this skip token attachment and
/// 401 handling entirely (used for /auth/login, /auth/register,
/// /auth/refresh itself).
const skipAuthExtraKey = 'skipAuth';

/// Attaches `Authorization: Bearer <access_token>` to every request (unless
/// tagged [skipAuthExtraKey]), proactively refreshes when the token is
/// within [tokenRefreshMargin] of expiring, and reactively refreshes once
/// on a 401 — concurrent 401s all await the same in-flight refresh via
/// [_refreshCompleter] instead of each triggering their own.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.ref, required this.tokenStorage, required this.dio, required this.tokenRefreshMargin});

  final Ref ref;
  final SecureTokenStorage tokenStorage;
  final Dio dio;
  final Duration tokenRefreshMargin;

  Completer<bool>? _refreshCompleter;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra[skipAuthExtraKey] != true) {
      var token = await tokenStorage.readAccessToken();
      if (token != null && _isExpiringSoon(token)) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          token = await tokenStorage.readAccessToken();
        }
      }
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isAuthEndpoint = err.requestOptions.extra[skipAuthExtraKey] == true;
    if (err.response?.statusCode == 401 && !isAuthEndpoint) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        try {
          final response = await _retry(err.requestOptions);
          handler.resolve(response);
          return;
        } on DioException catch (retryError) {
          handler.next(retryError);
          return;
        }
      }
      unawaited(ref.read(authStateProvider.notifier).signOut());
    }
    handler.next(err);
  }

  bool _isExpiringSoon(String token) {
    final expiry = jwtExpiry(token);
    if (expiry == null) return false;
    return DateTime.now().toUtc().isAfter(expiry.subtract(tokenRefreshMargin));
  }

  Future<bool> _refreshToken() {
    final existing = _refreshCompleter;
    if (existing != null) return existing.future;

    final completer = Completer<bool>();
    _refreshCompleter = completer;
    _doRefresh()
        .then(completer.complete)
        .catchError((Object _, StackTrace _) => completer.complete(false))
        .whenComplete(() => _refreshCompleter = null);
    return completer.future;
  }

  Future<bool> _doRefresh() async {
    final refreshToken = await tokenStorage.readRefreshToken();
    if (refreshToken == null) return false;
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(extra: {skipAuthExtraKey: true}),
      );
      final data = response.data!;
      await tokenStorage.saveTokens(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
      );
      return true;
    } on DioException {
      return false;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final token = await tokenStorage.readAccessToken();
    final options = Options(
      method: requestOptions.method,
      headers: {...requestOptions.headers, if (token != null) 'Authorization': 'Bearer $token'},
      extra: requestOptions.extra,
    );
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

final authInterceptorProvider = Provider.family<AuthInterceptor, Dio>((ref, dio) {
  final config = ref.watch(appConfigProvider);
  return AuthInterceptor(
    ref: ref,
    tokenStorage: ref.watch(secureTokenStorageProvider),
    dio: dio,
    tokenRefreshMargin: config.tokenRefreshMargin,
  );
});
