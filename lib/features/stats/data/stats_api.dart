import 'package:dio/dio.dart';

import '../domain/models/user_stats.dart';

/// Hand-written Dio wrapper for `/stats/*` — see `AuthApi`'s doc comment
/// for why this isn't retrofit-generated.
class StatsApi {
  StatsApi(this._dio);

  final Dio _dio;

  Future<UserStats> getStats() async {
    final response = await _dio.get<Map<String, dynamic>>('/stats/me');
    return UserStats.fromJson(response.data!);
  }

  /// Reports [seconds] of active reading time since the last heartbeat.
  /// The backend caps a single call at 300s (`invalid_amount` beyond that)
  /// — callers should send small, frequent heartbeats, not one big one.
  Future<UserStats> heartbeat(int seconds) async {
    final response = await _dio.post<Map<String, dynamic>>('/stats/heartbeat', data: {'seconds': seconds});
    return UserStats.fromJson(response.data!);
  }
}
