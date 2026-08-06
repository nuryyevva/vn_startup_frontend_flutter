import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// Mirrors `internal/user/models.go`'s `ProfileResponse` exactly —
/// `favoriteGenres`, never `hobbies` (see core-backend migration
/// 0007_user_profiles_favorite_genres).
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(name: 'user_id') required String userId,
    required String email,
    required String role,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'display_name') String? displayName,
    String? gender,
    @JsonKey(name: 'favorite_genres') @Default([]) List<String> favoriteGenres,
    @Default('dark') String theme,
    @Default('ru') String language,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
}

/// All fields optional — only non-null ones are sent, matching the
/// backend's PATCH semantics (nil = "leave unchanged", except
/// favoriteGenres which is replaced wholesale when non-null).
@freezed
class UpdateProfileRequest with _$UpdateProfileRequest {
  const factory UpdateProfileRequest({
    @JsonKey(name: 'display_name') String? displayName,
    String? gender,
    @JsonKey(name: 'favorite_genres') List<String>? favoriteGenres,
    String? theme,
    String? language,
  }) = _UpdateProfileRequest;

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) => _$UpdateProfileRequestFromJson(json);
}
