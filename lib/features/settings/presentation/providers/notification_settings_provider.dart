import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_mode_provider.dart';

const _newChapterAlertsKey = 'nocturne.notif.new_chapter_alerts';
const _promotionalOffersKey = 'nocturne.notif.promotional_offers';

class NotificationSettings {
  const NotificationSettings({required this.newChapterAlerts, required this.promotionalOffers});

  final bool newChapterAlerts;
  final bool promotionalOffers;

  NotificationSettings copyWith({bool? newChapterAlerts, bool? promotionalOffers}) {
    return NotificationSettings(
      newChapterAlerts: newChapterAlerts ?? this.newChapterAlerts,
      promotionalOffers: promotionalOffers ?? this.promotionalOffers,
    );
  }
}

/// The backend has no notification-preference fields (see README "known
/// limitations") — these are purely local, persisted the same way as
/// theme choice.
class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  NotificationSettingsNotifier(this._prefs)
    : super(
        NotificationSettings(
          newChapterAlerts: _prefs.getBool(_newChapterAlertsKey) ?? true,
          promotionalOffers: _prefs.getBool(_promotionalOffersKey) ?? false,
        ),
      );

  final SharedPreferences _prefs;

  Future<void> setNewChapterAlerts(bool value) async {
    state = state.copyWith(newChapterAlerts: value);
    await _prefs.setBool(_newChapterAlertsKey, value);
  }

  Future<void> setPromotionalOffers(bool value) async {
    state = state.copyWith(promotionalOffers: value);
    await _prefs.setBool(_promotionalOffersKey, value);
  }
}

final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>((ref) {
  return NotificationSettingsNotifier(ref.watch(sharedPreferencesProvider));
});
