import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // --- Brand Palette ---
  static const Color primary = Color(0xFF8B5CF6);
  static const Color primaryDark = Color(0xFF6D28D9);
  static const Color primaryLight = Color(0xFFEDE9FE);
  static const Color accentCyan = Color(0xFF22D3EE);
  static const Color accentCyanDark = Color(0xFF0891B2);

  // --- Semantic colors ---
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = accentCyan;

  // --- LEGACY STATIC TOKENS (Fixed Light Theme for Company Apps) ---
  static const Color background = Color(0xFFF4F6FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color label = Color(0xFF0F172A);
  static const Color labelSecondary = Color(0xFF64748B);
  static const Color separator = Color(0xFFE2E8F0);

  // --- DARK THEME TOKENS (Used by Context-Aware Helpers) ---
  static const Color _darkBg = Color(0xFF0A0E17);
  static const Color _darkSurface = Color(0xFF131826);
  static const Color _darkSurfaceVar = Color(0xFF1E2638);
  static const Color _darkLabel = Color(0xFFFFFFFF);
  static const Color _darkLabelSec = Color(0xFF94A3B8);
  static const Color _darkSep = Color(0xFF1E293B);

  // --- Context-aware helpers (Use these for MicroFin side) ---
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color bg(BuildContext context) =>
      isDark(context) ? _darkBg : background;
  static Color card(BuildContext context) =>
      isDark(context) ? _darkSurface : surface;
  static Color cardVariant(BuildContext context) =>
      isDark(context) ? _darkSurfaceVar : surfaceVariant;
  static Color lbl(BuildContext context) =>
      isDark(context) ? _darkLabel : label;
  static Color lblSecondary(BuildContext context) =>
      isDark(context) ? _darkLabelSec : labelSecondary;
  static Color sep(BuildContext context) =>
      isDark(context) ? _darkSep : separator;

  // --- Shadows ---
  // Legacy Shadow (Static getter)
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 24,
          offset: const Offset(0, 8),
          spreadRadius: 0,
        ),
      ];

  // Dynamic Shadow (For theme-aware cards)
  static List<BoxShadow> shadow(BuildContext context) {
    if (isDark(context)) {
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ];
    }
    return cardShadow;
  }

  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: primary.withOpacity(0.35),
          blurRadius: 24,
          offset: const Offset(0, 8),
          spreadRadius: -4,
        ),
      ];

  // ─── DARK THEME DEFINITION ──────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Outfit',
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accentCyan,
        surface: _darkSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: _darkLabel,
        outline: _darkSep,
      ),
      scaffoldBackgroundColor: _darkBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: _darkLabel,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
      ),
      cardTheme: CardThemeData(
        color: _darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: _darkSep, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: -0.2,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurfaceVar,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        hintStyle: const TextStyle(color: _darkLabelSec),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _darkSurface,
        selectedItemColor: primary,
        unselectedItemColor: _darkLabelSec,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // ─── LIGHT THEME DEFINITION ─────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Outfit',
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: primaryDark,
        surface: surface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: label,
        outline: separator,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        shadowColor: Color(0x14000000),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        iconTheme: IconThemeData(color: primary),
        titleTextStyle: TextStyle(
          color: label,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: -0.2,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: separator),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: separator),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        hintStyle: const TextStyle(color: labelSecondary),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: primaryLight,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: primary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            );
          }
          return const TextStyle(
            color: labelSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primary, size: 22);
          }
          return const IconThemeData(color: labelSecondary, size: 22);
        }),
      ),
    );
  }
}
