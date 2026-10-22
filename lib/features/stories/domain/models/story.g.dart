// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoryImpl _$$StoryImplFromJson(Map<String, dynamic> json) => _$StoryImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      coverUrl: json['cover_url'] as String?,
      genre: json['genre'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      playerTheme: json['player_theme'] as Map<String, dynamic>?,
      comingSoon: json['coming_soon'] as bool? ?? false,
    );

Map<String, dynamic> _$$StoryImplToJson(_$StoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'cover_url': instance.coverUrl,
      'genre': instance.genre,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'player_theme': instance.playerTheme,
      'coming_soon': instance.comingSoon,
    };

_$StoryPageImpl _$$StoryPageImplFromJson(Map<String, dynamic> json) =>
    _$StoryPageImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => Story.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['page_size'] as int,
    );

Map<String, dynamic> _$$StoryPageImplToJson(_$StoryPageImpl instance) =>
    <String, dynamic>{
      'items': instance.items,
      'total': instance.total,
      'page': instance.page,
      'page_size': instance.pageSize,
    };

_$ChoiceImpl _$$ChoiceImplFromJson(Map<String, dynamic> json) => _$ChoiceImpl(
      id: json['id'] as String,
      text: json['text'] as String,
      isPaid: json['is_paid'] as bool,
      costDiamonds: json['cost_diamonds'] as int,
      nextSceneId: json['next_scene_id'] as String?,
    );

Map<String, dynamic> _$$ChoiceImplToJson(_$ChoiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'is_paid': instance.isPaid,
      'cost_diamonds': instance.costDiamonds,
      'next_scene_id': instance.nextSceneId,
    };

_$SceneImpl _$$SceneImplFromJson(Map<String, dynamic> json) => _$SceneImpl(
      id: json['id'] as String,
      storyId: json['story_id'] as String,
      orderIndex: json['order_index'] as int,
      backgroundUrl: json['background_url'] as String?,
      characterId: json['character_id'] as String?,
      dialogueScript: json['dialogue_script'] as List<dynamic>,
      freeDialogEnabled: json['free_dialog_enabled'] as bool,
      dialogLimitType: json['dialog_limit_type'] as String?,
      dialogLimitValue: json['dialog_limit_value'] as int?,
      unlockCostDiamonds: json['unlock_cost_diamonds'] as int?,
      characterSpriteUrl: json['character_sprite_url'] as String?,
      spriteFraming: $enumDecodeNullable(
              _$SpriteFramingEnumMap, json['sprite_framing'],
              unknownValue: SpriteFraming.full) ??
          SpriteFraming.full,
      backgroundMusicUrl: json['background_music_url'] as String?,
      chapterTitle: json['chapter_title'] as String?,
      title: json['title'] as String?,
      choices: (json['choices'] as List<dynamic>?)
              ?.map((e) => Choice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SceneImplToJson(_$SceneImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'story_id': instance.storyId,
      'order_index': instance.orderIndex,
      'background_url': instance.backgroundUrl,
      'character_id': instance.characterId,
      'dialogue_script': instance.dialogueScript,
      'free_dialog_enabled': instance.freeDialogEnabled,
      'dialog_limit_type': instance.dialogLimitType,
      'dialog_limit_value': instance.dialogLimitValue,
      'unlock_cost_diamonds': instance.unlockCostDiamonds,
      'character_sprite_url': instance.characterSpriteUrl,
      'sprite_framing': _$SpriteFramingEnumMap[instance.spriteFraming]!,
      'background_music_url': instance.backgroundMusicUrl,
      'chapter_title': instance.chapterTitle,
      'title': instance.title,
      'choices': instance.choices,
    };

const _$SpriteFramingEnumMap = {
  SpriteFraming.full: 'full',
  SpriteFraming.knees: 'knees',
  SpriteFraming.waist: 'waist',
};

_$SceneSummaryImpl _$$SceneSummaryImplFromJson(Map<String, dynamic> json) =>
    _$SceneSummaryImpl(
      id: json['id'] as String,
      orderIndex: json['order_index'] as int,
      unlockCostDiamonds: json['unlock_cost_diamonds'] as int?,
      isUnlocked: json['is_unlocked'] as bool,
      chapterTitle: json['chapter_title'] as String?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$$SceneSummaryImplToJson(_$SceneSummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_index': instance.orderIndex,
      'unlock_cost_diamonds': instance.unlockCostDiamonds,
      'is_unlocked': instance.isUnlocked,
      'chapter_title': instance.chapterTitle,
      'title': instance.title,
    };

_$PlayerProgressImpl _$$PlayerProgressImplFromJson(Map<String, dynamic> json) =>
    _$PlayerProgressImpl(
      storyId: json['story_id'] as String,
      currentSceneId: json['current_scene_id'] as String,
      choicesMade: (json['choices_made'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PlayerProgressImplToJson(
        _$PlayerProgressImpl instance) =>
    <String, dynamic>{
      'story_id': instance.storyId,
      'current_scene_id': instance.currentSceneId,
      'choices_made': instance.choicesMade,
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$ProgressSummaryImpl _$$ProgressSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$ProgressSummaryImpl(
      story: Story.fromJson(json['story'] as Map<String, dynamic>),
      currentSceneId: json['current_scene_id'] as String,
      choicesMade: (json['choices_made'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      updatedAt: DateTime.parse(json['updated_at'] as String),
      currentSceneOrderIndex: json['current_scene_order_index'] as int,
      totalScenes: json['total_scenes'] as int,
      isFinished: json['is_finished'] as bool,
    );

Map<String, dynamic> _$$ProgressSummaryImplToJson(
        _$ProgressSummaryImpl instance) =>
    <String, dynamic>{
      'story': instance.story,
      'current_scene_id': instance.currentSceneId,
      'choices_made': instance.choicesMade,
      'updated_at': instance.updatedAt.toIso8601String(),
      'current_scene_order_index': instance.currentSceneOrderIndex,
      'total_scenes': instance.totalScenes,
      'is_finished': instance.isFinished,
    };

_$ChoiceRequestImpl _$$ChoiceRequestImplFromJson(Map<String, dynamic> json) =>
    _$ChoiceRequestImpl(
      choiceId: json['choice_id'] as String,
    );

Map<String, dynamic> _$$ChoiceRequestImplToJson(_$ChoiceRequestImpl instance) =>
    <String, dynamic>{
      'choice_id': instance.choiceId,
    };
