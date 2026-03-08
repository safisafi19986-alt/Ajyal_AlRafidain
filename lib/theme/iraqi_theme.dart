import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Iraqi heritage-inspired theme for Ajyal Al-Rafidain.
///
/// Color palette inspired by:
/// - Mesopotamian gold and terracotta
/// - Tigris & Euphrates river blues
/// - Iraqi flag colors
/// - Desert sand and palm green
class IraqiTheme {
  IraqiTheme._();

  // ── Primary Colors ──
  /// Deep Mesopotamian gold - primary brand color
  static const Color primaryGold = Color(0xFFD4A853);

  /// Rich terracotta - inspired by ancient Babylonian bricks
  static const Color terracotta = Color(0xFFBF6340);

  /// Deep indigo - inspired by Ishtar Gate tiles
  static const Color ishtarBlue = Color(0xFF1A3A5C);

  /// Tigris river teal
  static const Color tigrisTeal = Color(0xFF2E8B8B);

  // ── Secondary Colors ──
  /// Palm grove green
  static const Color palmGreen = Color(0xFF4A7C59);

  /// Desert sand
  static const Color desertSand = Color(0xFFF5E6CC);

  /// Iraqi flag red
  static const Color iraqiRed = Color(0xFFCE1126);

  /// Warm cream background
  static const Color creamBackground = Color(0xFFFAF6F0);

  /// Dark text color
  static const Color darkText = Color(0xFF2C1810);

  /// Light text color
  static const Color lightText = Color(0xFFF5F0E8);

  // ── Accent Colors ──
  /// Success green
  static const Color successGreen = Color(0xFF4CAF50);

  /// Warning amber
  static const Color warningAmber = Color(0xFFFFA726);

  /// Error red
  static const Color errorRed = Color(0xFFE53935);

  /// Info blue
  static const Color infoBlue = Color(0xFF42A5F5);

  // ── Gradients ──
  static const LinearGradient mesopotamianGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ishtarBlue, tigrisTeal],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFD4A853), Color(0xFFB8923A)],
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [terracotta, primaryGold],
  );

  /// Build the main app ThemeData with Iraqi heritage aesthetics.
  static ThemeData buildTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ishtarBlue,
        primary: ishtarBlue,
        secondary: primaryGold,
        tertiary: tigrisTeal,
        surface: creamBackground,
        error: errorRed,
        onPrimary: lightText,
        onSecondary: darkText,
        onSurface: darkText,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: creamBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: ishtarBlue,
        foregroundColor: lightText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.tajawal(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: lightText,
        ),
      ),
      textTheme: _buildTextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGold,
          foregroundColor: darkText,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.tajawal(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ishtarBlue,
          side: const BorderSide(color: ishtarBlue, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.tajawal(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0D5C5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0D5C5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ishtarBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed),
        ),
        labelStyle: GoogleFonts.tajawal(
          color: darkText.withAlpha(179),
        ),
        hintStyle: GoogleFonts.tajawal(
          color: darkText.withAlpha(128),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryGold,
        foregroundColor: darkText,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: ishtarBlue,
        unselectedItemColor: darkText.withAlpha(128),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: DividerThemeData(
        color: darkText.withAlpha(31),
        thickness: 1,
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.tajawal(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: darkText,
      ),
      displayMedium: GoogleFonts.tajawal(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: darkText,
      ),
      displaySmall: GoogleFonts.tajawal(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: darkText,
      ),
      headlineLarge: GoogleFonts.tajawal(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: darkText,
      ),
      headlineMedium: GoogleFonts.tajawal(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: darkText,
      ),
      headlineSmall: GoogleFonts.tajawal(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: darkText,
      ),
      titleLarge: GoogleFonts.tajawal(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: darkText,
      ),
      titleMedium: GoogleFonts.tajawal(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: darkText,
      ),
      titleSmall: GoogleFonts.tajawal(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: darkText,
      ),
      bodyLarge: GoogleFonts.tajawal(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: darkText,
      ),
      bodyMedium: GoogleFonts.tajawal(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: darkText,
      ),
      bodySmall: GoogleFonts.tajawal(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: darkText.withAlpha(179),
      ),
      labelLarge: GoogleFonts.tajawal(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: darkText,
      ),
      labelMedium: GoogleFonts.tajawal(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: darkText,
      ),
      labelSmall: GoogleFonts.tajawal(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: darkText.withAlpha(179),
      ),
    );
  }
}
