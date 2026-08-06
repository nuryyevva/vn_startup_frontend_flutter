import 'package:flutter/material.dart';

import '../theme/motion.dart';

/// Wraps [child] with the app-wide tactile tap feedback: a barely-there
/// scale-down on press, released on lift/cancel. Used for cards and any
/// custom tappable surface that isn't already a Material button.
class PressableScale extends StatefulWidget {
  const PressableScale({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.onTap == null ? null : (_) => _setPressed(true),
      onTapUp: widget.onTap == null ? null : (_) => _setPressed(false),
      onTapCancel: widget.onTap == null ? null : () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? Motion.pressedScale : 1.0,
        duration: Motion.microDuration,
        curve: Motion.microCurve,
        child: widget.child,
      ),
    );
  }
}
