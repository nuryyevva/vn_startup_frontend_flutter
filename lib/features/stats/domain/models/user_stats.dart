import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats.freezed.dart';
part 'user_stats.g.dart';

/// Mirrors `internal/stats/models.go`'s `StatsResponse`. There is no other
/// source of reading-time data — `hoursRead`/`totalReadingSeconds` only grow
/// when the client calls `POST /stats/heartbeat` (see
/// `ReadingStatsNotifier.sendHeartbeat`, fired periodically by the scene
/// player while a scene is on screen).
@freezed
class UserStats with _$UserStats {
  const factory UserStats({
    @JsonKey(name: 'day_streak') required int dayStreak,
    @JsonKey(name: 'longest_streak') required int longestStreak,
    @JsonKey(name: 'total_reading_seconds') required int totalReadingSeconds,
    @JsonKey(name: 'hours_read') required double hoursRead,
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) => _$UserStatsFromJson(json);
}
