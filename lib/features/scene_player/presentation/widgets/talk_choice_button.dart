import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/scene_player_skin.dart';

/// The free-conversation option ("talk to …") among a scene's choices.
///
/// It has the size and shape of the other choice buttons, so the list stays
/// one column of answers, but is set apart by the story's `talk_*` tokens
/// (see [ScenePlayerSkin]): its own fill and outline, a soft glow that
/// breathes, and — with [TalkEffect.shimmer] — a highlight travelling along
/// the outline. It eases in a moment after the panel appears.
///
/// The motion comes in bursts, not forever: [introLaps] when the choices
/// appear, then one lap every [rest]. In between nothing is drawn, so a
/// choice screen the player sits on for minutes costs no frames (battery on
/// a phone; the Android emulator's software GPU died after a while of
/// non-stop frames). All motion stops while the button is disabled and when
/// the platform asks for reduced motion.
class TalkChoiceButton extends StatefulWidget {
  const TalkChoiceButton({super.key, required this.label, required this.onPressed});

  final String label;

  /// Null disables the button (another choice is being submitted).
  final VoidCallback? onPressed;

  /// One breath of the glow and one lap of the highlight.
  static const period = Duration(milliseconds: 3200);

  /// Laps right after the button appears, and the pause between the single
  /// laps that follow.
  static const introLaps = 2;
  static const rest = Duration(seconds: 6);

  /// The entrance, after the scripted choices are already on screen.
  static const introDelay = Duration(milliseconds: 150);
  static const introDuration = Duration(milliseconds: 500);

  @override
  State<TalkChoiceButton> createState() => _TalkChoiceButtonState();
}

class _TalkChoiceButtonState extends State<TalkChoiceButton> with TickerProviderStateMixin {
  late final AnimationController _loop = AnimationController(vsync: this, duration: TalkChoiceButton.period);
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: TalkChoiceButton.introDelay + TalkChoiceButton.introDuration,
  )..forward();

  // The delay is the start of the intro's own timeline: no timer to cancel.
  late final Animation<double> _introCurve = CurvedAnimation(
    parent: _intro,
    curve: Interval(
      TalkChoiceButton.introDelay.inMilliseconds /
          (TalkChoiceButton.introDelay + TalkChoiceButton.introDuration).inMilliseconds,
      1,
      curve: Curves.easeOutCubic,
    ),
  );

  // The speech bubble swells a little with each breath of the glow.
  late final Animation<double> _iconPulse = TweenSequence<double>([
    TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1.12).chain(CurveTween(curve: Curves.easeInOut)), weight: 1),
    TweenSequenceItem(tween: Tween<double>(begin: 1.12, end: 1).chain(CurveTween(curve: Curves.easeInOut)), weight: 1),
  ]).animate(_loop);

  // The glow's breath: from its resting strength up to full and back, so a
  // lap starts and ends exactly where the resting button is.
  late final Animation<double> _glowStrength = TweenSequence<double>([
    TweenSequenceItem(tween: Tween<double>(begin: 0.6, end: 1).chain(CurveTween(curve: Curves.easeInOut)), weight: 1),
    TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0.6).chain(CurveTween(curve: Curves.easeInOut)), weight: 1),
  ]).animate(_loop);

  Timer? _restTimer;
  bool _animating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncLoop();
  }

  @override
  void didUpdateWidget(TalkChoiceButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncLoop();
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    _loop.dispose();
    _intro.dispose();
    super.dispose();
  }

  bool get _reducedMotion => MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  void _syncLoop() {
    final animate =
        widget.onPressed != null && ScenePlayerSkin.of(context).talkEffect != TalkEffect.none && !_reducedMotion;
    if (animate == _animating) return;
    _animating = animate;
    if (animate) {
      _burst(TalkChoiceButton.introLaps);
    } else {
      _restTimer?.cancel();
      _loop
        ..stop()
        ..value = 0;
    }
  }

  /// Runs [laps] laps, then rests and comes back for one more, for as long
  /// as the button should animate.
  void _burst(int laps) {
    _restTimer?.cancel();
    _loop.value = 0;
    _loop.repeat(count: laps).whenCompleteOrCancel(() {
      if (!mounted || !_animating) return;
      _loop.value = 0;
      _restTimer = Timer(TalkChoiceButton.rest, () {
        if (mounted && _animating) _burst(1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final skin = ScenePlayerSkin.of(context);
    final enabled = widget.onPressed != null;
    final textStyle = skin
        .bodyStyle(Theme.of(context).textTheme.labelLarge)
        ?.copyWith(color: skin.effectiveTalkTextColor, fontWeight: FontWeight.w600);

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RepaintBoundary(
            child: ScaleTransition(
              scale: _iconPulse,
              child: Icon(LucideIcons.messageCircle, size: 17, color: skin.effectiveTalkBorderColor),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(widget.label, textAlign: TextAlign.center, style: textStyle),
          ),
        ],
      ),
    );

    // Nothing with a blur may sit under an opacity layer: Impeller can't
    // fold opacity into blurred contents (it logs a validation error every
    // frame, and the Android emulator's GPU translation dies on it). So the
    // glow gets its fade and breath through its own colour, and only the
    // blur-free parts go under [Opacity].
    final radius = _radius(skin.choiceRadius);
    final glow = AnimatedBuilder(
      animation: Listenable.merge([_loop, _introCurve]),
      builder: (context, _) {
        final breath = _glowStrength.value;
        final color = skin.effectiveTalkGlowColor;
        return DecoratedBox(
          // A plain rounded rect: Impeller draws its shadow analytically, no
          // blur pass, so changing the colour every frame stays cheap.
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: color.a * breath * _introCurve.value),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      },
    );

    final face = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        color: skin.talkGradientTo == null ? skin.effectiveTalkColor : null,
        gradient: skin.talkGradientTo == null
            ? null
            : LinearGradient(colors: [skin.effectiveTalkColor, skin.talkGradientTo!]),
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: radius,
          splashColor: skin.effectiveTalkGlowColor,
          highlightColor: skin.effectiveTalkBorderColor.withValues(alpha: 0.08),
          child: content,
        ),
      ),
    );

    final outline = IgnorePointer(
      // Repainted every frame on its own layer, without touching the panel
      // (and its frosted backdrop) or the label.
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _OutlinePainter(
            radius: radius,
            color: skin.effectiveTalkBorderColor,
            lap: skin.talkEffect == TalkEffect.shimmer && enabled ? _loop : null,
            fade: _introCurve,
            dim: enabled ? 1 : 0.5,
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _introCurve,
      builder: (context, child) =>
          Transform.translate(offset: Offset(0, 8 * (1 - _introCurve.value)), child: child),
      child: SizedBox(
        width: double.infinity,
        child: Semantics(
          button: true,
          enabled: enabled,
          child: Stack(
            // The glow spills past the button's bounds.
            clipBehavior: Clip.none,
            children: [
              if (enabled) Positioned.fill(child: glow),
              FadeTransition(opacity: _faceOpacity(enabled), child: face),
              Positioned.fill(child: outline),
            ],
          ),
        ),
      ),
    );
  }

  /// The face (fill and label) fades in with the intro, and to half when the
  /// button is disabled.
  Animation<double> _faceOpacity(bool enabled) =>
      enabled ? _introCurve : _introCurve.drive(Tween<double>(begin: 0, end: 0.5));

  /// Same corners as the other choices (see SkinButton): the app's 14 when
  /// the story sets none; a radius past half the height makes a pill.
  static BorderRadius _radius(double? radius) => BorderRadius.circular(radius ?? 14);
}

