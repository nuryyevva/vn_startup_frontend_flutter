// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dialog_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DialogMessage _$DialogMessageFromJson(Map<String, dynamic> json) {
  return _DialogMessage.fromJson(json);
}

/// @nodoc
mixin _$DialogMessage {
  String get id => throw _privateConstructorUsedError;
  String get sender =>
      throw _privateConstructorUsedError; // 'user' | 'character'
  String get text => throw _privateConstructorUsedError;
  bool get isStreaming => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_diamonds')
  int get costDiamonds => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'remaining_limit')
  int? get remainingLimit => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DialogMessageCopyWith<DialogMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DialogMessageCopyWith<$Res> {
  factory $DialogMessageCopyWith(
          DialogMessage value, $Res Function(DialogMessage) then) =
      _$DialogMessageCopyWithImpl<$Res, DialogMessage>;
  @useResult
  $Res call(
      {String id,
      String sender,
      String text,
      bool isStreaming,
      @JsonKey(name: 'cost_diamonds') int costDiamonds,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'remaining_limit') int? remainingLimit});
}

/// @nodoc
class _$DialogMessageCopyWithImpl<$Res, $Val extends DialogMessage>
    implements $DialogMessageCopyWith<$Res> {
  _$DialogMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sender = null,
    Object? text = null,
    Object? isStreaming = null,
    Object? costDiamonds = null,
    Object? createdAt = freezed,
    Object? remainingLimit = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isStreaming: null == isStreaming
          ? _value.isStreaming
          : isStreaming // ignore: cast_nullable_to_non_nullable
              as bool,
      costDiamonds: null == costDiamonds
          ? _value.costDiamonds
          : costDiamonds // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      remainingLimit: freezed == remainingLimit
          ? _value.remainingLimit
          : remainingLimit // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DialogMessageImplCopyWith<$Res>
    implements $DialogMessageCopyWith<$Res> {
  factory _$$DialogMessageImplCopyWith(
          _$DialogMessageImpl value, $Res Function(_$DialogMessageImpl) then) =
      __$$DialogMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String sender,
      String text,
      bool isStreaming,
      @JsonKey(name: 'cost_diamonds') int costDiamonds,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'remaining_limit') int? remainingLimit});
}

/// @nodoc
class __$$DialogMessageImplCopyWithImpl<$Res>
    extends _$DialogMessageCopyWithImpl<$Res, _$DialogMessageImpl>
    implements _$$DialogMessageImplCopyWith<$Res> {
  __$$DialogMessageImplCopyWithImpl(
      _$DialogMessageImpl _value, $Res Function(_$DialogMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sender = null,
    Object? text = null,
    Object? isStreaming = null,
    Object? costDiamonds = null,
    Object? createdAt = freezed,
    Object? remainingLimit = freezed,
  }) {
    return _then(_$DialogMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isStreaming: null == isStreaming
          ? _value.isStreaming
          : isStreaming // ignore: cast_nullable_to_non_nullable
              as bool,
      costDiamonds: null == costDiamonds
          ? _value.costDiamonds
          : costDiamonds // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      remainingLimit: freezed == remainingLimit
          ? _value.remainingLimit
          : remainingLimit // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DialogMessageImpl implements _DialogMessage {
  const _$DialogMessageImpl(
      {required this.id,
      required this.sender,
      required this.text,
      this.isStreaming = false,
      @JsonKey(name: 'cost_diamonds') this.costDiamonds = 0,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'remaining_limit') this.remainingLimit});

  factory _$DialogMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$DialogMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String sender;
// 'user' | 'character'
  @override
  final String text;
  @override
  @JsonKey()
  final bool isStreaming;
  @override
  @JsonKey(name: 'cost_diamonds')
  final int costDiamonds;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'remaining_limit')
  final int? remainingLimit;

  @override
  String toString() {
    return 'DialogMessage(id: $id, sender: $sender, text: $text, isStreaming: $isStreaming, costDiamonds: $costDiamonds, createdAt: $createdAt, remainingLimit: $remainingLimit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DialogMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.isStreaming, isStreaming) ||
                other.isStreaming == isStreaming) &&
            (identical(other.costDiamonds, costDiamonds) ||
                other.costDiamonds == costDiamonds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.remainingLimit, remainingLimit) ||
                other.remainingLimit == remainingLimit));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, sender, text, isStreaming,
      costDiamonds, createdAt, remainingLimit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DialogMessageImplCopyWith<_$DialogMessageImpl> get copyWith =>
      __$$DialogMessageImplCopyWithImpl<_$DialogMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DialogMessageImplToJson(
      this,
    );
  }
}

abstract class _DialogMessage implements DialogMessage {
  const factory _DialogMessage(
          {required final String id,
          required final String sender,
          required final String text,
          final bool isStreaming,
          @JsonKey(name: 'cost_diamonds') final int costDiamonds,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'remaining_limit') final int? remainingLimit}) =
      _$DialogMessageImpl;

  factory _DialogMessage.fromJson(Map<String, dynamic> json) =
      _$DialogMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get sender;
  @override // 'user' | 'character'
  String get text;
  @override
  bool get isStreaming;
  @override
  @JsonKey(name: 'cost_diamonds')
  int get costDiamonds;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'remaining_limit')
  int? get remainingLimit;
  @override
  @JsonKey(ignore: true)
  _$$DialogMessageImplCopyWith<_$DialogMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
