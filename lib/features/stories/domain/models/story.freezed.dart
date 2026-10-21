// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Story _$StoryFromJson(Map<String, dynamic> json) {
  return _Story.fromJson(json);
}

/// @nodoc
mixin _$Story {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_url')
  String? get coverUrl => throw _privateConstructorUsedError;
  String get genre => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Design tokens for the scene player's look in this story, or null
  /// for the app's default — see `ScenePlayerSkin`.
  @JsonKey(name: 'player_theme')
  Map<String, dynamic>? get playerTheme => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StoryCopyWith<Story> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryCopyWith<$Res> {
  factory $StoryCopyWith(Story value, $Res Function(Story) then) =
      _$StoryCopyWithImpl<$Res, Story>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      @JsonKey(name: 'cover_url') String? coverUrl,
      String genre,
      String status,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'player_theme') Map<String, dynamic>? playerTheme});
}

/// @nodoc
class _$StoryCopyWithImpl<$Res, $Val extends Story>
    implements $StoryCopyWith<$Res> {
  _$StoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? coverUrl = freezed,
    Object? genre = null,
    Object? status = null,
    Object? createdAt = null,
    Object? playerTheme = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      genre: null == genre
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      playerTheme: freezed == playerTheme
          ? _value.playerTheme
          : playerTheme // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoryImplCopyWith<$Res> implements $StoryCopyWith<$Res> {
  factory _$$StoryImplCopyWith(
          _$StoryImpl value, $Res Function(_$StoryImpl) then) =
      __$$StoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      @JsonKey(name: 'cover_url') String? coverUrl,
      String genre,
      String status,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'player_theme') Map<String, dynamic>? playerTheme});
}

/// @nodoc
class __$$StoryImplCopyWithImpl<$Res>
    extends _$StoryCopyWithImpl<$Res, _$StoryImpl>
    implements _$$StoryImplCopyWith<$Res> {
  __$$StoryImplCopyWithImpl(
      _$StoryImpl _value, $Res Function(_$StoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? coverUrl = freezed,
    Object? genre = null,
    Object? status = null,
    Object? createdAt = null,
    Object? playerTheme = freezed,
  }) {
    return _then(_$StoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      genre: null == genre
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      playerTheme: freezed == playerTheme
          ? _value._playerTheme
          : playerTheme // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryImpl implements _Story {
  const _$StoryImpl(
      {required this.id,
      required this.title,
      this.description,
      @JsonKey(name: 'cover_url') this.coverUrl,
      required this.genre,
      required this.status,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'player_theme') final Map<String, dynamic>? playerTheme})
      : _playerTheme = playerTheme;

  factory _$StoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'cover_url')
  final String? coverUrl;
  @override
  final String genre;
  @override
  final String status;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Design tokens for the scene player's look in this story, or null
  /// for the app's default — see `ScenePlayerSkin`.
  final Map<String, dynamic>? _playerTheme;

  /// Design tokens for the scene player's look in this story, or null
  /// for the app's default — see `ScenePlayerSkin`.
  @override
  @JsonKey(name: 'player_theme')
  Map<String, dynamic>? get playerTheme {
    final value = _playerTheme;
    if (value == null) return null;
    if (_playerTheme is EqualUnmodifiableMapView) return _playerTheme;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Story(id: $id, title: $title, description: $description, coverUrl: $coverUrl, genre: $genre, status: $status, createdAt: $createdAt, playerTheme: $playerTheme)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.genre, genre) || other.genre == genre) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality()
                .equals(other._playerTheme, _playerTheme));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      coverUrl,
      genre,
      status,
      createdAt,
      const DeepCollectionEquality().hash(_playerTheme));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryImplCopyWith<_$StoryImpl> get copyWith =>
      __$$StoryImplCopyWithImpl<_$StoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryImplToJson(
      this,
    );
  }
}

abstract class _Story implements Story {
  const factory _Story(
      {required final String id,
      required final String title,
      final String? description,
      @JsonKey(name: 'cover_url') final String? coverUrl,
      required final String genre,
      required final String status,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'player_theme')
      final Map<String, dynamic>? playerTheme}) = _$StoryImpl;

  factory _Story.fromJson(Map<String, dynamic> json) = _$StoryImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'cover_url')
  String? get coverUrl;
  @override
  String get genre;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override

  /// Design tokens for the scene player's look in this story, or null
  /// for the app's default — see `ScenePlayerSkin`.
  @JsonKey(name: 'player_theme')
  Map<String, dynamic>? get playerTheme;
  @override
  @JsonKey(ignore: true)
  _$$StoryImplCopyWith<_$StoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoryPage _$StoryPageFromJson(Map<String, dynamic> json) {
  return _StoryPage.fromJson(json);
}

/// @nodoc
mixin _$StoryPage {
  List<Story> get items => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  @JsonKey(name: 'page_size')
  int get pageSize => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StoryPageCopyWith<StoryPage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryPageCopyWith<$Res> {
  factory $StoryPageCopyWith(StoryPage value, $Res Function(StoryPage) then) =
      _$StoryPageCopyWithImpl<$Res, StoryPage>;
  @useResult
  $Res call(
      {List<Story> items,
      int total,
      int page,
      @JsonKey(name: 'page_size') int pageSize});
}

/// @nodoc
class _$StoryPageCopyWithImpl<$Res, $Val extends StoryPage>
    implements $StoryPageCopyWith<$Res> {
  _$StoryPageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? page = null,
    Object? pageSize = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Story>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoryPageImplCopyWith<$Res>
    implements $StoryPageCopyWith<$Res> {
  factory _$$StoryPageImplCopyWith(
          _$StoryPageImpl value, $Res Function(_$StoryPageImpl) then) =
      __$$StoryPageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Story> items,
      int total,
      int page,
      @JsonKey(name: 'page_size') int pageSize});
}