/// The outline, plus with [lap] a bright streak sweeping around it once per
/// period. It repaints itself from its animations (no widget rebuilds), and
/// fades by its own colours rather than under an opacity layer. Only plain
/// strokes: no blur filters, which are costly to redo every frame.
class _OutlinePainter extends CustomPainter {
  _OutlinePainter({
    required this.radius,
    required this.color,
    required this.lap,
    required this.fade,
    required this.dim,
  }) : super(repaint: Listenable.merge([lap, fade]));

  final BorderRadius radius;
  final Color color;
  final Animation<double>? lap;
  final Animation<double> fade;
  final double dim;

  @override
  void paint(Canvas canvas, Size size) {
    final opacity = fade.value * dim;
    if (opacity <= 0) return;
    final rect = Offset.zero & size;
    final rrect = radius.toRRect(rect).deflate(0.6);
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = color.withValues(alpha: color.a * 0.7 * opacity),
    );
    final lap = this.lap;
    if (lap == null) return;
    // The streak fades in and out over each lap, so a resting button
    // (lap at 0) shows none and a lap never starts or ends with a jump.
    final presence = math.sin(math.pi * lap.value);
    if (presence <= 0.01) return;
    final streak = Color.lerp(color, Colors.white, 0.7)!;
    Shader sweep(double alpha) => SweepGradient(
      colors: [
        streak.withValues(alpha: 0),
        streak.withValues(alpha: alpha * opacity * presence),
        streak.withValues(alpha: 0),
      ],
      stops: const [0.0, 0.1, 0.2],
      transform: GradientRotation(2 * math.pi * lap.value),
    ).createShader(rect);
    // A wide faint stroke under a crisp one stands in for a soft halo.
    canvas
      ..drawRRect(
        rrect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..shader = sweep(0.35),
      )
      ..drawRRect(
        rrect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..shader = sweep(1),
      );
  }

  @override
  bool shouldRepaint(_OutlinePainter old) =>
      old.lap != lap || old.fade != fade || old.dim != dim || old.color != color || old.radius != radius;
}
