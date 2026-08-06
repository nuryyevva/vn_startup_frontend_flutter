import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../settings/presentation/providers/theme_mode_provider.dart';

const _bookmarksKey = 'nocturne.bookmarked_story_ids';

/// The backend has no "add to library"/bookmark endpoint (see README
/// "known limitations") — this is a local-only favorite, persisted the
/// same way as theme choice, layered on top of whatever `GET /stories`
/// already returns rather than a real synced feature.
class LocalBookmarksNotifier extends StateNotifier<Set<String>> {
  LocalBookmarksNotifier(this._prefs) : super((_prefs.getStringList(_bookmarksKey) ?? const []).toSet());

  final SharedPreferences _prefs;

  Future<void> toggle(String storyId) async {
    final next = {...state};
    if (!next.remove(storyId)) {
      next.add(storyId);
    }
    state = next;
    await _prefs.setStringList(_bookmarksKey, next.toList());
  }
}

final localBookmarksProvider = StateNotifierProvider<LocalBookmarksNotifier, Set<String>>((ref) {
  return LocalBookmarksNotifier(ref.watch(sharedPreferencesProvider));
});
