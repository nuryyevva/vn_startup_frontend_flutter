import 'package:freezed_annotation/freezed_annotation.dart';

part 'achievement.freezed.dart';
part 'achievement.g.dart';

/// Mirrors `internal/achievement/models.go`'s `AchievementResponse`. The
/// catalog (title/description per id) lives entirely on the backend — see
/// `internal/achievement/catalog.go` — so there's no client-side copy to
/// keep in sync.
@freezed
class Achievement with _$Achievement {
  const factory Achievement({
    required String id,
    required String title,
    required String description,
    required bool unlocked,
    @JsonKey(name: 'unlocked_at') DateTime? unlockedAt,
  }) = _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) => _$AchievementFromJson(json);
}
