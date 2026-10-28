import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sertech/app/l10n/locale_notifier.dart';
import 'package:sertech/app/l10n/locale_preferences.dart';
import 'package:sertech/app/theme/theme_mode_notifier.dart';
import 'package:sertech/app/theme/theme_preferences.dart' as tp;

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
  _FakeThemePreferences(this.mode);

  tp.ThemeMode mode;

  @override
  Future<tp.ThemeMode> getThemeMode() async => mode;

  @override
  Future<void> setThemeMode(tp.ThemeMode mode) async {
    this.mode = mode;
  }
}

void main() {
  group('LocaleNotifier', () {
    test('loads the persisted locale', () async {
      final preferences = _FakeLocalePreferences(const Locale('en'));
      final notifier = LocaleNotifier(preferences);

      expect(notifier.state, const Locale('fr'));
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state, const Locale('en'));
      notifier.dispose();
    });

    test('setLocale updates the state and persists the choice', () async {
      final preferences = _FakeLocalePreferences(const Locale('fr'));
      final notifier = LocaleNotifier(preferences);
      await Future<void>.delayed(Duration.zero);

      await notifier.setLocale(const Locale('bm'));

      expect(notifier.state, const Locale('bm'));
      expect(preferences.locale, const Locale('bm'));
      notifier.dispose();
    });
  });

  group('ThemeModeNotifier', () {
    test('loads and persists the selected theme', () async {
      final preferences = _FakeThemePreferences(tp.ThemeMode.dark);
      final notifier = ThemeModeNotifier(preferences);

      expect(notifier.state, tp.ThemeMode.system);
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state, tp.ThemeMode.dark);

      await notifier.setThemeMode(tp.ThemeMode.light);

      expect(notifier.state, tp.ThemeMode.light);
      expect(preferences.mode, tp.ThemeMode.light);
      notifier.dispose();
    });
  });
}
