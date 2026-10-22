import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';

/// The app's one way of saying "not yet, but soon" — for anything that is
/// visible but not available yet (buying diamonds, a story still in the
/// works). A light floating note with a sparkle, never an error.
void showComingSoonSnackBar(BuildContext context, String message) {
  final colors = context.colors;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Icon(LucideIcons.sparkles, size: 18, color: colors.accent),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
}
