import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../l10n/localization_config.dart';
import 'l10n/locale_notifier.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_mode_notifier.dart';
import 'theme/theme_preferences.dart' as tp;

class SertechApp extends ConsumerWidget {
  const SertechApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Sertech',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: appLocalizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: switch (themeMode) {
        tp.ThemeMode.light => ThemeMode.light,
        tp.ThemeMode.dark => ThemeMode.dark,
        tp.ThemeMode.system => ThemeMode.system,
      },
      routerConfig: router,
    );
  }
}
