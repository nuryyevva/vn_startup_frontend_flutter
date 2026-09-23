import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/achievements_api.dart';
import '../../data/achievements_repository.dart';
import '../../data/achievements_repository_impl.dart';
import '../../domain/models/achievement.dart';

final achievementsApiProvider = Provider<AchievementsApi>((ref) => AchievementsApi(ref.watch(dioProvider)));

final achievementsRepositoryProvider = Provider<AchievementsRepository>((ref) {
  return AchievementsRepositoryImpl(ref.watch(achievementsApiProvider));
});

/// The achievement catalog joined with the signed-in user's unlock state.
/// Achievements are evaluated (and, if newly earned, persisted) lazily by
/// the backend on every fetch — see `internal/achievement`'s service doc
/// comment — so re-fetching this after any activity is enough to pick up
/// newly-unlocked achievements.
final achievementsProvider = FutureProvider<List<Achievement>>((ref) {
  return ref.watch(achievementsRepositoryProvider).getAchievements();
});
