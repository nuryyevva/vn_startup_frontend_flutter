import 'package:freezed_annotation/freezed_annotation.dart';

part 'story.freezed.dart';
part 'story.g.dart';

/// Mirrors `internal/story/models.go`'s `StoryResponse`.
@freezed
class Story with _$Story {
  const factory Story({
    required String id,
    required String title,
    String? description,
    @JsonKey(name: 'cover_url') String? coverUrl,
    required String genre,
    required String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}

@freezed
class Choice with _$Choice {
  const factory Choice({
    required String id,
    required String text,
    @JsonKey(name: 'is_paid') required bool isPaid,
    @JsonKey(name: 'cost_diamonds') required int costDiamonds,
    @JsonKey(name: 'next_scene_id') String? nextSceneId,
  }) = _Choice;

  factory Choice.fromJson(Map<String, dynamic> json) => _$ChoiceFromJson(json);
}

/// Mirrors `SceneResponse` — the full scene payload (dialogue script,
/// choices), returned only once the player is allowed to see it (see
/// `GetSceneForPlayer` on the backend: `402 scene_locked` otherwise).
@freezed
class Scene with _$Scene {
  const factory Scene({
    required String id,
    @JsonKey(name: 'story_id') required String storyId,
    @JsonKey(name: 'order_index') required int orderIndex,
    @JsonKey(name: 'background_url') String? backgroundUrl,
    @JsonKey(name: 'character_id') String? characterId,
    @JsonKey(name: 'dialogue_script') required List<dynamic> dialogueScript,
    @JsonKey(name: 'free_dialog_enabled') required bool freeDialogEnabled,
    @JsonKey(name: 'dialog_limit_type') String? dialogLimitType,
    @JsonKey(name: 'dialog_limit_value') int? dialogLimitValue,
    @JsonKey(name: 'unlock_cost_diamonds') int? unlockCostDiamonds,
    @Default([]) List<Choice> choices,
  }) = _Scene;

  factory Scene.fromJson(Map<String, dynamic> json) => _$SceneFromJson(json);
}

/// Mirrors the lightweight `SceneSummaryResponse` from `GET /stories/:id/scenes`
/// — used for the chapter list, without each chapter's full dialogue script.
@freezed
class SceneSummary with _$SceneSummary {
  const factory SceneSummary({
    required String id,
    @JsonKey(name: 'order_index') required int orderIndex,
    @JsonKey(name: 'unlock_cost_diamonds') int? unlockCostDiamonds,
    @JsonKey(name: 'is_unlocked') required bool isUnlocked,
  }) = _SceneSummary;

  factory SceneSummary.fromJson(Map<String, dynamic> json) => _$SceneSummaryFromJson(json);
}

@freezed
class PlayerProgress with _$PlayerProgress {
  const factory PlayerProgress({
    @JsonKey(name: 'story_id') required String storyId,
    @JsonKey(name: 'current_scene_id') required String currentSceneId,
    @JsonKey(name: 'choices_made') @Default([]) List<String> choicesMade,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _PlayerProgress;

  factory PlayerProgress.fromJson(Map<String, dynamic> json) => _$PlayerProgressFromJson(json);
}

/// Mirrors `ProgressSummaryResponse` from `GET /progress` — a story the
/// player has already started, joined with enough scene-count info to
/// compute a "% complete" bar without extra requests.
@freezed
class ProgressSummary with _$ProgressSummary {
  const factory ProgressSummary({
    required Story story,
    @JsonKey(name: 'current_scene_id') required String currentSceneId,
    @JsonKey(name: 'choices_made') @Default([]) List<String> choicesMade,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'current_scene_order_index') required int currentSceneOrderIndex,
    @JsonKey(name: 'total_scenes') required int totalScenes,
    @JsonKey(name: 'is_finished') required bool isFinished,
  }) = _ProgressSummary;

  factory ProgressSummary.fromJson(Map<String, dynamic> json) => _$ProgressSummaryFromJson(json);
}

extension ProgressSummaryPercent on ProgressSummary {
  /// 0..100, rounded — `currentSceneOrderIndex` is 0-based so a player on
  /// the first of 5 scenes is at 0/5, not 1/5 (they haven't finished a
  /// scene yet); on the last (index 4 of 5) they're at 4/5 = 80%, with the
  /// jump to 100% happening via `isFinished`, not this percentage alone.
  int get percentComplete {
    if (totalScenes <= 0) return 0;
    if (isFinished) return 100;
    return ((currentSceneOrderIndex / totalScenes) * 100).clamp(0, 100).round();
  }
}

@freezed
class ChoiceRequest with _$ChoiceRequest {
  const factory ChoiceRequest({@JsonKey(name: 'choice_id') required String choiceId}) = _ChoiceRequest;

  factory ChoiceRequest.fromJson(Map<String, dynamic> json) => _$ChoiceRequestFromJson(json);
}
