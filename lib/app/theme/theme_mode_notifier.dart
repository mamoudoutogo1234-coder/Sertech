import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme_preferences.dart' as tp;

final themePreferencesProvider = Provider<tp.ThemePreferences>((ref) {
  return tp.ThemePreferences();
});

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, tp.ThemeMode>((ref) {
      final prefs = ref.watch(themePreferencesProvider);
      return ThemeModeNotifier(prefs);
    });

class ThemeModeNotifier extends StateNotifier<tp.ThemeMode> {
  final tp.ThemePreferences _preferences;

  ThemeModeNotifier(this._preferences) : super(tp.ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final mode = await _preferences.getThemeMode();
    state = mode;
  }

  Future<void> setThemeMode(tp.ThemeMode mode) async {
    state = mode;
    await _preferences.setThemeMode(mode);
  }
}
