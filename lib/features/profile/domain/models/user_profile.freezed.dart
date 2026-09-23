// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name')
  String? get displayName => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  @JsonKey(name: 'favorite_genres')
  List<String> get favoriteGenres => throw _privateConstructorUsedError;
  String get theme => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  @JsonKey(name: 'notify_new_chapters')
  bool get notifyNewChapters => throw _privateConstructorUsedError;
  @JsonKey(name: 'notify_promotional_offers')
  bool get notifyPromotionalOffers => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      String email,
      String role,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'display_name') String? displayName,
      String? gender,
      @JsonKey(name: 'favorite_genres') List<String> favoriteGenres,
      String theme,
      String language,
      @JsonKey(name: 'notify_new_chapters') bool notifyNewChapters,
      @JsonKey(name: 'notify_promotional_offers') bool notifyPromotionalOffers,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = null,
    Object? role = null,
    Object? createdAt = null,
    Object? displayName = freezed,
    Object? gender = freezed,
    Object? favoriteGenres = null,
    Object? theme = null,
    Object? language = null,
    Object? notifyNewChapters = null,
    Object? notifyPromotionalOffers = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      favoriteGenres: null == favoriteGenres
          ? _value.favoriteGenres
          : favoriteGenres // ignore: cast_nullable_to_non_nullable
              as List<String>,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      notifyNewChapters: null == notifyNewChapters
          ? _value.notifyNewChapters
          : notifyNewChapters // ignore: cast_nullable_to_non_nullable
              as bool,
      notifyPromotionalOffers: null == notifyPromotionalOffers
          ? _value.notifyPromotionalOffers
          : notifyPromotionalOffers // ignore: cast_nullable_to_non_nullable
              as bool,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      String email,
      String role,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'display_name') String? displayName,
      String? gender,
      @JsonKey(name: 'favorite_genres') List<String> favoriteGenres,
      String theme,
      String language,
      @JsonKey(name: 'notify_new_chapters') bool notifyNewChapters,
      @JsonKey(name: 'notify_promotional_offers') bool notifyPromotionalOffers,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = null,
    Object? role = null,
    Object? createdAt = null,
    Object? displayName = freezed,
    Object? gender = freezed,
    Object? favoriteGenres = null,
    Object? theme = null,
    Object? language = null,
    Object? notifyNewChapters = null,
    Object? notifyPromotionalOffers = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UserProfileImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      favoriteGenres: null == favoriteGenres
          ? _value._favoriteGenres
          : favoriteGenres // ignore: cast_nullable_to_non_nullable
              as List<String>,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      notifyNewChapters: null == notifyNewChapters
          ? _value.notifyNewChapters
          : notifyNewChapters // ignore: cast_nullable_to_non_nullable
              as bool,
      notifyPromotionalOffers: null == notifyPromotionalOffers
          ? _value.notifyPromotionalOffers
          : notifyPromotionalOffers // ignore: cast_nullable_to_non_nullable
              as bool,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      required this.email,
      required this.role,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'display_name') this.displayName,
      this.gender,
      @JsonKey(name: 'favorite_genres')
      final List<String> favoriteGenres = const [],
      this.theme = 'dark',
      this.language = 'ru',
      @JsonKey(name: 'notify_new_chapters') this.notifyNewChapters = true,
      @JsonKey(name: 'notify_promotional_offers')
      this.notifyPromotionalOffers = false,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : _favoriteGenres = favoriteGenres;

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String email;
  @override
  final String role;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'display_name')
  final String? displayName;
  @override
  final String? gender;
  final List<String> _favoriteGenres;
  @override
  @JsonKey(name: 'favorite_genres')
  List<String> get favoriteGenres {
    if (_favoriteGenres is EqualUnmodifiableListView) return _favoriteGenres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favoriteGenres);
  }

  @override
  @JsonKey()
  final String theme;
  @override
  @JsonKey()
  final String language;
  @override
  @JsonKey(name: 'notify_new_chapters')
  final bool notifyNewChapters;
  @override
  @JsonKey(name: 'notify_promotional_offers')
  final bool notifyPromotionalOffers;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserProfile(userId: $userId, email: $email, role: $role, createdAt: $createdAt, displayName: $displayName, gender: $gender, favoriteGenres: $favoriteGenres, theme: $theme, language: $language, notifyNewChapters: $notifyNewChapters, notifyPromotionalOffers: $notifyPromotionalOffers, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            const DeepCollectionEquality()
                .equals(other._favoriteGenres, _favoriteGenres) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.notifyNewChapters, notifyNewChapters) ||
                other.notifyNewChapters == notifyNewChapters) &&
            (identical(
                    other.notifyPromotionalOffers, notifyPromotionalOffers) ||
                other.notifyPromotionalOffers == notifyPromotionalOffers) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      email,
      role,
      createdAt,
      displayName,
      gender,
      const DeepCollectionEquality().hash(_favoriteGenres),
      theme,
      language,
      notifyNewChapters,
      notifyPromotionalOffers,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
          {@JsonKey(name: 'user_id') required final String userId,
          required final String email,
          required final String role,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'display_name') final String? displayName,
          final String? gender,
          @JsonKey(name: 'favorite_genres') final List<String> favoriteGenres,
          final String theme,
          final String language,
          @JsonKey(name: 'notify_new_chapters') final bool notifyNewChapters,
          @JsonKey(name: 'notify_promotional_offers')
          final bool notifyPromotionalOffers,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get email;
  @override
  String get role;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'display_name')
  String? get displayName;
  @override
  String? get gender;
  @override
  @JsonKey(name: 'favorite_genres')
  List<String> get favoriteGenres;
  @override
  String get theme;
  @override
  String get language;
  @override
  @JsonKey(name: 'notify_new_chapters')
  bool get notifyNewChapters;
  @override
  @JsonKey(name: 'notify_promotional_offers')
  bool get notifyPromotionalOffers;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateProfileRequest _$UpdateProfileRequestFromJson(Map<String, dynamic> json) {
  return _UpdateProfileRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateProfileRequest {
  @JsonKey(name: 'display_name')
  String? get displayName => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  @JsonKey(name: 'favorite_genres')
  List<String>? get favoriteGenres => throw _privateConstructorUsedError;
  String? get theme => throw _privateConstructorUsedError;
  String? get language => throw _privateConstructorUsedError;
  @JsonKey(name: 'notify_new_chapters')
  bool? get notifyNewChapters => throw _privateConstructorUsedError;
  @JsonKey(name: 'notify_promotional_offers')
  bool? get notifyPromotionalOffers => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdateProfileRequestCopyWith<UpdateProfileRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateProfileRequestCopyWith<$Res> {
  factory $UpdateProfileRequestCopyWith(UpdateProfileRequest value,
          $Res Function(UpdateProfileRequest) then) =
      _$UpdateProfileRequestCopyWithImpl<$Res, UpdateProfileRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'display_name') String? displayName,
      String? gender,
      @JsonKey(name: 'favorite_genres') List<String>? favoriteGenres,
      String? theme,
      String? language,
      @JsonKey(name: 'notify_new_chapters') bool? notifyNewChapters,
      @JsonKey(name: 'notify_promotional_offers')
      bool? notifyPromotionalOffers});
}

