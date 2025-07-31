import 'package:flutter/material.dart';

class AppTheme {
  static final Color primary = const Color(0xFF5DB075);
  static final Color secondary = const Color(0xFFF4A261);
  static final Color background = const Color(0xFFF9F9F9);
  static final Color textPrimary = const Color(0xFF222222);
  static final Color textSecondary = const Color(0xFF888888);
  static final Color cardColor = Colors.grey.shade100;
  static final Color errorColor = Colors.redAccent;
  static final Color primaryDark = Colors.black12;//Colors.green.shade700;
  static final Color primaryLight = Colors.green.shade100;

  static final Color calorieProgress = Colors.green.shade500;
  static final Color proteinProgress = Colors.amber;
  static final Color fatProgress = Colors.deepPurple;
  static final Color carbProgress = Colors.cyan;
  static final Color progressBarBackground = Colors.grey.shade300;

  static const double spacing = 16.0;

  static const TextStyle pageTitle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
  static const TextStyle sectionTitle =
      TextStyle(fontWeight: FontWeight.bold);

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
      titleMedium: TextStyle(color: Colors.black),
      titleLarge: TextStyle(fontWeight: FontWeight.bold),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: primaryDark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryDark,
      foregroundColor: cardColor,
      elevation: 0,
      titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryDark,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFF222222)),
    ),
  );
}

