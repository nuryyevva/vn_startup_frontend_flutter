import '../domain/models/achievement.dart';
import 'achievements_api.dart';
import 'achievements_repository.dart';

class AchievementsRepositoryImpl implements AchievementsRepository {
  AchievementsRepositoryImpl(this._api);

  final AchievementsApi _api;

  @override
  Future<List<Achievement>> getAchievements() => _api.getAchievements();
}
