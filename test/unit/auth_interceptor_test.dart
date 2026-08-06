import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nocturne/core/network/auth_interceptor.dart';
import 'package:nocturne/core/storage/secure_token_storage.dart';

class _MockSecureTokenStorage extends Mock implements SecureTokenStorage {}

/// A minimal fake `HttpClientAdapter`: `/auth/refresh` succeeds once (with
/// an artificial delay to open a real race window between two concurrent
/// requests), `/protected` returns 401 until a refresh has happened, then
/// 200 — enough to exercise the interceptor's retry-after-refresh path
/// without a full HTTP mocking package.
class _FakeAdapter implements HttpClientAdapter {
  int refreshCalls = 0;
  bool refreshed = false;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final headers = {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    };

    if (options.path == '/auth/refresh') {
      refreshCalls++;
      await Future<void>.delayed(const Duration(milliseconds: 30));
      refreshed = true;
      return ResponseBody.fromString(
        jsonEncode({'access_token': 'new-access', 'refresh_token': 'new-refresh', 'token_type': 'Bearer'}),
        200,
        headers: headers,
      );
    }

    if (options.path == '/protected') {
      if (!refreshed) {
        return ResponseBody.fromString(
          jsonEncode({
            'error': {'code': 'token_expired', 'message': 'expired'},
          }),
          401,
          headers: headers,
        );
      }
      return ResponseBody.fromString(jsonEncode({'ok': true}), 200, headers: headers);
    }

    return ResponseBody.fromString('{}', 404, headers: headers);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late Dio dio;
  late _FakeAdapter adapter;
  late _MockSecureTokenStorage tokenStorage;
  late ProviderContainer container;

  setUp(() {
    tokenStorage = _MockSecureTokenStorage();
    when(() => tokenStorage.readAccessToken()).thenAnswer((_) async => 'old-access');
    when(() => tokenStorage.readRefreshToken()).thenAnswer((_) async => 'old-refresh');
    when(() => tokenStorage.saveTokens(accessToken: any(named: 'accessToken'), refreshToken: any(named: 'refreshToken')))
        .thenAnswer((_) async {});

    container = ProviderContainer();
    final ref = container.read(Provider<Ref>((ref) => ref));

    dio = Dio(BaseOptions(baseUrl: 'http://test'));
    adapter = _FakeAdapter();
    dio.httpClientAdapter = adapter;
    dio.interceptors.add(
      AuthInterceptor(ref: ref, tokenStorage: tokenStorage, dio: dio, tokenRefreshMargin: Duration.zero),
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('concurrent 401s from multiple in-flight requests trigger exactly one refresh', () async {
    final results = await Future.wait([dio.get<dynamic>('/protected'), dio.get<dynamic>('/protected')]);

    expect(results.every((r) => r.statusCode == 200), isTrue);
    expect(adapter.refreshCalls, 1);
  });
}
