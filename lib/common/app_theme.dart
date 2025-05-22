import 'package:flutter/material.dart';

class AppTheme {
  static final Color primary = const Color(0xFF5DB075);
  static final Color secondary = const Color(0xFFF4A261);
  static final Color background = const Color(0xFFF9F9F9);
  static final Color textPrimary = const Color(0xFF222222);
  static final Color textSecondary = const Color(0xFF888888);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: textPrimary,
      elevation: 0,
      titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFF222222)),
    ),
  );
}
