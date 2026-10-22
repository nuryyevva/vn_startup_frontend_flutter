import 'package:freezed_annotation/freezed_annotation.dart';

part 'dialog_session.freezed.dart';
part 'dialog_session.g.dart';

/// Mirrors `internal/dialog/models.go`'s `SessionResponse`.
@freezed
class DialogSession with _$DialogSession {
  const factory DialogSession({
    required String id,
    @JsonKey(name: 'character_id') required String characterId,
    @JsonKey(name: 'scene_id') required String sceneId,
    required String status,
    @JsonKey(name: 'limit_type') required String limitType,
    @JsonKey(name: 'limit_value') int? limitValue,
    @JsonKey(name: 'message_count') @Default(0) int messageCount,

    /// Diamonds each message costs; null from a backend that doesn't say.
    @JsonKey(name: 'message_cost') int? messageCost,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    @JsonKey(name: 'end_reason') String? endReason,
  }) = _DialogSession;

  factory DialogSession.fromJson(Map<String, dynamic> json) => _$DialogSessionFromJson(json);
}