/// @nodoc
class _$UpdateProfileRequestCopyWithImpl<$Res,
        $Val extends UpdateProfileRequest>
    implements $UpdateProfileRequestCopyWith<$Res> {
  _$UpdateProfileRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = freezed,
    Object? gender = freezed,
    Object? favoriteGenres = freezed,
    Object? theme = freezed,
    Object? language = freezed,
    Object? notifyNewChapters = freezed,
    Object? notifyPromotionalOffers = freezed,
  }) {
    return _then(_value.copyWith(
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      favoriteGenres: freezed == favoriteGenres
          ? _value.favoriteGenres
          : favoriteGenres // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      theme: freezed == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      notifyNewChapters: freezed == notifyNewChapters
          ? _value.notifyNewChapters
          : notifyNewChapters // ignore: cast_nullable_to_non_nullable
              as bool?,
      notifyPromotionalOffers: freezed == notifyPromotionalOffers
          ? _value.notifyPromotionalOffers
          : notifyPromotionalOffers // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateProfileRequestImplCopyWith<$Res>
    implements $UpdateProfileRequestCopyWith<$Res> {
  factory _$$UpdateProfileRequestImplCopyWith(_$UpdateProfileRequestImpl value,
          $Res Function(_$UpdateProfileRequestImpl) then) =
      __$$UpdateProfileRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'display_name') String? displayName,
      String? gender,
      @JsonKey(name: 'favorite_genres') List<String>? favoriteGenres,
      String? theme,
      String? language,
      @JsonKey(name: 'notify_new_chapters') bool? notifyNewChapters,
      @JsonKey(name: 'notify_promotional_offers')
      bool? notifyPromotionalOffers});
}

