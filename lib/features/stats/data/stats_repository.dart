import '../domain/models/user_stats.dart';

abstract class StatsRepository {
  Future<UserStats> getStats();
  Future<UserStats> heartbeat(int seconds);
}
