// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dialog_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DialogSession _$DialogSessionFromJson(Map<String, dynamic> json) {
  return _DialogSession.fromJson(json);
}

/// @nodoc
mixin _$DialogSession {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'character_id')
  String get characterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'scene_id')
  String get sceneId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'limit_type')
  String get limitType => throw _privateConstructorUsedError;
  @JsonKey(name: 'limit_value')
  int? get limitValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'message_count')
  int get messageCount => throw _privateConstructorUsedError;

  /// Diamonds each message costs; null from a backend that doesn't say.
  @JsonKey(name: 'message_cost')
  int? get messageCost => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  DateTime get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ended_at')
  DateTime? get endedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_reason')
  String? get endReason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DialogSessionCopyWith<DialogSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DialogSessionCopyWith<$Res> {
  factory $DialogSessionCopyWith(
          DialogSession value, $Res Function(DialogSession) then) =
      _$DialogSessionCopyWithImpl<$Res, DialogSession>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'character_id') String characterId,
      @JsonKey(name: 'scene_id') String sceneId,
      String status,
      @JsonKey(name: 'limit_type') String limitType,
      @JsonKey(name: 'limit_value') int? limitValue,
      @JsonKey(name: 'message_count') int messageCount,
      @JsonKey(name: 'message_cost') int? messageCost,
      @JsonKey(name: 'started_at') DateTime startedAt,
      @JsonKey(name: 'ended_at') DateTime? endedAt,
      @JsonKey(name: 'end_reason') String? endReason});
}

/// @nodoc
class _$DialogSessionCopyWithImpl<$Res, $Val extends DialogSession>
    implements $DialogSessionCopyWith<$Res> {
  _$DialogSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? characterId = null,
    Object? sceneId = null,
    Object? status = null,
    Object? limitType = null,
    Object? limitValue = freezed,
    Object? messageCount = null,
    Object? messageCost = freezed,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? endReason = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      characterId: null == characterId
          ? _value.characterId
          : characterId // ignore: cast_nullable_to_non_nullable
              as String,
      sceneId: null == sceneId
          ? _value.sceneId
          : sceneId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      limitType: null == limitType
          ? _value.limitType
          : limitType // ignore: cast_nullable_to_non_nullable
              as String,
      limitValue: freezed == limitValue
          ? _value.limitValue
          : limitValue // ignore: cast_nullable_to_non_nullable
              as int?,
      messageCount: null == messageCount
          ? _value.messageCount
          : messageCount // ignore: cast_nullable_to_non_nullable
              as int,
      messageCost: freezed == messageCost
          ? _value.messageCost
          : messageCost // ignore: cast_nullable_to_non_nullable
              as int?,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endReason: freezed == endReason
          ? _value.endReason
          : endReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DialogSessionImplCopyWith<$Res>
    implements $DialogSessionCopyWith<$Res> {
  factory _$$DialogSessionImplCopyWith(
          _$DialogSessionImpl value, $Res Function(_$DialogSessionImpl) then) =
      __$$DialogSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'character_id') String characterId,
      @JsonKey(name: 'scene_id') String sceneId,
      String status,
      @JsonKey(name: 'limit_type') String limitType,
      @JsonKey(name: 'limit_value') int? limitValue,
      @JsonKey(name: 'message_count') int messageCount,
      @JsonKey(name: 'message_cost') int? messageCost,
      @JsonKey(name: 'started_at') DateTime startedAt,
      @JsonKey(name: 'ended_at') DateTime? endedAt,
      @JsonKey(name: 'end_reason') String? endReason});
}

