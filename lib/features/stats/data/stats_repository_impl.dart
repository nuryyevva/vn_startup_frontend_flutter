import '../domain/models/user_stats.dart';
import 'stats_api.dart';
import 'stats_repository.dart';

class StatsRepositoryImpl implements StatsRepository {
  StatsRepositoryImpl(this._api);

  final StatsApi _api;

  @override
  Future<UserStats> getStats() => _api.getStats();

  @override
  Future<UserStats> heartbeat(int seconds) => _api.heartbeat(seconds);
}