/// @nodoc
class __$$StoryPageImplCopyWithImpl<$Res>
    extends _$StoryPageCopyWithImpl<$Res, _$StoryPageImpl>
    implements _$$StoryPageImplCopyWith<$Res> {
  __$$StoryPageImplCopyWithImpl(
      _$StoryPageImpl _value, $Res Function(_$StoryPageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? page = null,
    Object? pageSize = null,
  }) {
    return _then(_$StoryPageImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Story>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryPageImpl implements _StoryPage {
  const _$StoryPageImpl(
      {required final List<Story> items,
      required this.total,
      required this.page,
      @JsonKey(name: 'page_size') required this.pageSize})
      : _items = items;

  factory _$StoryPageImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryPageImplFromJson(json);

  final List<Story> _items;
  @override
  List<Story> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int total;
  @override
  final int page;
  @override
  @JsonKey(name: 'page_size')
  final int pageSize;

  @override
  String toString() {
    return 'StoryPage(items: $items, total: $total, page: $page, pageSize: $pageSize)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryPageImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), total, page, pageSize);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryPageImplCopyWith<_$StoryPageImpl> get copyWith =>
      __$$StoryPageImplCopyWithImpl<_$StoryPageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryPageImplToJson(
      this,
    );
  }
}

abstract class _StoryPage implements StoryPage {
  const factory _StoryPage(
          {required final List<Story> items,
          required final int total,
          required final int page,
          @JsonKey(name: 'page_size') required final int pageSize}) =
      _$StoryPageImpl;

  factory _StoryPage.fromJson(Map<String, dynamic> json) =
      _$StoryPageImpl.fromJson;

  @override
  List<Story> get items;
  @override
  int get total;
  @override
  int get page;
  @override
  @JsonKey(name: 'page_size')
  int get pageSize;
  @override
  @JsonKey(ignore: true)
  _$$StoryPageImplCopyWith<_$StoryPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Choice _$ChoiceFromJson(Map<String, dynamic> json) {
  return _Choice.fromJson(json);
}

/// @nodoc
mixin _$Choice {
  String get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_paid')
  bool get isPaid => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_diamonds')
  int get costDiamonds => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_scene_id')
  String? get nextSceneId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChoiceCopyWith<Choice> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChoiceCopyWith<$Res> {
  factory $ChoiceCopyWith(Choice value, $Res Function(Choice) then) =
      _$ChoiceCopyWithImpl<$Res, Choice>;
  @useResult
  $Res call(
      {String id,
      String text,
      @JsonKey(name: 'is_paid') bool isPaid,
      @JsonKey(name: 'cost_diamonds') int costDiamonds,
      @JsonKey(name: 'next_scene_id') String? nextSceneId});
}

/// @nodoc
class _$ChoiceCopyWithImpl<$Res, $Val extends Choice>
    implements $ChoiceCopyWith<$Res> {
  _$ChoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? isPaid = null,
    Object? costDiamonds = null,
    Object? nextSceneId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isPaid: null == isPaid
          ? _value.isPaid
          : isPaid // ignore: cast_nullable_to_non_nullable
              as bool,
      costDiamonds: null == costDiamonds
          ? _value.costDiamonds
          : costDiamonds // ignore: cast_nullable_to_non_nullable
              as int,
      nextSceneId: freezed == nextSceneId
          ? _value.nextSceneId
          : nextSceneId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChoiceImplCopyWith<$Res> implements $ChoiceCopyWith<$Res> {
  factory _$$ChoiceImplCopyWith(
          _$ChoiceImpl value, $Res Function(_$ChoiceImpl) then) =
      __$$ChoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String text,
      @JsonKey(name: 'is_paid') bool isPaid,
      @JsonKey(name: 'cost_diamonds') int costDiamonds,
      @JsonKey(name: 'next_scene_id') String? nextSceneId});
}

/// @nodoc
class __$$ChoiceImplCopyWithImpl<$Res>
    extends _$ChoiceCopyWithImpl<$Res, _$ChoiceImpl>
    implements _$$ChoiceImplCopyWith<$Res> {
  __$$ChoiceImplCopyWithImpl(
      _$ChoiceImpl _value, $Res Function(_$ChoiceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? isPaid = null,
    Object? costDiamonds = null,
    Object? nextSceneId = freezed,
  }) {
    return _then(_$ChoiceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isPaid: null == isPaid
          ? _value.isPaid
          : isPaid // ignore: cast_nullable_to_non_nullable
              as bool,
      costDiamonds: null == costDiamonds
          ? _value.costDiamonds
          : costDiamonds // ignore: cast_nullable_to_non_nullable
              as int,
      nextSceneId: freezed == nextSceneId
          ? _value.nextSceneId
          : nextSceneId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChoiceImpl implements _Choice {
  const _$ChoiceImpl(
      {required this.id,
      required this.text,
      @JsonKey(name: 'is_paid') required this.isPaid,
      @JsonKey(name: 'cost_diamonds') required this.costDiamonds,
      @JsonKey(name: 'next_scene_id') this.nextSceneId});

  factory _$ChoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChoiceImplFromJson(json);

  @override
  final String id;
  @override
  final String text;
  @override
  @JsonKey(name: 'is_paid')
  final bool isPaid;
  @override
  @JsonKey(name: 'cost_diamonds')
  final int costDiamonds;
  @override
  @JsonKey(name: 'next_scene_id')
  final String? nextSceneId;

  @override
  String toString() {
    return 'Choice(id: $id, text: $text, isPaid: $isPaid, costDiamonds: $costDiamonds, nextSceneId: $nextSceneId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChoiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.isPaid, isPaid) || other.isPaid == isPaid) &&
            (identical(other.costDiamonds, costDiamonds) ||
                other.costDiamonds == costDiamonds) &&
            (identical(other.nextSceneId, nextSceneId) ||
                other.nextSceneId == nextSceneId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, text, isPaid, costDiamonds, nextSceneId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChoiceImplCopyWith<_$ChoiceImpl> get copyWith =>
      __$$ChoiceImplCopyWithImpl<_$ChoiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChoiceImplToJson(
      this,
    );
  }
}

abstract class _Choice implements Choice {
  const factory _Choice(
          {required final String id,
          required final String text,
          @JsonKey(name: 'is_paid') required final bool isPaid,
          @JsonKey(name: 'cost_diamonds') required final int costDiamonds,
          @JsonKey(name: 'next_scene_id') final String? nextSceneId}) =
      _$ChoiceImpl;

  factory _Choice.fromJson(Map<String, dynamic> json) = _$ChoiceImpl.fromJson;

  @override
  String get id;
  @override
  String get text;
  @override
  @JsonKey(name: 'is_paid')
  bool get isPaid;
  @override
  @JsonKey(name: 'cost_diamonds')
  int get costDiamonds;
  @override
  @JsonKey(name: 'next_scene_id')
  String? get nextSceneId;
  @override
  @JsonKey(ignore: true)
  _$$ChoiceImplCopyWith<_$ChoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Scene _$SceneFromJson(Map<String, dynamic> json) {
  return _Scene.fromJson(json);
}

/// @nodoc
mixin _$Scene {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'story_id')
  String get storyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_index')
  int get orderIndex => throw _privateConstructorUsedError;
  @JsonKey(name: 'background_url')
  String? get backgroundUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'character_id')
  String? get characterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'dialogue_script')
  List<dynamic> get dialogueScript => throw _privateConstructorUsedError;
  @JsonKey(name: 'free_dialog_enabled')
  bool get freeDialogEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'dialog_limit_type')
  String? get dialogLimitType => throw _privateConstructorUsedError;
  @JsonKey(name: 'dialog_limit_value')
  int? get dialogLimitValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'unlock_cost_diamonds')
  int? get unlockCostDiamonds => throw _privateConstructorUsedError;
  @JsonKey(name: 'character_sprite_url')
  String? get characterSpriteUrl => throw _privateConstructorUsedError;

  /// The shot the scene opens with; script lines may switch it. Missing
  /// (older backends, older offline bundles) or unknown values fall back
  /// to the full figure.
  @JsonKey(name: 'sprite_framing', unknownEnumValue: SpriteFraming.full)
  SpriteFraming get spriteFraming => throw _privateConstructorUsedError;
  @JsonKey(name: 'background_music_url')
  String? get backgroundMusicUrl => throw _privateConstructorUsedError;

  /// See [SceneSummary.chapterTitle] / [SceneSummary.title].
  @JsonKey(name: 'chapter_title')
  String? get chapterTitle => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  List<Choice> get choices => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SceneCopyWith<Scene> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SceneCopyWith<$Res> {
  factory $SceneCopyWith(Scene value, $Res Function(Scene) then) =
      _$SceneCopyWithImpl<$Res, Scene>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'story_id') String storyId,
      @JsonKey(name: 'order_index') int orderIndex,
      @JsonKey(name: 'background_url') String? backgroundUrl,
      @JsonKey(name: 'character_id') String? characterId,
      @JsonKey(name: 'dialogue_script') List<dynamic> dialogueScript,
      @JsonKey(name: 'free_dialog_enabled') bool freeDialogEnabled,
      @JsonKey(name: 'dialog_limit_type') String? dialogLimitType,
      @JsonKey(name: 'dialog_limit_value') int? dialogLimitValue,
      @JsonKey(name: 'unlock_cost_diamonds') int? unlockCostDiamonds,
      @JsonKey(name: 'character_sprite_url') String? characterSpriteUrl,
      @JsonKey(name: 'sprite_framing', unknownEnumValue: SpriteFraming.full)
      SpriteFraming spriteFraming,
      @JsonKey(name: 'background_music_url') String? backgroundMusicUrl,
      @JsonKey(name: 'chapter_title') String? chapterTitle,
      String? title,
      List<Choice> choices});
}

/// @nodoc
class _$SceneCopyWithImpl<$Res, $Val extends Scene>
    implements $SceneCopyWith<$Res> {
  _$SceneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storyId = null,
    Object? orderIndex = null,
    Object? backgroundUrl = freezed,
    Object? characterId = freezed,
    Object? dialogueScript = null,
    Object? freeDialogEnabled = null,
    Object? dialogLimitType = freezed,
    Object? dialogLimitValue = freezed,
    Object? unlockCostDiamonds = freezed,
    Object? characterSpriteUrl = freezed,
    Object? spriteFraming = null,
    Object? backgroundMusicUrl = freezed,
    Object? chapterTitle = freezed,
    Object? title = freezed,
    Object? choices = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storyId: null == storyId
          ? _value.storyId
          : storyId // ignore: cast_nullable_to_non_nullable
              as String,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      backgroundUrl: freezed == backgroundUrl
          ? _value.backgroundUrl
          : backgroundUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      characterId: freezed == characterId
          ? _value.characterId
          : characterId // ignore: cast_nullable_to_non_nullable
              as String?,
      dialogueScript: null == dialogueScript
          ? _value.dialogueScript
          : dialogueScript // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      freeDialogEnabled: null == freeDialogEnabled
          ? _value.freeDialogEnabled
          : freeDialogEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      dialogLimitType: freezed == dialogLimitType
          ? _value.dialogLimitType
          : dialogLimitType // ignore: cast_nullable_to_non_nullable
              as String?,
      dialogLimitValue: freezed == dialogLimitValue
          ? _value.dialogLimitValue
          : dialogLimitValue // ignore: cast_nullable_to_non_nullable
              as int?,
      unlockCostDiamonds: freezed == unlockCostDiamonds
          ? _value.unlockCostDiamonds
          : unlockCostDiamonds // ignore: cast_nullable_to_non_nullable
              as int?,
      characterSpriteUrl: freezed == characterSpriteUrl
          ? _value.characterSpriteUrl
          : characterSpriteUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      spriteFraming: null == spriteFraming
          ? _value.spriteFraming
          : spriteFraming // ignore: cast_nullable_to_non_nullable
              as SpriteFraming,
      backgroundMusicUrl: freezed == backgroundMusicUrl
          ? _value.backgroundMusicUrl
          : backgroundMusicUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      chapterTitle: freezed == chapterTitle
          ? _value.chapterTitle
          : chapterTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      choices: null == choices
          ? _value.choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<Choice>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SceneImplCopyWith<$Res> implements $SceneCopyWith<$Res> {
  factory _$$SceneImplCopyWith(
          _$SceneImpl value, $Res Function(_$SceneImpl) then) =
      __$$SceneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'story_id') String storyId,
      @JsonKey(name: 'order_index') int orderIndex,
      @JsonKey(name: 'background_url') String? backgroundUrl,
      @JsonKey(name: 'character_id') String? characterId,
      @JsonKey(name: 'dialogue_script') List<dynamic> dialogueScript,
      @JsonKey(name: 'free_dialog_enabled') bool freeDialogEnabled,
      @JsonKey(name: 'dialog_limit_type') String? dialogLimitType,
      @JsonKey(name: 'dialog_limit_value') int? dialogLimitValue,
      @JsonKey(name: 'unlock_cost_diamonds') int? unlockCostDiamonds,
      @JsonKey(name: 'character_sprite_url') String? characterSpriteUrl,
      @JsonKey(name: 'sprite_framing', unknownEnumValue: SpriteFraming.full)
      SpriteFraming spriteFraming,
      @JsonKey(name: 'background_music_url') String? backgroundMusicUrl,
      @JsonKey(name: 'chapter_title') String? chapterTitle,
      String? title,
      List<Choice> choices});
}

