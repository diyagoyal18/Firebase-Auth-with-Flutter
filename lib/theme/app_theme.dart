import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  static const String _prefKey = 'dark_mode';
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_prefKey) ?? false;
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  static bool get isDark => themeMode.value == ThemeMode.dark;

  static Future<void> setDark(bool isDark) async {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, isDark);
  }

  static Future<void> toggle() => setDark(!isDark);
}