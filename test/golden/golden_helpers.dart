import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:nocturne/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Wraps [child] with everything a screen/widget needs to render in a
/// golden test — the real `easy_localization` widget (translations load
/// from `assets/translations`, bundled for tests the same as any other
/// asset), the app's dark/light theme, and a [ProviderScope] with the
/// given [overrides] — and compares it against `goldenName`.
Future<void> pumpGolden(
  WidgetTester tester,
  String goldenName, {
  required Widget child,
  required List<Override> overrides,
  Brightness brightness = Brightness.dark,
  Size surfaceSize = const Size(400, 800),
}) async {
  // EasyLocalization.ensureInitialized() calls SharedPreferences.getInstance()
  // internally (to persist the saved locale) — without this mock, that
  // MethodChannel call has no platform implementation in a test
  // environment and hangs forever inside flutter_test's fake-async zone
  // instead of failing fast.
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();

  await tester.pumpWidgetBuilder(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: ProviderScope(
        overrides: overrides,
        child: Builder(
          builder: (context) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: brightness == Brightness.dark ? AppTheme.dark() : AppTheme.light(),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: child,
            );
          },
        ),
      ),
    ),
    // No wrapper: `child` above is already a complete MaterialApp — the
    // default wrapper would nest a second one (with its own default theme)
    // around it for no benefit.
    wrapper: (child) => child,
    surfaceSize: surfaceSize,
  );
  await tester.pumpAndSettle();
  await screenMatchesGolden(tester, goldenName);
}
