/// JSON keys whose values are media URLs (images/audio) in API responses —
/// including the per-line keys inside a scene's `dialogue_script`.
const _mediaUrlKeys = {
  'cover_url',
  'avatar_url',
  'background_url',
  'character_sprite_url',
  'background_music_url',
  'sprite_url',
  'sfx_url',
};

/// Resolves a root-relative media URL (e.g. `/media/stories/...`, served by
/// the API itself — see `MediaConfig` on the backend) against [baseUrl].
/// Absolute URLs (hotlinked sample art) and empty strings (the "hide the
/// sprite" sentinel in dialogue scripts) pass through unchanged. Storing
/// relative URLs is what lets the same seeded rows work for web
/// (`localhost`), the Android emulator (`10.0.2.2`) and a real phone (LAN
/// IP) — each build already knows its own API base URL.
String resolveMediaUrl(String url, String baseUrl) {
  if (!url.startsWith('/') || url.startsWith('//')) return url;
  return Uri.parse(baseUrl).resolve(url).toString();
}

/// Returns a copy of a decoded JSON value with every media URL under
/// [_mediaUrlKeys] resolved via [resolveMediaUrl], at any nesting depth.
Object? resolveMediaUrlsInJson(Object? json, String baseUrl) {
  if (json is Map<String, dynamic>) {
    return json.map((key, value) {
      if (value is String && _mediaUrlKeys.contains(key)) {
        return MapEntry(key, resolveMediaUrl(value, baseUrl));
      }
      return MapEntry(key, resolveMediaUrlsInJson(value, baseUrl));
    });
  }
  if (json is List) {
    return json.map((e) => resolveMediaUrlsInJson(e, baseUrl)).toList();
  }
  return json;
}
