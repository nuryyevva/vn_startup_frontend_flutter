import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';

/// Neutral rectangle with a centered image icon — the stand-in for any
/// `cover_url`/`avatar_url`/`background_url` the backend hasn't populated
/// yet. Never shows a "browse files" affordance; this is read-only display,
/// not an uploader (see project spec §0).
class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key, this.icon, this.iconSize = 32});

  final IconData? icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      color: colors.surfaceElevated,
      alignment: Alignment.center,
      child: Icon(icon ?? LucideIcons.image, color: colors.textMuted, size: iconSize),
    );
  }
}

/// Renders [url] via `Image.network` once it's non-empty, falling back to
/// [ImagePlaceholder] while there's no URL, while it's loading, or if it
/// fails to load. This is the one place `cover_url`/`avatar_url`/
/// `background_url` should be rendered from — screens never call
/// `Image.network` directly.
class RemoteImage extends StatelessWidget {
  const RemoteImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderIcon,
  });

  final String? url;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final IconData? placeholderIcon;

  @override
  Widget build(BuildContext context) {
    final url = this.url;
    final child = (url == null || url.isEmpty)
        ? ImagePlaceholder(icon: placeholderIcon)
        : Image.network(
            url,
            fit: fit,
            loadingBuilder: (context, child, progress) =>
                progress == null ? child : ImagePlaceholder(icon: placeholderIcon),
            errorBuilder: (context, error, stackTrace) => ImagePlaceholder(icon: placeholderIcon),
          );

    if (borderRadius == null) return child;
    return ClipRRect(borderRadius: borderRadius!, child: child);
  }
}
