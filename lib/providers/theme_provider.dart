
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) return;

    _themeMode = mode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.name);

    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeName = prefs.getString('theme_mode') ?? 'system';

    _themeMode = ThemeMode.values.firstWhere(
          (e) => e.name == savedThemeName,
      orElse: () => ThemeMode.system,
    );

    notifyListeners();
  }

  ThemeData getThemeData(Brightness brightness) {
    final Color seedColor = brightness == Brightness.light
        ? const Color(0xffff5722)
        : const Color(0xffff8a65);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(useMaterial3: true, colorScheme: colorScheme);
  }
}