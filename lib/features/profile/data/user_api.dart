import 'package:dio/dio.dart';

import '../domain/models/user_profile.dart';

/// Hand-written Dio wrapper for `/users/me` — see `AuthApi`'s doc comment
/// for why this isn't retrofit-generated.
class UserApi {
  UserApi(this._dio);

  final Dio _dio;

  Future<UserProfile> getMe() async {
    final response = await _dio.get<Map<String, dynamic>>('/users/me');
    return UserProfile.fromJson(response.data!);
  }

  Future<UserProfile> updateMe(UpdateProfileRequest body) async {
    final response = await _dio.patch<Map<String, dynamic>>('/users/me', data: body.toJson());
    return UserProfile.fromJson(response.data!);
  }
}
