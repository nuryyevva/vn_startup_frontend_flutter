import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/providers/theme_mode_provider.dart';

class LoveCityApp extends ConsumerWidget {
  const LoveCityApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final appName = ref.watch(appConfigProvider).appName;

    return MaterialApp.router(
      title: appName,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      themeMode: themeMode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        // AnimatedTheme crossfades whatever theme MaterialApp already
        // resolved (respecting system/dark/light) so a toggle never
        // "jump-cuts" — see design spec §3.4.
        return Builder(
          builder: (context) {
            return AnimatedTheme(
              data: Theme.of(context),
              duration: const Duration(milliseconds: 350),
              child: child ?? const SizedBox(),
            );
          },
        );
      },
    );
  }
}
