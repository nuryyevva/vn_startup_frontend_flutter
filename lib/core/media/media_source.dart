import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

/// Media URLs come in two kinds: ordinary http(s) URLs (art served by the
/// API or hotlinked), and `asset:<path>` URLs pointing into the app bundle —
/// what the offline build's content uses (see `features/offline`). These
/// helpers are the only place that distinction is made; widgets and players
/// take whatever they return.
const _assetScheme = 'asset:';

/// The `asset:` URL for a file bundled at [assetPath] (e.g.
/// `assets/content/media/...`).
String bundledMediaUrl(String assetPath) => '$_assetScheme$assetPath';

String? _assetPathOf(String url) => url.startsWith(_assetScheme) ? url.substring(_assetScheme.length) : null;

ImageProvider mediaImageProvider(String url) {
  final assetPath = _assetPathOf(url);
  return assetPath == null ? NetworkImage(url) : AssetImage(assetPath);
}

Source mediaAudioSource(String url) {
  final assetPath = _assetPathOf(url);
  if (assetPath == null) return UrlSource(url);
  // AssetSource paths are relative to the bundle's `assets/` directory.
  return AssetSource(assetPath.startsWith('assets/') ? assetPath.substring('assets/'.length) : assetPath);
}
