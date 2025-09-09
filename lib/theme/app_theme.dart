import 'package:flutter/material.dart';

class AppTheme {
  // Light theme colors (matching CSS variables)
  static const Color _lightBackground = Color(0xFFFFFFFF);
  static const Color _lightForeground = Color(0xFF030213);
  static const Color _lightPrimary = Color(0xFF030213);
  static const Color _lightPrimaryForeground = Color(0xFFFFFFFF);
  static const Color _lightSecondary = Color(0xFFF3F3F5);
  static const Color _lightSecondaryForeground = Color(0xFF030213);
  static const Color _lightMuted = Color(0xFFECECF0);
  static const Color _lightMutedForeground = Color(0xFF717182);
  static const Color _lightAccent = Color(0xFFE9EBEF);
  static const Color _lightAccentForeground = Color(0xFF030213);
  static const Color _lightDestructive = Color(0xFFD4183D);
  static const Color _lightDestructiveForeground = Color(0xFFFFFFFF);
  static const Color _lightBorder = Color(0x1A000000);
  static const Color _lightInputBackground = Color(0xFFF3F3F5);
  static const Color _lightCard = Color(0xFFFFFFFF);
  static const Color _lightCardForeground = Color(0xFF030213);

  // Dark theme colors
  static const Color _darkBackground = Color(0xFF030213);
  static const Color _darkForeground = Color(0xFFFFFFFF);
  static const Color _darkPrimary = Color(0xFFFFFFFF);
  static const Color _darkPrimaryForeground = Color(0xFF202020);
  static const Color _darkSecondary = Color(0xFF444444);
  static const Color _darkSecondaryForeground = Color(0xFFFFFFFF);
  static const Color _darkMuted = Color(0xFF444444);
  static const Color _darkMutedForeground = Color(0xFFB5B5B5);
  static const Color _darkAccent = Color(0xFF444444);
  static const Color _darkAccentForeground = Color(0xFFFFFFFF);
  static const Color _darkDestructive = Color(0xFFFF6B6B);
  static const Color _darkDestructiveForeground = Color(0xFF2D1B1B);
  static const Color _darkBorder = Color(0xFF444444);
  static const Color _darkInputBackground = Color(0xFF444444);
  static const Color _darkCard = Color(0xFF030213);
  static const Color _darkCardForeground = Color(0xFFFFFFFF);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _lightPrimary,
        onPrimary: _lightPrimaryForeground,
        secondary: _lightSecondary,
        onSecondary: _lightSecondaryForeground,
        surface: _lightBackground,
        onSurface: _lightForeground,
        error: _lightDestructive,
        onError: _lightDestructiveForeground,
        outline: _lightBorder,
      ),
      scaffoldBackgroundColor: _lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightBackground,
        foregroundColor: _lightForeground,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimary,
          foregroundColor: _lightPrimaryForeground,
          minimumSize: const Size(88, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _lightForeground,
          minimumSize: const Size(88, 44),
          side: const BorderSide(color: _lightBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightPrimary,
          minimumSize: const Size(88, 44),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightInputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      cardTheme: CardThemeData(
        color: _lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: _lightBorder),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _lightBackground,
        selectedItemColor: _lightPrimary,
        unselectedItemColor: _lightMutedForeground,
        type: BottomNavigationBarType.fixed,
      ),
      dividerColor: _lightBorder,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w500,
          color: _lightForeground,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          color: _lightForeground,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: _lightForeground,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: _lightForeground,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _lightForeground,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _lightForeground,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _lightForeground,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _lightForeground,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _lightMutedForeground,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _lightForeground,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _lightForeground,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: _lightMutedForeground,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimary,
        onPrimary: _darkPrimaryForeground,
        secondary: _darkSecondary,
        onSecondary: _darkSecondaryForeground,
        surface: _darkBackground,
        onSurface: _darkForeground,
        error: _darkDestructive,
        onError: _darkDestructiveForeground,
        outline: _darkBorder,
      ),
      scaffoldBackgroundColor: _darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBackground,
        foregroundColor: _darkForeground,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimary,
          foregroundColor: _darkPrimaryForeground,
          minimumSize: const Size(88, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkForeground,
          minimumSize: const Size(88, 44),
          side: const BorderSide(color: _darkBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkPrimary,
          minimumSize: const Size(88, 44),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkInputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      cardTheme: CardThemeData(
        color: _darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: _darkBorder),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _darkBackground,
        selectedItemColor: _darkPrimary,
        unselectedItemColor: _darkMutedForeground,
        type: BottomNavigationBarType.fixed,
      ),
      dividerColor: _darkBorder,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w500,
          color: _darkForeground,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          color: _darkForeground,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: _darkForeground,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: _darkForeground,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _darkForeground,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _darkForeground,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _darkForeground,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _darkForeground,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _darkMutedForeground,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _darkForeground,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _darkForeground,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: _darkMutedForeground,
        ),
      ),
    );
  }
}