/// @nodoc
class __$$SceneImplCopyWithImpl<$Res>
    extends _$SceneCopyWithImpl<$Res, _$SceneImpl>
    implements _$$SceneImplCopyWith<$Res> {
  __$$SceneImplCopyWithImpl(
      _$SceneImpl _value, $Res Function(_$SceneImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storyId = null,
    Object? orderIndex = null,
    Object? backgroundUrl = freezed,
    Object? characterId = freezed,
    Object? dialogueScript = null,
    Object? freeDialogEnabled = null,
    Object? dialogLimitType = freezed,
    Object? dialogLimitValue = freezed,
    Object? unlockCostDiamonds = freezed,
    Object? characterSpriteUrl = freezed,
    Object? spriteFraming = null,
    Object? backgroundMusicUrl = freezed,
    Object? chapterTitle = freezed,
    Object? title = freezed,
    Object? choices = null,
  }) {
    return _then(_$SceneImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storyId: null == storyId
          ? _value.storyId
          : storyId // ignore: cast_nullable_to_non_nullable
              as String,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      backgroundUrl: freezed == backgroundUrl
          ? _value.backgroundUrl
          : backgroundUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      characterId: freezed == characterId
          ? _value.characterId
          : characterId // ignore: cast_nullable_to_non_nullable
              as String?,
      dialogueScript: null == dialogueScript
          ? _value._dialogueScript
          : dialogueScript // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      freeDialogEnabled: null == freeDialogEnabled
          ? _value.freeDialogEnabled
          : freeDialogEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      dialogLimitType: freezed == dialogLimitType
          ? _value.dialogLimitType
          : dialogLimitType // ignore: cast_nullable_to_non_nullable
              as String?,
      dialogLimitValue: freezed == dialogLimitValue
          ? _value.dialogLimitValue
          : dialogLimitValue // ignore: cast_nullable_to_non_nullable
              as int?,
      unlockCostDiamonds: freezed == unlockCostDiamonds
          ? _value.unlockCostDiamonds
          : unlockCostDiamonds // ignore: cast_nullable_to_non_nullable
              as int?,
      characterSpriteUrl: freezed == characterSpriteUrl
          ? _value.characterSpriteUrl
          : characterSpriteUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      spriteFraming: null == spriteFraming
          ? _value.spriteFraming
          : spriteFraming // ignore: cast_nullable_to_non_nullable
              as SpriteFraming,
      backgroundMusicUrl: freezed == backgroundMusicUrl
          ? _value.backgroundMusicUrl
          : backgroundMusicUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      chapterTitle: freezed == chapterTitle
          ? _value.chapterTitle
          : chapterTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      choices: null == choices
          ? _value._choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<Choice>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SceneImpl implements _Scene {
  const _$SceneImpl(
      {required this.id,
      @JsonKey(name: 'story_id') required this.storyId,
      @JsonKey(name: 'order_index') required this.orderIndex,
      @JsonKey(name: 'background_url') this.backgroundUrl,
      @JsonKey(name: 'character_id') this.characterId,
      @JsonKey(name: 'dialogue_script')
      required final List<dynamic> dialogueScript,
      @JsonKey(name: 'free_dialog_enabled') required this.freeDialogEnabled,
      @JsonKey(name: 'dialog_limit_type') this.dialogLimitType,
      @JsonKey(name: 'dialog_limit_value') this.dialogLimitValue,
      @JsonKey(name: 'unlock_cost_diamonds') this.unlockCostDiamonds,
      @JsonKey(name: 'character_sprite_url') this.characterSpriteUrl,
      @JsonKey(name: 'sprite_framing', unknownEnumValue: SpriteFraming.full)
      this.spriteFraming = SpriteFraming.full,
      @JsonKey(name: 'background_music_url') this.backgroundMusicUrl,
      @JsonKey(name: 'chapter_title') this.chapterTitle,
      this.title,
      final List<Choice> choices = const []})
      : _dialogueScript = dialogueScript,
        _choices = choices;

  factory _$SceneImpl.fromJson(Map<String, dynamic> json) =>
      _$$SceneImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'story_id')
  final String storyId;
  @override
  @JsonKey(name: 'order_index')
  final int orderIndex;
  @override
  @JsonKey(name: 'background_url')
  final String? backgroundUrl;
  @override
  @JsonKey(name: 'character_id')
  final String? characterId;
  final List<dynamic> _dialogueScript;
  @override
  @JsonKey(name: 'dialogue_script')
  List<dynamic> get dialogueScript {
    if (_dialogueScript is EqualUnmodifiableListView) return _dialogueScript;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dialogueScript);
  }

  @override
  @JsonKey(name: 'free_dialog_enabled')
  final bool freeDialogEnabled;
  @override
  @JsonKey(name: 'dialog_limit_type')
  final String? dialogLimitType;
  @override
  @JsonKey(name: 'dialog_limit_value')
  final int? dialogLimitValue;
  @override
  @JsonKey(name: 'unlock_cost_diamonds')
  final int? unlockCostDiamonds;
  @override
  @JsonKey(name: 'character_sprite_url')
  final String? characterSpriteUrl;

  /// The shot the scene opens with; script lines may switch it. Missing
  /// (older backends, older offline bundles) or unknown values fall back
  /// to the full figure.
  @override
  @JsonKey(name: 'sprite_framing', unknownEnumValue: SpriteFraming.full)
  final SpriteFraming spriteFraming;
  @override
  @JsonKey(name: 'background_music_url')
  final String? backgroundMusicUrl;

  /// See [SceneSummary.chapterTitle] / [SceneSummary.title].
  @override
  @JsonKey(name: 'chapter_title')
  final String? chapterTitle;
  @override
  final String? title;
  final List<Choice> _choices;
  @override
  @JsonKey()
  List<Choice> get choices {
    if (_choices is EqualUnmodifiableListView) return _choices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_choices);
  }

  @override
  String toString() {
    return 'Scene(id: $id, storyId: $storyId, orderIndex: $orderIndex, backgroundUrl: $backgroundUrl, characterId: $characterId, dialogueScript: $dialogueScript, freeDialogEnabled: $freeDialogEnabled, dialogLimitType: $dialogLimitType, dialogLimitValue: $dialogLimitValue, unlockCostDiamonds: $unlockCostDiamonds, characterSpriteUrl: $characterSpriteUrl, spriteFraming: $spriteFraming, backgroundMusicUrl: $backgroundMusicUrl, chapterTitle: $chapterTitle, title: $title, choices: $choices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SceneImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storyId, storyId) || other.storyId == storyId) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.backgroundUrl, backgroundUrl) ||
                other.backgroundUrl == backgroundUrl) &&
            (identical(other.characterId, characterId) ||
                other.characterId == characterId) &&
            const DeepCollectionEquality()
                .equals(other._dialogueScript, _dialogueScript) &&
            (identical(other.freeDialogEnabled, freeDialogEnabled) ||
                other.freeDialogEnabled == freeDialogEnabled) &&
            (identical(other.dialogLimitType, dialogLimitType) ||
                other.dialogLimitType == dialogLimitType) &&
            (identical(other.dialogLimitValue, dialogLimitValue) ||
                other.dialogLimitValue == dialogLimitValue) &&
            (identical(other.unlockCostDiamonds, unlockCostDiamonds) ||
                other.unlockCostDiamonds == unlockCostDiamonds) &&
            (identical(other.characterSpriteUrl, characterSpriteUrl) ||
                other.characterSpriteUrl == characterSpriteUrl) &&
            (identical(other.spriteFraming, spriteFraming) ||
                other.spriteFraming == spriteFraming) &&
            (identical(other.backgroundMusicUrl, backgroundMusicUrl) ||
                other.backgroundMusicUrl == backgroundMusicUrl) &&
            (identical(other.chapterTitle, chapterTitle) ||
                other.chapterTitle == chapterTitle) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._choices, _choices));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      storyId,
      orderIndex,
      backgroundUrl,
      characterId,
      const DeepCollectionEquality().hash(_dialogueScript),
      freeDialogEnabled,
      dialogLimitType,
      dialogLimitValue,
      unlockCostDiamonds,
      characterSpriteUrl,
      spriteFraming,
      backgroundMusicUrl,
      chapterTitle,
      title,
      const DeepCollectionEquality().hash(_choices));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SceneImplCopyWith<_$SceneImpl> get copyWith =>
      __$$SceneImplCopyWithImpl<_$SceneImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SceneImplToJson(
      this,
    );
  }
}

