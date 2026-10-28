import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'locale_preferences.dart';

final localePreferencesProvider = Provider<LocalePreferences>((ref) {
  return LocalePreferences();
});

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(localePreferencesProvider);
  return LocaleNotifier(prefs);
});

class LocaleNotifier extends StateNotifier<Locale> {
  final LocalePreferences _preferences;

  LocaleNotifier(this._preferences) : super(const Locale('fr')) {
    _load();
  }

  Future<void> _load() async {
    final locale = await _preferences.getLocale();
    if (!mounted) return;
    state = locale;
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _preferences.setLocale(locale);
  }
}