/// @nodoc
class __$$DialogSessionImplCopyWithImpl<$Res>
    extends _$DialogSessionCopyWithImpl<$Res, _$DialogSessionImpl>
    implements _$$DialogSessionImplCopyWith<$Res> {
  __$$DialogSessionImplCopyWithImpl(
      _$DialogSessionImpl _value, $Res Function(_$DialogSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? characterId = null,
    Object? sceneId = null,
    Object? status = null,
    Object? limitType = null,
    Object? limitValue = freezed,
    Object? messageCount = null,
    Object? messageCost = freezed,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? endReason = freezed,
  }) {
    return _then(_$DialogSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      characterId: null == characterId
          ? _value.characterId
          : characterId // ignore: cast_nullable_to_non_nullable
              as String,
      sceneId: null == sceneId
          ? _value.sceneId
          : sceneId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      limitType: null == limitType
          ? _value.limitType
          : limitType // ignore: cast_nullable_to_non_nullable
              as String,
      limitValue: freezed == limitValue
          ? _value.limitValue
          : limitValue // ignore: cast_nullable_to_non_nullable
              as int?,
      messageCount: null == messageCount
          ? _value.messageCount
          : messageCount // ignore: cast_nullable_to_non_nullable
              as int,
      messageCost: freezed == messageCost
          ? _value.messageCost
          : messageCost // ignore: cast_nullable_to_non_nullable
              as int?,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endReason: freezed == endReason
          ? _value.endReason
          : endReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DialogSessionImpl implements _DialogSession {
  const _$DialogSessionImpl(
      {required this.id,
      @JsonKey(name: 'character_id') required this.characterId,
      @JsonKey(name: 'scene_id') required this.sceneId,
      required this.status,
      @JsonKey(name: 'limit_type') required this.limitType,
      @JsonKey(name: 'limit_value') this.limitValue,
      @JsonKey(name: 'message_count') this.messageCount = 0,
      @JsonKey(name: 'message_cost') this.messageCost,
      @JsonKey(name: 'started_at') required this.startedAt,
      @JsonKey(name: 'ended_at') this.endedAt,
      @JsonKey(name: 'end_reason') this.endReason});

  factory _$DialogSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$DialogSessionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'character_id')
  final String characterId;
  @override
  @JsonKey(name: 'scene_id')
  final String sceneId;
  @override
  final String status;
  @override
  @JsonKey(name: 'limit_type')
  final String limitType;
  @override
  @JsonKey(name: 'limit_value')
  final int? limitValue;
  @override
  @JsonKey(name: 'message_count')
  final int messageCount;

  /// Diamonds each message costs; null from a backend that doesn't say.
  @override
  @JsonKey(name: 'message_cost')
  final int? messageCost;
  @override
  @JsonKey(name: 'started_at')
  final DateTime startedAt;
  @override
  @JsonKey(name: 'ended_at')
  final DateTime? endedAt;
  @override
  @JsonKey(name: 'end_reason')
  final String? endReason;

  @override
  String toString() {
    return 'DialogSession(id: $id, characterId: $characterId, sceneId: $sceneId, status: $status, limitType: $limitType, limitValue: $limitValue, messageCount: $messageCount, messageCost: $messageCost, startedAt: $startedAt, endedAt: $endedAt, endReason: $endReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DialogSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.characterId, characterId) ||
                other.characterId == characterId) &&
            (identical(other.sceneId, sceneId) || other.sceneId == sceneId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.limitType, limitType) ||
                other.limitType == limitType) &&
            (identical(other.limitValue, limitValue) ||
                other.limitValue == limitValue) &&
            (identical(other.messageCount, messageCount) ||
                other.messageCount == messageCount) &&
            (identical(other.messageCost, messageCost) ||
                other.messageCost == messageCost) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.endReason, endReason) ||
                other.endReason == endReason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      characterId,
      sceneId,
      status,
      limitType,
      limitValue,
      messageCount,
      messageCost,
      startedAt,
      endedAt,
      endReason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DialogSessionImplCopyWith<_$DialogSessionImpl> get copyWith =>
      __$$DialogSessionImplCopyWithImpl<_$DialogSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DialogSessionImplToJson(
      this,
    );
  }
}

abstract class _DialogSession implements DialogSession {
  const factory _DialogSession(
          {required final String id,
          @JsonKey(name: 'character_id') required final String characterId,
          @JsonKey(name: 'scene_id') required final String sceneId,
          required final String status,
          @JsonKey(name: 'limit_type') required final String limitType,
          @JsonKey(name: 'limit_value') final int? limitValue,
          @JsonKey(name: 'message_count') final int messageCount,
          @JsonKey(name: 'message_cost') final int? messageCost,
          @JsonKey(name: 'started_at') required final DateTime startedAt,
          @JsonKey(name: 'ended_at') final DateTime? endedAt,
          @JsonKey(name: 'end_reason') final String? endReason}) =
      _$DialogSessionImpl;

  factory _DialogSession.fromJson(Map<String, dynamic> json) =
      _$DialogSessionImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'character_id')
  String get characterId;
  @override
  @JsonKey(name: 'scene_id')
  String get sceneId;
  @override
  String get status;
  @override
  @JsonKey(name: 'limit_type')
  String get limitType;
  @override
  @JsonKey(name: 'limit_value')
  int? get limitValue;
  @override
  @JsonKey(name: 'message_count')
  int get messageCount;
  @override

  /// Diamonds each message costs; null from a backend that doesn't say.
  @JsonKey(name: 'message_cost')
  int? get messageCost;
  @override
  @JsonKey(name: 'started_at')
  DateTime get startedAt;
  @override
  @JsonKey(name: 'ended_at')
  DateTime? get endedAt;
  @override
  @JsonKey(name: 'end_reason')
  String? get endReason;
  @override
  @JsonKey(ignore: true)
  _$$DialogSessionImplCopyWith<_$DialogSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