abstract class _Scene implements Scene {
  const factory _Scene(
      {required final String id,
      @JsonKey(name: 'story_id') required final String storyId,
      @JsonKey(name: 'order_index') required final int orderIndex,
      @JsonKey(name: 'background_url') final String? backgroundUrl,
      @JsonKey(name: 'character_id') final String? characterId,
      @JsonKey(name: 'dialogue_script')
      required final List<dynamic> dialogueScript,
      @JsonKey(name: 'free_dialog_enabled')
      required final bool freeDialogEnabled,
      @JsonKey(name: 'dialog_limit_type') final String? dialogLimitType,
      @JsonKey(name: 'dialog_limit_value') final int? dialogLimitValue,
      @JsonKey(name: 'unlock_cost_diamonds') final int? unlockCostDiamonds,
      @JsonKey(name: 'character_sprite_url') final String? characterSpriteUrl,
      @JsonKey(name: 'sprite_framing', unknownEnumValue: SpriteFraming.full)
      final SpriteFraming spriteFraming,
      @JsonKey(name: 'background_music_url') final String? backgroundMusicUrl,
      @JsonKey(name: 'chapter_title') final String? chapterTitle,
      final String? title,
      final List<Choice> choices}) = _$SceneImpl;

  factory _Scene.fromJson(Map<String, dynamic> json) = _$SceneImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'story_id')
  String get storyId;
  @override
  @JsonKey(name: 'order_index')
  int get orderIndex;
  @override
  @JsonKey(name: 'background_url')
  String? get backgroundUrl;
  @override
  @JsonKey(name: 'character_id')
  String? get characterId;
  @override
  @JsonKey(name: 'dialogue_script')
  List<dynamic> get dialogueScript;
  @override
  @JsonKey(name: 'free_dialog_enabled')
  bool get freeDialogEnabled;
  @override
  @JsonKey(name: 'dialog_limit_type')
  String? get dialogLimitType;
  @override
  @JsonKey(name: 'dialog_limit_value')
  int? get dialogLimitValue;
  @override
  @JsonKey(name: 'unlock_cost_diamonds')
  int? get unlockCostDiamonds;
  @override
  @JsonKey(name: 'character_sprite_url')
  String? get characterSpriteUrl;
  @override

  /// The shot the scene opens with; script lines may switch it. Missing
  /// (older backends, older offline bundles) or unknown values fall back
  /// to the full figure.
  @JsonKey(name: 'sprite_framing', unknownEnumValue: SpriteFraming.full)
  SpriteFraming get spriteFraming;
  @override
  @JsonKey(name: 'background_music_url')
  String? get backgroundMusicUrl;
  @override

  /// See [SceneSummary.chapterTitle] / [SceneSummary.title].
  @JsonKey(name: 'chapter_title')
  String? get chapterTitle;
  @override
  String? get title;
  @override
  List<Choice> get choices;
  @override
  @JsonKey(ignore: true)
  _$$SceneImplCopyWith<_$SceneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SceneSummary _$SceneSummaryFromJson(Map<String, dynamic> json) {
  return _SceneSummary.fromJson(json);
}

