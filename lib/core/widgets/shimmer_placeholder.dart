import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A self-animating shimmer skeleton for loading states (story/bundle
/// cards) built from a plain [AnimationController] + [ShaderMask] — no
/// extra package needed for one effect.
class ShimmerPlaceholder extends StatefulWidget {
  const ShimmerPlaceholder({super.key, this.borderRadius = BorderRadius.zero});

  final BorderRadius borderRadius;

  @override
  State<ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<ShimmerPlaceholder> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              final t = _controller.value;
              return LinearGradient(
                colors: [colors.surfaceElevated, colors.border, colors.surfaceElevated],
                stops: const [0.0, 0.5, 1.0],
                begin: Alignment(-1 - t * 2, 0),
                end: Alignment(1 - t * 2, 0),
              ).createShader(bounds);
            },
            child: Container(color: colors.surfaceElevated),
          );
        },
      ),
    );
  }
}
