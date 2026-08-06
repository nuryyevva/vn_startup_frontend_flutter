import 'package:freezed_annotation/freezed_annotation.dart';

part 'dialog_message.freezed.dart';
part 'dialog_message.g.dart';

/// Mirrors `internal/dialog/models.go`'s `MessageResponse` for the REST
/// send-message call, and doubles as the in-memory chat-list entry for
/// character replies assembled from WS chunks (which never populate
/// [remainingLimit] — that only ever comes from the synchronous REST
/// response to the user's own message, see `DialogSessionNotifier`).
@freezed
class DialogMessage with _$DialogMessage {
  const factory DialogMessage({
    required String id,
    required String sender, // 'user' | 'character'
    required String text,
    @Default(false) bool isStreaming,
    @JsonKey(name: 'cost_diamonds') @Default(0) int costDiamonds,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'remaining_limit') int? remainingLimit,
  }) = _DialogMessage;

  factory DialogMessage.fromJson(Map<String, dynamic> json) => _$DialogMessageFromJson(json);
}
