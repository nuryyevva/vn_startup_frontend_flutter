import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/stats_api.dart';
import '../../data/stats_repository.dart';
import '../../data/stats_repository_impl.dart';
import '../../domain/models/user_stats.dart';

final statsApiProvider = Provider<StatsApi>((ref) => StatsApi(ref.watch(dioProvider)));

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepositoryImpl(ref.watch(statsApiProvider));
});

/// Reading stats (day streak, hours read), shown on the profile screen.
/// [sendHeartbeat] is the only thing that ever advances them — see the
/// scene player, which calls it periodically while a scene is on screen.
class ReadingStatsNotifier extends StateNotifier<AsyncValue<UserStats>> {
  ReadingStatsNotifier(this._repository) : super(const AsyncValue.loading()) {
    unawaited(refresh());
  }

  final StatsRepository _repository;

  Future<void> refresh() async {
    state = await AsyncValue.guard(_repository.getStats);
  }

  /// Best-effort: a failed heartbeat just means this interval's reading time
  /// isn't counted — not worth surfacing to the user or retrying, the next
  /// periodic call will carry on normally.
  Future<void> sendHeartbeat(int seconds) async {
    try {
      final updated = await _repository.heartbeat(seconds);
      state = AsyncValue.data(updated);
    } catch (_) {
      // Ignore — see doc comment above.
    }
  }
}

final readingStatsProvider = StateNotifierProvider<ReadingStatsNotifier, AsyncValue<UserStats>>((ref) {
  return ReadingStatsNotifier(ref.watch(statsRepositoryProvider));
});
