import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences _prefs;
  late ValueNotifier<ThemeMode> _themeMode;

  ThemeController(this._prefs) {
    final savedTheme = _prefs.getString(_themeKey);
    _themeMode = ValueNotifier<ThemeMode>(
      savedTheme == 'dark'
          ? ThemeMode.dark
          : savedTheme == 'light'
              ? ThemeMode.light
              : ThemeMode.system,
    );
  }

  ValueNotifier<ThemeMode> get themeMode => _themeMode;

  bool get isDarkMode => _themeMode.value == ThemeMode.dark;

  Future<void> toggleTheme() async {
    final newMode =
        _themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _themeMode.value = newMode;
    await _prefs.setString(
        _themeKey, newMode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode.value = mode;
    await _prefs.setString(
      _themeKey,
      mode == ThemeMode.dark
          ? 'dark'
          : mode == ThemeMode.light
              ? 'light'
              : 'system',
    );
    notifyListeners();
  }
}
