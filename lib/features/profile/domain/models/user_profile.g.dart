// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      displayName: json['display_name'] as String?,
      gender: json['gender'] as String?,
      favoriteGenres: (json['favorite_genres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      theme: json['theme'] as String? ?? 'dark',
      language: json['language'] as String? ?? 'ru',
      notifyNewChapters: json['notify_new_chapters'] as bool? ?? true,
      notifyPromotionalOffers:
          json['notify_promotional_offers'] as bool? ?? false,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'email': instance.email,
      'role': instance.role,
      'created_at': instance.createdAt.toIso8601String(),
      'display_name': instance.displayName,
      'gender': instance.gender,
      'favorite_genres': instance.favoriteGenres,
      'theme': instance.theme,
      'language': instance.language,
      'notify_new_chapters': instance.notifyNewChapters,
      'notify_promotional_offers': instance.notifyPromotionalOffers,
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$UpdateProfileRequestImpl _$$UpdateProfileRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateProfileRequestImpl(
      displayName: json['display_name'] as String?,
      gender: json['gender'] as String?,
      favoriteGenres: (json['favorite_genres'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      theme: json['theme'] as String?,
      language: json['language'] as String?,
      notifyNewChapters: json['notify_new_chapters'] as bool?,
      notifyPromotionalOffers: json['notify_promotional_offers'] as bool?,
    );

Map<String, dynamic> _$$UpdateProfileRequestImplToJson(
        _$UpdateProfileRequestImpl instance) =>
    <String, dynamic>{
      'display_name': instance.displayName,
      'gender': instance.gender,
      'favorite_genres': instance.favoriteGenres,
      'theme': instance.theme,
      'language': instance.language,
      'notify_new_chapters': instance.notifyNewChapters,
      'notify_promotional_offers': instance.notifyPromotionalOffers,
    };
