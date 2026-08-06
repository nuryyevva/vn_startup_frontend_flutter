import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/app_config.dart';
import 'auth_interceptor.dart';

/// The single Dio instance for the whole app — every retrofit API client
/// is built on top of this, never a fresh `Dio()`.
final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: config.apiTimeout,
      receiveTimeout: config.apiTimeout,
      contentType: 'application/json',
    ),
  );

  dio.interceptors.add(ref.watch(authInterceptorProvider(dio)));

  if (config.environment == AppEnvironment.dev) {
    dio.interceptors.add(PrettyDioLogger(requestBody: true, responseBody: true, error: true));
  }

  return dio;
});
