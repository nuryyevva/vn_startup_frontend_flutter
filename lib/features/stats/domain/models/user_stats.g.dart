// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserStatsImpl _$$UserStatsImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsImpl(
      dayStreak: json['day_streak'] as int,
      longestStreak: json['longest_streak'] as int,
      totalReadingSeconds: json['total_reading_seconds'] as int,
      hoursRead: (json['hours_read'] as num).toDouble(),
    );

Map<String, dynamic> _$$UserStatsImplToJson(_$UserStatsImpl instance) =>
    <String, dynamic>{
      'day_streak': instance.dayStreak,
      'longest_streak': instance.longestStreak,
      'total_reading_seconds': instance.totalReadingSeconds,
      'hours_read': instance.hoursRead,
    };
