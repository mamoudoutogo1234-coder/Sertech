import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalePreferences {
  static const String _key = 'locale';

  Future<Locale> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    if (value == 'en') return const Locale('en');
    if (value == 'bm') return const Locale('bm');
    return const Locale('fr');
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
  }
}
