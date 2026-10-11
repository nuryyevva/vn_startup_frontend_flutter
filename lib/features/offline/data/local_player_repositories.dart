import '../../achievements/data/achievements_repository.dart';
import '../../achievements/domain/models/achievement.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/domain/models/auth_user.dart';
import '../../profile/data/user_repository.dart';
import '../../profile/domain/models/user_profile.dart';
import '../../stats/data/stats_repository.dart';
import '../../stats/domain/models/user_stats.dart';
import 'bundled_story_repository.dart';
import 'local_store.dart';
import 'local_wallet.dart';

/// The offline build has one player — whoever holds the device — and no
/// accounts. This id/email pair stands in wherever a user record is needed.
const _localUserId = 'local';
const _localUserEmail = 'offline@device';

/// There is nothing to sign in to offline: a session always "exists", and
/// the sign-in form (reachable only after an explicit sign-out) accepts
/// anything and leads straight back in.
class LocalAuthRepository implements AuthRepository {
  const LocalAuthRepository();

  static const _user = AuthUser(id: _localUserId, email: _localUserEmail, role: 'user');

  @override
  Future<bool> hasStoredSession() async => true;

  @override
  Future<AuthUser> register(String email, String password) async => _user;

  @override
  Future<AuthUser> login(String email, String password) async => _user;

  @override
  Future<void> logout() async {}

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {}
}

class LocalUserRepository implements UserRepository {
  LocalUserRepository(this._store, {DateTime Function() now = DateTime.now}) : _now = now;

  final LocalStore _store;
  final DateTime Function() _now;

  static const _key = 'profile';

  @override
  Future<UserProfile> getMe() async {
    final saved = _store.readMap(_key);
    if (saved.isNotEmpty) return UserProfile.fromJson(saved);
    final created = UserProfile(
      userId: _localUserId,
      email: _localUserEmail,
      role: 'user',
      createdAt: _now(),
      updatedAt: _now(),
    );
    await _store.writeMap(_key, created.toJson());
    return created;
  }

  /// PATCH semantics, like the API: only non-null fields change.
  @override
  Future<UserProfile> updateMe(UpdateProfileRequest request) async {
    final current = await getMe();
    final updated = current.copyWith(
      displayName: request.displayName ?? current.displayName,
      gender: request.gender ?? current.gender,
      favoriteGenres: request.favoriteGenres ?? current.favoriteGenres,
      theme: request.theme ?? current.theme,
      language: request.language ?? current.language,
      notifyNewChapters: request.notifyNewChapters ?? current.notifyNewChapters,
      notifyPromotionalOffers: request.notifyPromotionalOffers ?? current.notifyPromotionalOffers,
      updatedAt: _now(),
    );
    await _store.writeMap(_key, updated.toJson());
    return updated;
  }
}

/// Reading time and the day streak, counted on the device the same way the
/// backend's stats module does: a day counts once any reading time is
/// reported on it, and the streak breaks after a day without any.
class LocalStatsRepository implements StatsRepository {
  LocalStatsRepository(this._store, {DateTime Function() now = DateTime.now}) : _now = now;

  final LocalStore _store;
  final DateTime Function() _now;

  static const _key = 'stats';

  @override
  Future<UserStats> getStats() async => current;

  UserStats get current {
    final s = _store.readMap(_key);
    final seconds = (s['total_reading_seconds'] as int?) ?? 0;
    final lastDay = DateTime.tryParse((s['last_day'] as String?) ?? '');
    // A streak that wasn't continued yesterday or today is over, even
    // though nothing has overwritten the stored number yet.
    final alive = lastDay != null && _today().difference(lastDay).inDays <= 1;
    return UserStats(
      dayStreak: alive ? (s['day_streak'] as int?) ?? 0 : 0,
      longestStreak: (s['longest_streak'] as int?) ?? 0,
      totalReadingSeconds: seconds,
      hoursRead: seconds / 3600,
    );
  }

  @override
  Future<UserStats> heartbeat(int seconds) async {
    final s = _store.readMap(_key);
    final today = _today();
    final lastDay = DateTime.tryParse((s['last_day'] as String?) ?? '');
    final gap = lastDay == null ? null : today.difference(lastDay).inDays;
    final previous = (s['day_streak'] as int?) ?? 0;
    final streak = switch (gap) {
      0 => previous,
      1 => previous + 1,
      _ => 1,
    };
    final longest = (s['longest_streak'] as int?) ?? 0;
    await _store.writeMap(_key, {
      'total_reading_seconds': ((s['total_reading_seconds'] as int?) ?? 0) + seconds,
      'day_streak': streak,
      'longest_streak': streak > longest ? streak : longest,
      'last_day': today.toIso8601String(),
    });
    return current;
  }

