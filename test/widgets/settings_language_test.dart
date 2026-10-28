import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sertech/app/l10n/locale_notifier.dart';
import 'package:sertech/app/l10n/locale_preferences.dart';
import 'package:sertech/app/providers.dart';
import 'package:sertech/app/theme/app_theme.dart';
import 'package:sertech/app/theme/theme_mode_notifier.dart';
import 'package:sertech/app/theme/theme_preferences.dart' as tp;
import 'package:sertech/features/settings/presentation/settings_screen.dart';
import 'package:sertech/l10n/app_localizations.dart';
import 'package:sertech/l10n/localization_config.dart';

class _FakeLocalePreferences extends LocalePreferences {
  _FakeLocalePreferences(this.locale);

  Locale locale;

  @override
  Future<Locale> getLocale() async => locale;

  @override
  Future<void> setLocale(Locale locale) async {
    this.locale = locale;
  }
}

class _FakeThemePreferences extends tp.ThemePreferences {
  @override
  Future<tp.ThemeMode> getThemeMode() async => tp.ThemeMode.light;

  @override
  Future<void> setThemeMode(tp.ThemeMode mode) async {}
}

Widget _buildApp(LocalePreferences localePreferences) {
  return ProviderScope(
    overrides: [
      localePreferencesProvider.overrideWithValue(localePreferences),
      themePreferencesProvider.overrideWithValue(_FakeThemePreferences()),
      dataModeProvider.overrideWith((ref) => DataMode.inMemory),
      supabaseConfiguredProvider.overrideWithValue(true),
      isOnlineProvider.overrideWith((ref) => Stream<bool>.value(true)),
    ],
    child: Consumer(
      builder: (context, ref, _) {
        final locale = ref.watch(localeProvider);
        return MaterialApp(
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: appLocalizationsDelegates,
          theme: AppTheme.lightTheme(),
          home: const SettingsScreen(),
        );
      },
    ),
  );
}

void main() {
  testWidgets('changing the language updates the UI and persists it', (
    tester,
  ) async {
    final preferences = _FakeLocalePreferences(const Locale('fr'));
    await tester.pumpWidget(_buildApp(preferences));
    await tester.pumpAndSettle();

    expect(find.text('Langue'), findsOneWidget);

    await tester.tap(find.text('Langue'));
    await tester.pumpAndSettle();

    expect(find.text('Anglais'), findsOneWidget);
    await tester.tap(find.text('Anglais'));
    await tester.pumpAndSettle();

    expect(preferences.locale, const Locale('en'));
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
  });

  testWidgets('demo mode hides the Supabase sign-out action', (tester) async {
    await tester.pumpWidget(
      _buildApp(_FakeLocalePreferences(const Locale('fr'))),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Mode local'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Mode local'), findsOneWidget);
    expect(find.text('Se déconnecter'), findsNothing);
  });
}
