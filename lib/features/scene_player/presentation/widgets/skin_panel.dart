import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/scene_player_skin.dart';

/// The surface every text element of the scene player sits on — dialogue,
/// choices, the ending — drawn per the story's [ScenePlayerSkin]. Widgets
/// put their content inside and never build their own background, so a
/// skin restyles all of them at once.
class SkinPanel extends StatelessWidget {
  const SkinPanel({super.key, required this.child, this.padding = const EdgeInsets.all(20)});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final skin = ScenePlayerSkin.of(context);
    final floating = skin.layout == SkinLayout.floating;
    final radius = floating
        ? BorderRadius.circular(skin.panelRadius)
        : BorderRadius.vertical(top: Radius.circular(skin.panelRadius));
    final side = BorderSide(color: skin.panelBorderColor, width: skin.panelBorderWidth);
    final from = skin.panelColor.withValues(alpha: skin.panelOpacity);
    final to = skin.panelGradientTo?.withValues(alpha: skin.panelOpacity);

    Widget panel = DecoratedBox(
      decoration: BoxDecoration(
        color: to == null ? from : null,
        gradient: to == null
            ? null
            : LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [from, to]),
        borderRadius: radius,
        // A sheet runs off the screen edges, so only its top edge is drawn.
        border: floating ? Border.fromBorderSide(side) : Border(top: side),
      ),
      child: Padding(padding: padding, child: child),
    );

    if (skin.panelBlur > 0) {
      panel = ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: skin.panelBlur, sigmaY: skin.panelBlur),
          child: panel,
        ),
      );
    }

    if (skin.panelGlowColor != null) {
      panel = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [BoxShadow(color: skin.panelGlowColor!, blurRadius: 24, spreadRadius: 1)],
        ),
        child: panel,
      );
    }

    return Padding(
      padding: floating ? const EdgeInsets.fromLTRB(12, 0, 12, 12) : EdgeInsets.zero,
      child: SizedBox(width: double.infinity, child: panel),
    );
  }
}
