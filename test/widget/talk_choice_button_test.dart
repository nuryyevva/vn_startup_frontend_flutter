import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nocturne/core/theme/app_colors.dart';
import 'package:nocturne/core/theme/app_theme.dart';
import 'package:nocturne/features/scene_player/presentation/theme/scene_player_skin.dart';
import 'package:nocturne/features/scene_player/presentation/widgets/talk_choice_button.dart';

Widget _host(Widget child, {Map<String, dynamic>? theme, bool reducedMotion = false}) {
  final base = AppTheme.dark();
  final skin = ScenePlayerSkin.resolve(base.extension<AppColors>()!, theme);
  return MediaQuery(
    data: MediaQueryData(disableAnimations: reducedMotion),
    child: MaterialApp(
      theme: base.copyWith(extensions: [...base.extensions.values, skin]),
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

double _opacity(WidgetTester tester) => tester
    .widget<FadeTransition>(find.descendant(of: find.byType(TalkChoiceButton), matching: find.byType(FadeTransition)))
    .opacity
    .value;

void main() {
  testWidgets('eases in, animates in bursts and rests in between', (tester) async {
    var taps = 0;
    await tester.pumpWidget(_host(TalkChoiceButton(label: 'Поговорить с Ноем', onPressed: () => taps++)));

    expect(_opacity(tester), 0, reason: 'still waiting for its entrance');
    await tester.pump(TalkChoiceButton.introDelay + TalkChoiceButton.introDuration);
    expect(_opacity(tester), 1);

    // A burst of laps when it appears…
    await tester.pump(TalkChoiceButton.period ~/ 3);
    expect(tester.hasRunningAnimations, isTrue);

    // …then it rests without drawing a single frame…
    await tester.pump(TalkChoiceButton.period * TalkChoiceButton.introLaps);
    expect(tester.hasRunningAnimations, isFalse);
    expect(tester.binding.hasScheduledFrame, isFalse);

    // …and comes back for one lap after the pause.
    await tester.pump(TalkChoiceButton.rest);
    await tester.pump(const Duration(milliseconds: 16));
    expect(tester.hasRunningAnimations, isTrue);
    await tester.pump(TalkChoiceButton.period);
    expect(tester.hasRunningAnimations, isFalse);

    await tester.tap(find.text('Поговорить с Ноем'));
    expect(taps, 1);
  });

  testWidgets('disabled: dimmed, inert and still', (tester) async {
    await tester.pumpWidget(_host(const TalkChoiceButton(label: 'Talk', onPressed: null)));
    await tester.pumpAndSettle();

    expect(_opacity(tester), 0.5);
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('no motion with talk_effect none or when the platform asks for reduced motion', (tester) async {
    await tester.pumpWidget(_host(TalkChoiceButton(label: 'Talk', onPressed: () {}), theme: {'talk_effect': 'none'}));
    await tester.pumpAndSettle();
    expect(tester.hasRunningAnimations, isFalse);

    await tester.pumpWidget(_host(TalkChoiceButton(label: 'Talk', onPressed: () {}), reducedMotion: true));
    await tester.pumpAndSettle();
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('re-enabling restarts the loop', (tester) async {
    await tester.pumpWidget(_host(const TalkChoiceButton(label: 'Talk', onPressed: null)));
    await tester.pumpAndSettle();
    expect(tester.hasRunningAnimations, isFalse);

    await tester.pumpWidget(_host(TalkChoiceButton(label: 'Talk', onPressed: () {})));
    await tester.pump(const Duration(milliseconds: 16));
    expect(tester.hasRunningAnimations, isTrue);
  });

  testWidgets('no opacity layer ever covers the blurred glow', (tester) async {
    // Impeller can't fold opacity into blurred contents; on the Android
    // emulator that error every frame took the whole emulator down.
    await tester.pumpWidget(_host(TalkChoiceButton(label: 'Talk', onPressed: () {})));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      final shadowed = find.byWidgetPredicate(
        (w) => w is DecoratedBox && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).boxShadow != null,
      );
      expect(shadowed, findsOneWidget);
      final fades = find.ancestor(of: shadowed, matching: find.byWidgetPredicate((w) => w is Opacity || w is FadeTransition));
      expect(
        fades.evaluate().where((e) => e.findAncestorWidgetOfExactType<TalkChoiceButton>() != null),
        isEmpty,
      );
    }
  });
}
