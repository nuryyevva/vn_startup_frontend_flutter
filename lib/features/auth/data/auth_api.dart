import 'package:dio/dio.dart';

import '../../../core/network/auth_interceptor.dart';
import '../domain/models/auth_tokens.dart';
import '../domain/models/auth_user.dart';

/// Hand-written Dio wrapper for `/auth/*`. Originally meant to be
/// retrofit-generated, but `retrofit_generator` currently fails to compile
/// against this project's Dart SDK at every pubspec-compatible version
/// (see README "known limitations") — this hand-written class has the
/// identical typed-method shape retrofit would have generated.
class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  Future<AuthResponse> register(EmailPasswordRequest body) async {
    final response = await _dio.post<Map<String, dynamic>>('/auth/register', data: body.toJson());
    return AuthResponse.fromJson(response.data!);
  }

  Future<AuthResponse> login(EmailPasswordRequest body) async {
    final response = await _dio.post<Map<String, dynamic>>('/auth/login', data: body.toJson());
    return AuthResponse.fromJson(response.data!);
  }

  /// Not used by [AuthInterceptor] (which calls `/auth/refresh` directly to
  /// avoid a provider dependency cycle) — kept for any future caller that
  /// wants to trigger a refresh outside the interceptor's own flow.
  Future<AuthTokens> refresh(RefreshRequest body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: body.toJson(),
      options: Options(extra: {skipAuthExtraKey: true}),
    );
    return AuthTokens.fromJson(response.data!);
  }
}