  DateTime _today() {
    final now = _now().toUtc();
    return DateTime.utc(now.year, now.month, now.day);
  }
}

/// The achievement catalog and its unlock rules — a copy of the backend's
/// `internal/achievement/catalog.go`, which is the source of truth; keep
/// the ids identical. The free-dialogue achievements are listed but can't
/// be earned offline (there's no AI character to talk to).
class LocalAchievementsRepository implements AchievementsRepository {
  LocalAchievementsRepository({
    required LocalStore store,
    required BundledStoryRepository stories,
    required LocalWallet wallet,
    required LocalStatsRepository stats,
    DateTime Function() now = DateTime.now,
  }) : _store = store,
       _stories = stories,
       _wallet = wallet,
       _stats = stats,
       _now = now;

  final LocalStore _store;
  final BundledStoryRepository _stories;
  final LocalWallet _wallet;
  final LocalStatsRepository _stats;
  final DateTime Function() _now;

  static const _key = 'achievements.unlocked';

  @override
  Future<List<Achievement>> getAchievements() async {
    final activity = (
      finishedStories: _stories.progressSummaries.where((p) => p.isFinished).length,
      unlockedScenes: _stories.unlockedSceneIds.length,
      diamondsSpent: _wallet.spent,
      dayStreak: _stats.current.dayStreak,
    );
    final catalog = <({String id, String title, String description, bool earned})>[
      (
        id: 'first_story_finished',
        title: 'Первая история',
        description: 'Заверши свою первую историю',
        earned: activity.finishedStories >= 1,
      ),
      (
        id: 'story_collector',
        title: 'Коллекционер историй',
        description: 'Заверши 3 истории',
        earned: activity.finishedStories >= 3,
      ),
      (
        id: 'bookworm',
        title: 'Книжный червь',
        description: 'Заверши 10 историй',
        earned: activity.finishedStories >= 10,
      ),
      (
        id: 'first_words',
        title: 'Первые слова',
        description: 'Отправь своё первое сообщение в свободном диалоге',
        earned: false,
      ),
      (id: 'chatterbox', title: 'Болтушка', description: 'Отправь 50 сообщений в свободном диалоге', earned: false),
      (
        id: 'deep_talker',
        title: 'Глубокий разговор',
        description: 'Отправь 200 сообщений в свободном диалоге',
        earned: false,
      ),
      (
        id: 'generous',
        title: 'Первая трата',
        description: 'Потрать свои первые алмазы',
        earned: activity.diamondsSpent >= 1,
      ),
      (
        id: 'big_spender',
        title: 'Щедрая душа',
        description: 'Потрать 500 алмазов',
        earned: activity.diamondsSpent >= 500,
      ),
      (
        id: 'explorer',
        title: 'Исследователь',
        description: 'Разблокируй 5 платных глав',
        earned: activity.unlockedScenes >= 5,
      ),
      (
        id: 'week_streak',
        title: 'Неделя подряд',
        description: 'Читай истории 7 дней подряд',
        earned: activity.dayStreak >= 7,
      ),
      (
        id: 'month_streak',
        title: 'Месяц подряд',
        description: 'Читай истории 30 дней подряд',
        earned: activity.dayStreak >= 30,
      ),
    ];

    // Once unlocked, an achievement stays unlocked (a streak ending later
    // doesn't take it back) — so the unlock time is stored, not recomputed.
    final unlocked = _store.readMap(_key);
    var changed = false;
    final result = <Achievement>[];
    for (final a in catalog) {
      if (unlocked[a.id] == null && a.earned) {
        unlocked[a.id] = _now().toIso8601String();
        changed = true;
      }
      final unlockedAt = DateTime.tryParse((unlocked[a.id] as String?) ?? '');
      result.add(
        Achievement(
          id: a.id,
          title: a.title,
          description: a.description,
          unlocked: unlockedAt != null,
          unlockedAt: unlockedAt,
        ),
      );
    }
    if (changed) await _store.writeMap(_key, unlocked);
    return result;
  }
}