/// @nodoc
mixin _$SceneSummary {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_index')
  int get orderIndex => throw _privateConstructorUsedError;
  @JsonKey(name: 'unlock_cost_diamonds')
  int? get unlockCostDiamonds => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_unlocked')
  bool get isUnlocked => throw _privateConstructorUsedError;

  /// Non-null only on the scene that starts a chapter. Branching stories
  /// are made of many short scenes linked by choices, so they mark their
  /// chapters instead of listing every scene as one.
  @JsonKey(name: 'chapter_title')
  String? get chapterTitle => throw _privateConstructorUsedError;

  /// Non-null only on scenes that start a named section of a chapter —
  /// listed when the chapter is expanded.
  String? get title => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SceneSummaryCopyWith<SceneSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SceneSummaryCopyWith<$Res> {
  factory $SceneSummaryCopyWith(
          SceneSummary value, $Res Function(SceneSummary) then) =
      _$SceneSummaryCopyWithImpl<$Res, SceneSummary>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'order_index') int orderIndex,
      @JsonKey(name: 'unlock_cost_diamonds') int? unlockCostDiamonds,
      @JsonKey(name: 'is_unlocked') bool isUnlocked,
      @JsonKey(name: 'chapter_title') String? chapterTitle,
      String? title});
}

/// @nodoc
class _$SceneSummaryCopyWithImpl<$Res, $Val extends SceneSummary>
    implements $SceneSummaryCopyWith<$Res> {
  _$SceneSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderIndex = null,
    Object? unlockCostDiamonds = freezed,
    Object? isUnlocked = null,
    Object? chapterTitle = freezed,
    Object? title = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      unlockCostDiamonds: freezed == unlockCostDiamonds
          ? _value.unlockCostDiamonds
          : unlockCostDiamonds // ignore: cast_nullable_to_non_nullable
              as int?,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      chapterTitle: freezed == chapterTitle
          ? _value.chapterTitle
          : chapterTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SceneSummaryImplCopyWith<$Res>
    implements $SceneSummaryCopyWith<$Res> {
  factory _$$SceneSummaryImplCopyWith(
          _$SceneSummaryImpl value, $Res Function(_$SceneSummaryImpl) then) =
      __$$SceneSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'order_index') int orderIndex,
      @JsonKey(name: 'unlock_cost_diamonds') int? unlockCostDiamonds,
      @JsonKey(name: 'is_unlocked') bool isUnlocked,
      @JsonKey(name: 'chapter_title') String? chapterTitle,
      String? title});
}

