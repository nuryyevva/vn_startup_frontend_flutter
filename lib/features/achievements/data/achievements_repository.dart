import '../domain/models/achievement.dart';

abstract class AchievementsRepository {
  Future<List<Achievement>> getAchievements();
}
