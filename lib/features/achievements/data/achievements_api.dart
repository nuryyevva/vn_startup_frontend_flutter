import 'package:dio/dio.dart';

import '../domain/models/achievement.dart';

/// Hand-written Dio wrapper for `/achievements` — see `AuthApi`'s doc
/// comment for why this isn't retrofit-generated.
class AchievementsApi {
  AchievementsApi(this._dio);

  final Dio _dio;

  Future<List<Achievement>> getAchievements() async {
    final response = await _dio.get<List<dynamic>>('/achievements');
    return response.data!.map((e) => Achievement.fromJson(e as Map<String, dynamic>)).toList();
  }
}