/// @nodoc
class __$$SceneSummaryImplCopyWithImpl<$Res>
    extends _$SceneSummaryCopyWithImpl<$Res, _$SceneSummaryImpl>
    implements _$$SceneSummaryImplCopyWith<$Res> {
  __$$SceneSummaryImplCopyWithImpl(
      _$SceneSummaryImpl _value, $Res Function(_$SceneSummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderIndex = null,
    Object? unlockCostDiamonds = freezed,
    Object? isUnlocked = null,
    Object? chapterTitle = freezed,
    Object? title = freezed,
  }) {
    return _then(_$SceneSummaryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      unlockCostDiamonds: freezed == unlockCostDiamonds
          ? _value.unlockCostDiamonds
          : unlockCostDiamonds // ignore: cast_nullable_to_non_nullable
              as int?,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      chapterTitle: freezed == chapterTitle
          ? _value.chapterTitle
          : chapterTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SceneSummaryImpl implements _SceneSummary {
  const _$SceneSummaryImpl(
      {required this.id,
      @JsonKey(name: 'order_index') required this.orderIndex,
      @JsonKey(name: 'unlock_cost_diamonds') this.unlockCostDiamonds,
      @JsonKey(name: 'is_unlocked') required this.isUnlocked,
      @JsonKey(name: 'chapter_title') this.chapterTitle,
      this.title});

  factory _$SceneSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SceneSummaryImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'order_index')
  final int orderIndex;
  @override
  @JsonKey(name: 'unlock_cost_diamonds')
  final int? unlockCostDiamonds;
  @override
  @JsonKey(name: 'is_unlocked')
  final bool isUnlocked;

  /// Non-null only on the scene that starts a chapter. Branching stories
  /// are made of many short scenes linked by choices, so they mark their
  /// chapters instead of listing every scene as one.
  @override
  @JsonKey(name: 'chapter_title')
  final String? chapterTitle;

  /// Non-null only on scenes that start a named section of a chapter —
  /// listed when the chapter is expanded.
  @override
  final String? title;

  @override
  String toString() {
    return 'SceneSummary(id: $id, orderIndex: $orderIndex, unlockCostDiamonds: $unlockCostDiamonds, isUnlocked: $isUnlocked, chapterTitle: $chapterTitle, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SceneSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.unlockCostDiamonds, unlockCostDiamonds) ||
                other.unlockCostDiamonds == unlockCostDiamonds) &&
            (identical(other.isUnlocked, isUnlocked) ||
                other.isUnlocked == isUnlocked) &&
            (identical(other.chapterTitle, chapterTitle) ||
                other.chapterTitle == chapterTitle) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, orderIndex,
      unlockCostDiamonds, isUnlocked, chapterTitle, title);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SceneSummaryImplCopyWith<_$SceneSummaryImpl> get copyWith =>
      __$$SceneSummaryImplCopyWithImpl<_$SceneSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SceneSummaryImplToJson(
      this,
    );
  }
}

abstract class _SceneSummary implements SceneSummary {
  const factory _SceneSummary(
      {required final String id,
      @JsonKey(name: 'order_index') required final int orderIndex,
      @JsonKey(name: 'unlock_cost_diamonds') final int? unlockCostDiamonds,
      @JsonKey(name: 'is_unlocked') required final bool isUnlocked,
      @JsonKey(name: 'chapter_title') final String? chapterTitle,
      final String? title}) = _$SceneSummaryImpl;

  factory _SceneSummary.fromJson(Map<String, dynamic> json) =
      _$SceneSummaryImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'order_index')
  int get orderIndex;
  @override
  @JsonKey(name: 'unlock_cost_diamonds')
  int? get unlockCostDiamonds;
  @override
  @JsonKey(name: 'is_unlocked')
  bool get isUnlocked;
  @override

  /// Non-null only on the scene that starts a chapter. Branching stories
  /// are made of many short scenes linked by choices, so they mark their
  /// chapters instead of listing every scene as one.
  @JsonKey(name: 'chapter_title')
  String? get chapterTitle;
  @override

  /// Non-null only on scenes that start a named section of a chapter —
  /// listed when the chapter is expanded.
  String? get title;
  @override
  @JsonKey(ignore: true)
  _$$SceneSummaryImplCopyWith<_$SceneSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlayerProgress _$PlayerProgressFromJson(Map<String, dynamic> json) {
  return _PlayerProgress.fromJson(json);
}

