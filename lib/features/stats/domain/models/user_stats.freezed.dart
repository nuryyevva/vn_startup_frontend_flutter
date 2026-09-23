// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserStats _$UserStatsFromJson(Map<String, dynamic> json) {
  return _UserStats.fromJson(json);
}

/// @nodoc
mixin _$UserStats {
  @JsonKey(name: 'day_streak')
  int get dayStreak => throw _privateConstructorUsedError;
  @JsonKey(name: 'longest_streak')
  int get longestStreak => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_reading_seconds')
  int get totalReadingSeconds => throw _privateConstructorUsedError;
  @JsonKey(name: 'hours_read')
  double get hoursRead => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserStatsCopyWith<UserStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatsCopyWith<$Res> {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) then) =
      _$UserStatsCopyWithImpl<$Res, UserStats>;
  @useResult
  $Res call(
      {@JsonKey(name: 'day_streak') int dayStreak,
      @JsonKey(name: 'longest_streak') int longestStreak,
      @JsonKey(name: 'total_reading_seconds') int totalReadingSeconds,
      @JsonKey(name: 'hours_read') double hoursRead});
}

/// @nodoc
class _$UserStatsCopyWithImpl<$Res, $Val extends UserStats>
    implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayStreak = null,
    Object? longestStreak = null,
    Object? totalReadingSeconds = null,
    Object? hoursRead = null,
  }) {
    return _then(_value.copyWith(
      dayStreak: null == dayStreak
          ? _value.dayStreak
          : dayStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      totalReadingSeconds: null == totalReadingSeconds
          ? _value.totalReadingSeconds
          : totalReadingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      hoursRead: null == hoursRead
          ? _value.hoursRead
          : hoursRead // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserStatsImplCopyWith<$Res>
    implements $UserStatsCopyWith<$Res> {
  factory _$$UserStatsImplCopyWith(
          _$UserStatsImpl value, $Res Function(_$UserStatsImpl) then) =
      __$$UserStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'day_streak') int dayStreak,
      @JsonKey(name: 'longest_streak') int longestStreak,
      @JsonKey(name: 'total_reading_seconds') int totalReadingSeconds,
      @JsonKey(name: 'hours_read') double hoursRead});
}

/// @nodoc
class __$$UserStatsImplCopyWithImpl<$Res>
    extends _$UserStatsCopyWithImpl<$Res, _$UserStatsImpl>
    implements _$$UserStatsImplCopyWith<$Res> {
  __$$UserStatsImplCopyWithImpl(
      _$UserStatsImpl _value, $Res Function(_$UserStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayStreak = null,
    Object? longestStreak = null,
    Object? totalReadingSeconds = null,
    Object? hoursRead = null,
  }) {
    return _then(_$UserStatsImpl(
      dayStreak: null == dayStreak
          ? _value.dayStreak
          : dayStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      totalReadingSeconds: null == totalReadingSeconds
          ? _value.totalReadingSeconds
          : totalReadingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      hoursRead: null == hoursRead
          ? _value.hoursRead
          : hoursRead // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStatsImpl implements _UserStats {
  const _$UserStatsImpl(
      {@JsonKey(name: 'day_streak') required this.dayStreak,
      @JsonKey(name: 'longest_streak') required this.longestStreak,
      @JsonKey(name: 'total_reading_seconds') required this.totalReadingSeconds,
      @JsonKey(name: 'hours_read') required this.hoursRead});

  factory _$UserStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStatsImplFromJson(json);

  @override
  @JsonKey(name: 'day_streak')
  final int dayStreak;
  @override
  @JsonKey(name: 'longest_streak')
  final int longestStreak;
  @override
  @JsonKey(name: 'total_reading_seconds')
  final int totalReadingSeconds;
  @override
  @JsonKey(name: 'hours_read')
  final double hoursRead;

  @override
  String toString() {
    return 'UserStats(dayStreak: $dayStreak, longestStreak: $longestStreak, totalReadingSeconds: $totalReadingSeconds, hoursRead: $hoursRead)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatsImpl &&
            (identical(other.dayStreak, dayStreak) ||
                other.dayStreak == dayStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.totalReadingSeconds, totalReadingSeconds) ||
                other.totalReadingSeconds == totalReadingSeconds) &&
            (identical(other.hoursRead, hoursRead) ||
                other.hoursRead == hoursRead));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, dayStreak, longestStreak, totalReadingSeconds, hoursRead);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      __$$UserStatsImplCopyWithImpl<_$UserStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStatsImplToJson(
      this,
    );
  }
}

abstract class _UserStats implements UserStats {
  const factory _UserStats(
          {@JsonKey(name: 'day_streak') required final int dayStreak,
          @JsonKey(name: 'longest_streak') required final int longestStreak,
          @JsonKey(name: 'total_reading_seconds')
          required final int totalReadingSeconds,
          @JsonKey(name: 'hours_read') required final double hoursRead}) =
      _$UserStatsImpl;

  factory _UserStats.fromJson(Map<String, dynamic> json) =
      _$UserStatsImpl.fromJson;

  @override
  @JsonKey(name: 'day_streak')
  int get dayStreak;
  @override
  @JsonKey(name: 'longest_streak')
  int get longestStreak;
  @override
  @JsonKey(name: 'total_reading_seconds')
  int get totalReadingSeconds;
  @override
  @JsonKey(name: 'hours_read')
  double get hoursRead;
  @override
  @JsonKey(ignore: true)
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
