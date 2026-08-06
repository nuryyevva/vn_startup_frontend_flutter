import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';
import '../theme/motion.dart';

/// Bottom-nav shell for the three tab routes (Stories/Shop/Profile).
/// Wraps [navigationShell] (a `StatefulShellRoute.indexedStack`, so each
/// branch keeps its own state/scroll position) in a fade+slide that plays
/// only on the *opacity/position* of that already-alive widget — never
/// rebuilding or disposing it — so the crossfade the design spec asks for
/// doesn't cost branch state the way swapping widget keys would.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Motion.microDuration,
    value: 1,
  );
  late final Animation<double> _fade = CurvedAnimation(parent: _controller, curve: Motion.microCurve);
  late final Animation<Offset> _slide = Tween(
    begin: const Offset(0, 0.02),
    end: Offset.zero,
  ).animate(_fade);

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.navigationShell.currentIndex != widget.navigationShell.currentIndex) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    widget.navigationShell.goBranch(index, initialLocation: index == widget.navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(position: _slide, child: widget.navigationShell),
      ),
      bottomNavigationBar: _AppBottomNavBar(currentIndex: widget.navigationShell.currentIndex, onTap: _onTap),
    );
  }
}

class _AppBottomNavBar extends StatelessWidget {
  const _AppBottomNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _icons = [LucideIcons.libraryBig, LucideIcons.gem, LucideIcons.user];
  static const _labelKeys = ['nav.stories', 'nav.shop', 'nav.profile'];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.background, border: Border(top: BorderSide(color: colors.border))),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Stack(
            children: [
              AnimatedAlign(
                duration: Motion.microDuration,
                curve: Motion.microCurve,
                alignment: Alignment(-1 + (2 * currentIndex) / (_icons.length - 1), -1),
                child: FractionallySizedBox(
                  widthFactor: 1 / _icons.length,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 28),
                      decoration: BoxDecoration(color: colors.accent, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < _icons.length; i++)
                    Expanded(
                      child: _NavItem(
                        icon: _icons[i],
                        label: _labelKeys[i].tr(),
                        selected: currentIndex == i,
                        onTap: () => onTap(i),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap});

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final color = selected ? colors.accent : colors.textMuted;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: selected ? 1.05 : 1.0,
            duration: Motion.microDuration,
            curve: Motion.microCurve,
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: Motion.microDuration,
            style: (textTheme.labelSmall ?? const TextStyle()).copyWith(
              color: color,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}