/// @nodoc
mixin _$PlayerProgress {
  @JsonKey(name: 'story_id')
  String get storyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_scene_id')
  String get currentSceneId => throw _privateConstructorUsedError;
  @JsonKey(name: 'choices_made')
  List<String> get choicesMade => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlayerProgressCopyWith<PlayerProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerProgressCopyWith<$Res> {
  factory $PlayerProgressCopyWith(
          PlayerProgress value, $Res Function(PlayerProgress) then) =
      _$PlayerProgressCopyWithImpl<$Res, PlayerProgress>;
  @useResult
  $Res call(
      {@JsonKey(name: 'story_id') String storyId,
      @JsonKey(name: 'current_scene_id') String currentSceneId,
      @JsonKey(name: 'choices_made') List<String> choicesMade,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$PlayerProgressCopyWithImpl<$Res, $Val extends PlayerProgress>
    implements $PlayerProgressCopyWith<$Res> {
  _$PlayerProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storyId = null,
    Object? currentSceneId = null,
    Object? choicesMade = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      storyId: null == storyId
          ? _value.storyId
          : storyId // ignore: cast_nullable_to_non_nullable
              as String,
      currentSceneId: null == currentSceneId
          ? _value.currentSceneId
          : currentSceneId // ignore: cast_nullable_to_non_nullable
              as String,
      choicesMade: null == choicesMade
          ? _value.choicesMade
          : choicesMade // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlayerProgressImplCopyWith<$Res>
    implements $PlayerProgressCopyWith<$Res> {
  factory _$$PlayerProgressImplCopyWith(_$PlayerProgressImpl value,
          $Res Function(_$PlayerProgressImpl) then) =
      __$$PlayerProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'story_id') String storyId,
      @JsonKey(name: 'current_scene_id') String currentSceneId,
      @JsonKey(name: 'choices_made') List<String> choicesMade,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$PlayerProgressImplCopyWithImpl<$Res>
    extends _$PlayerProgressCopyWithImpl<$Res, _$PlayerProgressImpl>
    implements _$$PlayerProgressImplCopyWith<$Res> {
  __$$PlayerProgressImplCopyWithImpl(
      _$PlayerProgressImpl _value, $Res Function(_$PlayerProgressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storyId = null,
    Object? currentSceneId = null,
    Object? choicesMade = null,
    Object? updatedAt = null,
  }) {
    return _then(_$PlayerProgressImpl(
      storyId: null == storyId
          ? _value.storyId
          : storyId // ignore: cast_nullable_to_non_nullable
              as String,
      currentSceneId: null == currentSceneId
          ? _value.currentSceneId
          : currentSceneId // ignore: cast_nullable_to_non_nullable
              as String,
      choicesMade: null == choicesMade
          ? _value._choicesMade
          : choicesMade // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerProgressImpl implements _PlayerProgress {
  const _$PlayerProgressImpl(
      {@JsonKey(name: 'story_id') required this.storyId,
      @JsonKey(name: 'current_scene_id') required this.currentSceneId,
      @JsonKey(name: 'choices_made') final List<String> choicesMade = const [],
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : _choicesMade = choicesMade;

  factory _$PlayerProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerProgressImplFromJson(json);

  @override
  @JsonKey(name: 'story_id')
  final String storyId;
  @override
  @JsonKey(name: 'current_scene_id')
  final String currentSceneId;
  final List<String> _choicesMade;
  @override
  @JsonKey(name: 'choices_made')
  List<String> get choicesMade {
    if (_choicesMade is EqualUnmodifiableListView) return _choicesMade;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_choicesMade);
  }

  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PlayerProgress(storyId: $storyId, currentSceneId: $currentSceneId, choicesMade: $choicesMade, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerProgressImpl &&
            (identical(other.storyId, storyId) || other.storyId == storyId) &&
            (identical(other.currentSceneId, currentSceneId) ||
                other.currentSceneId == currentSceneId) &&
            const DeepCollectionEquality()
                .equals(other._choicesMade, _choicesMade) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, storyId, currentSceneId,
      const DeepCollectionEquality().hash(_choicesMade), updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerProgressImplCopyWith<_$PlayerProgressImpl> get copyWith =>
      __$$PlayerProgressImplCopyWithImpl<_$PlayerProgressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerProgressImplToJson(
      this,
    );
  }
}

abstract class _PlayerProgress implements PlayerProgress {
  const factory _PlayerProgress(
      {@JsonKey(name: 'story_id') required final String storyId,
      @JsonKey(name: 'current_scene_id') required final String currentSceneId,
      @JsonKey(name: 'choices_made') final List<String> choicesMade,
      @JsonKey(name: 'updated_at')
      required final DateTime updatedAt}) = _$PlayerProgressImpl;

  factory _PlayerProgress.fromJson(Map<String, dynamic> json) =
      _$PlayerProgressImpl.fromJson;

  @override
  @JsonKey(name: 'story_id')
  String get storyId;
  @override
  @JsonKey(name: 'current_scene_id')
  String get currentSceneId;
  @override
  @JsonKey(name: 'choices_made')
  List<String> get choicesMade;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PlayerProgressImplCopyWith<_$PlayerProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProgressSummary _$ProgressSummaryFromJson(Map<String, dynamic> json) {
  return _ProgressSummary.fromJson(json);
}

/// @nodoc
mixin _$ProgressSummary {
  Story get story => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_scene_id')
  String get currentSceneId => throw _privateConstructorUsedError;
  @JsonKey(name: 'choices_made')
  List<String> get choicesMade => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_scene_order_index')
  int get currentSceneOrderIndex => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_scenes')
  int get totalScenes => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_finished')
  bool get isFinished => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProgressSummaryCopyWith<ProgressSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgressSummaryCopyWith<$Res> {
  factory $ProgressSummaryCopyWith(
          ProgressSummary value, $Res Function(ProgressSummary) then) =
      _$ProgressSummaryCopyWithImpl<$Res, ProgressSummary>;
  @useResult
  $Res call(
      {Story story,
      @JsonKey(name: 'current_scene_id') String currentSceneId,
      @JsonKey(name: 'choices_made') List<String> choicesMade,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'current_scene_order_index') int currentSceneOrderIndex,
      @JsonKey(name: 'total_scenes') int totalScenes,
      @JsonKey(name: 'is_finished') bool isFinished});

  $StoryCopyWith<$Res> get story;
}

/// @nodoc
class _$ProgressSummaryCopyWithImpl<$Res, $Val extends ProgressSummary>
    implements $ProgressSummaryCopyWith<$Res> {
  _$ProgressSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? story = null,
    Object? currentSceneId = null,
    Object? choicesMade = null,
    Object? updatedAt = null,
    Object? currentSceneOrderIndex = null,
    Object? totalScenes = null,
    Object? isFinished = null,
  }) {
    return _then(_value.copyWith(
      story: null == story
          ? _value.story
          : story // ignore: cast_nullable_to_non_nullable
              as Story,
      currentSceneId: null == currentSceneId
          ? _value.currentSceneId
          : currentSceneId // ignore: cast_nullable_to_non_nullable
              as String,
      choicesMade: null == choicesMade
          ? _value.choicesMade
          : choicesMade // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentSceneOrderIndex: null == currentSceneOrderIndex
          ? _value.currentSceneOrderIndex
          : currentSceneOrderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      totalScenes: null == totalScenes
          ? _value.totalScenes
          : totalScenes // ignore: cast_nullable_to_non_nullable
              as int,
      isFinished: null == isFinished
          ? _value.isFinished
          : isFinished // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $StoryCopyWith<$Res> get story {
    return $StoryCopyWith<$Res>(_value.story, (value) {
      return _then(_value.copyWith(story: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProgressSummaryImplCopyWith<$Res>
    implements $ProgressSummaryCopyWith<$Res> {
  factory _$$ProgressSummaryImplCopyWith(_$ProgressSummaryImpl value,
          $Res Function(_$ProgressSummaryImpl) then) =
      __$$ProgressSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Story story,
      @JsonKey(name: 'current_scene_id') String currentSceneId,
      @JsonKey(name: 'choices_made') List<String> choicesMade,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'current_scene_order_index') int currentSceneOrderIndex,
      @JsonKey(name: 'total_scenes') int totalScenes,
      @JsonKey(name: 'is_finished') bool isFinished});

  @override
  $StoryCopyWith<$Res> get story;
}

/// @nodoc
class __$$ProgressSummaryImplCopyWithImpl<$Res>
    extends _$ProgressSummaryCopyWithImpl<$Res, _$ProgressSummaryImpl>
    implements _$$ProgressSummaryImplCopyWith<$Res> {
  __$$ProgressSummaryImplCopyWithImpl(
      _$ProgressSummaryImpl _value, $Res Function(_$ProgressSummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? story = null,
    Object? currentSceneId = null,
    Object? choicesMade = null,
    Object? updatedAt = null,
    Object? currentSceneOrderIndex = null,
    Object? totalScenes = null,
    Object? isFinished = null,
  }) {
    return _then(_$ProgressSummaryImpl(
      story: null == story
          ? _value.story
          : story // ignore: cast_nullable_to_non_nullable
              as Story,
      currentSceneId: null == currentSceneId
          ? _value.currentSceneId
          : currentSceneId // ignore: cast_nullable_to_non_nullable
              as String,
      choicesMade: null == choicesMade
          ? _value._choicesMade
          : choicesMade // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentSceneOrderIndex: null == currentSceneOrderIndex
          ? _value.currentSceneOrderIndex
          : currentSceneOrderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      totalScenes: null == totalScenes
          ? _value.totalScenes
          : totalScenes // ignore: cast_nullable_to_non_nullable
              as int,
      isFinished: null == isFinished
          ? _value.isFinished
          : isFinished // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProgressSummaryImpl implements _ProgressSummary {
  const _$ProgressSummaryImpl(
      {required this.story,
      @JsonKey(name: 'current_scene_id') required this.currentSceneId,
      @JsonKey(name: 'choices_made') final List<String> choicesMade = const [],
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'current_scene_order_index')
      required this.currentSceneOrderIndex,
      @JsonKey(name: 'total_scenes') required this.totalScenes,
      @JsonKey(name: 'is_finished') required this.isFinished})
      : _choicesMade = choicesMade;

  factory _$ProgressSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProgressSummaryImplFromJson(json);

  @override
  final Story story;
  @override
  @JsonKey(name: 'current_scene_id')
  final String currentSceneId;
  final List<String> _choicesMade;
  @override
  @JsonKey(name: 'choices_made')
  List<String> get choicesMade {
    if (_choicesMade is EqualUnmodifiableListView) return _choicesMade;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_choicesMade);
  }

  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'current_scene_order_index')
  final int currentSceneOrderIndex;
  @override
  @JsonKey(name: 'total_scenes')
  final int totalScenes;
  @override
  @JsonKey(name: 'is_finished')
  final bool isFinished;

  @override
  String toString() {
    return 'ProgressSummary(story: $story, currentSceneId: $currentSceneId, choicesMade: $choicesMade, updatedAt: $updatedAt, currentSceneOrderIndex: $currentSceneOrderIndex, totalScenes: $totalScenes, isFinished: $isFinished)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressSummaryImpl &&
            (identical(other.story, story) || other.story == story) &&
            (identical(other.currentSceneId, currentSceneId) ||
                other.currentSceneId == currentSceneId) &&
            const DeepCollectionEquality()
                .equals(other._choicesMade, _choicesMade) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.currentSceneOrderIndex, currentSceneOrderIndex) ||
                other.currentSceneOrderIndex == currentSceneOrderIndex) &&
            (identical(other.totalScenes, totalScenes) ||
                other.totalScenes == totalScenes) &&
            (identical(other.isFinished, isFinished) ||
                other.isFinished == isFinished));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      story,
      currentSceneId,
      const DeepCollectionEquality().hash(_choicesMade),
      updatedAt,
      currentSceneOrderIndex,
      totalScenes,
      isFinished);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressSummaryImplCopyWith<_$ProgressSummaryImpl> get copyWith =>
      __$$ProgressSummaryImplCopyWithImpl<_$ProgressSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProgressSummaryImplToJson(
      this,
    );
  }
}

abstract class _ProgressSummary implements ProgressSummary {
  const factory _ProgressSummary(
      {required final Story story,
      @JsonKey(name: 'current_scene_id') required final String currentSceneId,
      @JsonKey(name: 'choices_made') final List<String> choicesMade,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      @JsonKey(name: 'current_scene_order_index')
      required final int currentSceneOrderIndex,
      @JsonKey(name: 'total_scenes') required final int totalScenes,
      @JsonKey(name: 'is_finished')
      required final bool isFinished}) = _$ProgressSummaryImpl;

  factory _ProgressSummary.fromJson(Map<String, dynamic> json) =
      _$ProgressSummaryImpl.fromJson;

  @override
  Story get story;
  @override
  @JsonKey(name: 'current_scene_id')
  String get currentSceneId;
  @override
  @JsonKey(name: 'choices_made')
  List<String> get choicesMade;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(name: 'current_scene_order_index')
  int get currentSceneOrderIndex;
  @override
  @JsonKey(name: 'total_scenes')
  int get totalScenes;
  @override
  @JsonKey(name: 'is_finished')
  bool get isFinished;
  @override
  @JsonKey(ignore: true)
  _$$ProgressSummaryImplCopyWith<_$ProgressSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChoiceRequest _$ChoiceRequestFromJson(Map<String, dynamic> json) {
  return _ChoiceRequest.fromJson(json);
}

/// @nodoc
mixin _$ChoiceRequest {
  @JsonKey(name: 'choice_id')
  String get choiceId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChoiceRequestCopyWith<ChoiceRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChoiceRequestCopyWith<$Res> {
  factory $ChoiceRequestCopyWith(
          ChoiceRequest value, $Res Function(ChoiceRequest) then) =
      _$ChoiceRequestCopyWithImpl<$Res, ChoiceRequest>;
  @useResult
  $Res call({@JsonKey(name: 'choice_id') String choiceId});
}

/// @nodoc
class _$ChoiceRequestCopyWithImpl<$Res, $Val extends ChoiceRequest>
    implements $ChoiceRequestCopyWith<$Res> {
  _$ChoiceRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? choiceId = null,
  }) {
    return _then(_value.copyWith(
      choiceId: null == choiceId
          ? _value.choiceId
          : choiceId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChoiceRequestImplCopyWith<$Res>
    implements $ChoiceRequestCopyWith<$Res> {
  factory _$$ChoiceRequestImplCopyWith(
          _$ChoiceRequestImpl value, $Res Function(_$ChoiceRequestImpl) then) =
      __$$ChoiceRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'choice_id') String choiceId});
}

/// @nodoc
class __$$ChoiceRequestImplCopyWithImpl<$Res>
    extends _$ChoiceRequestCopyWithImpl<$Res, _$ChoiceRequestImpl>
    implements _$$ChoiceRequestImplCopyWith<$Res> {
  __$$ChoiceRequestImplCopyWithImpl(
      _$ChoiceRequestImpl _value, $Res Function(_$ChoiceRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? choiceId = null,
  }) {
    return _then(_$ChoiceRequestImpl(
      choiceId: null == choiceId
          ? _value.choiceId
          : choiceId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChoiceRequestImpl implements _ChoiceRequest {
  const _$ChoiceRequestImpl(
      {@JsonKey(name: 'choice_id') required this.choiceId});

  factory _$ChoiceRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChoiceRequestImplFromJson(json);

  @override
  @JsonKey(name: 'choice_id')
  final String choiceId;

  @override
  String toString() {
    return 'ChoiceRequest(choiceId: $choiceId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChoiceRequestImpl &&
            (identical(other.choiceId, choiceId) ||
                other.choiceId == choiceId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, choiceId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChoiceRequestImplCopyWith<_$ChoiceRequestImpl> get copyWith =>
      __$$ChoiceRequestImplCopyWithImpl<_$ChoiceRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChoiceRequestImplToJson(
      this,
    );
  }
}

abstract class _ChoiceRequest implements ChoiceRequest {
  const factory _ChoiceRequest(
          {@JsonKey(name: 'choice_id') required final String choiceId}) =
      _$ChoiceRequestImpl;

  factory _ChoiceRequest.fromJson(Map<String, dynamic> json) =
      _$ChoiceRequestImpl.fromJson;

  @override
  @JsonKey(name: 'choice_id')
  String get choiceId;
  @override
  @JsonKey(ignore: true)
  _$$ChoiceRequestImplCopyWith<_$ChoiceRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
