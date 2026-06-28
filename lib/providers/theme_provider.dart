import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('theme_mode') ?? 'dark';
    _themeMode = saved == 'system'
        ? ThemeMode.system
        : saved == 'light'
            ? ThemeMode.light
            : ThemeMode.dark;
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    final val = mode == ThemeMode.system
        ? 'system'
        : mode == ThemeMode.light
            ? 'light'
            : 'dark';
    await prefs.setString('theme_mode', val);
    notifyListeners();
  }

  String get currentLabel {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.system:
        return 'System';
      default:
        return 'Dark';
    }
  }
}