/// @nodoc
class __$$UpdateProfileRequestImplCopyWithImpl<$Res>
    extends _$UpdateProfileRequestCopyWithImpl<$Res, _$UpdateProfileRequestImpl>
    implements _$$UpdateProfileRequestImplCopyWith<$Res> {
  __$$UpdateProfileRequestImplCopyWithImpl(_$UpdateProfileRequestImpl _value,
      $Res Function(_$UpdateProfileRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = freezed,
    Object? gender = freezed,
    Object? favoriteGenres = freezed,
    Object? theme = freezed,
    Object? language = freezed,
    Object? notifyNewChapters = freezed,
    Object? notifyPromotionalOffers = freezed,
  }) {
    return _then(_$UpdateProfileRequestImpl(
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      favoriteGenres: freezed == favoriteGenres
          ? _value._favoriteGenres
          : favoriteGenres // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      theme: freezed == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      notifyNewChapters: freezed == notifyNewChapters
          ? _value.notifyNewChapters
          : notifyNewChapters // ignore: cast_nullable_to_non_nullable
              as bool?,
      notifyPromotionalOffers: freezed == notifyPromotionalOffers
          ? _value.notifyPromotionalOffers
          : notifyPromotionalOffers // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateProfileRequestImpl implements _UpdateProfileRequest {
  const _$UpdateProfileRequestImpl(
      {@JsonKey(name: 'display_name') this.displayName,
      this.gender,
      @JsonKey(name: 'favorite_genres') final List<String>? favoriteGenres,
      this.theme,
      this.language,
      @JsonKey(name: 'notify_new_chapters') this.notifyNewChapters,
      @JsonKey(name: 'notify_promotional_offers') this.notifyPromotionalOffers})
      : _favoriteGenres = favoriteGenres;

  factory _$UpdateProfileRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateProfileRequestImplFromJson(json);

  @override
  @JsonKey(name: 'display_name')
  final String? displayName;
  @override
  final String? gender;
  final List<String>? _favoriteGenres;
  @override
  @JsonKey(name: 'favorite_genres')
  List<String>? get favoriteGenres {
    final value = _favoriteGenres;
    if (value == null) return null;
    if (_favoriteGenres is EqualUnmodifiableListView) return _favoriteGenres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? theme;
  @override
  final String? language;
  @override
  @JsonKey(name: 'notify_new_chapters')
  final bool? notifyNewChapters;
  @override
  @JsonKey(name: 'notify_promotional_offers')
  final bool? notifyPromotionalOffers;

  @override
  String toString() {
    return 'UpdateProfileRequest(displayName: $displayName, gender: $gender, favoriteGenres: $favoriteGenres, theme: $theme, language: $language, notifyNewChapters: $notifyNewChapters, notifyPromotionalOffers: $notifyPromotionalOffers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateProfileRequestImpl &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            const DeepCollectionEquality()
                .equals(other._favoriteGenres, _favoriteGenres) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.notifyNewChapters, notifyNewChapters) ||
                other.notifyNewChapters == notifyNewChapters) &&
            (identical(
                    other.notifyPromotionalOffers, notifyPromotionalOffers) ||
                other.notifyPromotionalOffers == notifyPromotionalOffers));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      displayName,
      gender,
      const DeepCollectionEquality().hash(_favoriteGenres),
      theme,
      language,
      notifyNewChapters,
      notifyPromotionalOffers);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateProfileRequestImplCopyWith<_$UpdateProfileRequestImpl>
      get copyWith =>
          __$$UpdateProfileRequestImplCopyWithImpl<_$UpdateProfileRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateProfileRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateProfileRequest implements UpdateProfileRequest {
  const factory _UpdateProfileRequest(
      {@JsonKey(name: 'display_name') final String? displayName,
      final String? gender,
      @JsonKey(name: 'favorite_genres') final List<String>? favoriteGenres,
      final String? theme,
      final String? language,
      @JsonKey(name: 'notify_new_chapters') final bool? notifyNewChapters,
      @JsonKey(name: 'notify_promotional_offers')
      final bool? notifyPromotionalOffers}) = _$UpdateProfileRequestImpl;

  factory _UpdateProfileRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateProfileRequestImpl.fromJson;

  @override
  @JsonKey(name: 'display_name')
  String? get displayName;
  @override
  String? get gender;
  @override
  @JsonKey(name: 'favorite_genres')
  List<String>? get favoriteGenres;
  @override
  String? get theme;
  @override
  String? get language;
  @override
  @JsonKey(name: 'notify_new_chapters')
  bool? get notifyNewChapters;
  @override
  @JsonKey(name: 'notify_promotional_offers')
  bool? get notifyPromotionalOffers;
  @override
  @JsonKey(ignore: true)
  _$$UpdateProfileRequestImplCopyWith<_$UpdateProfileRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
