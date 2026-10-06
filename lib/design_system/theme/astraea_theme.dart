import 'package:flutter/material.dart';

abstract final class AstraeaColors {
  static const night = Color(0xFF071426);
  static const deepBlue = Color(0xFF102647);
  static const panel = Color(0xFF142B4D);
  static const panelRaised = Color(0xFF1C385F);
  static const starlight = Color(0xFFB9DFFF);
  static const gold = Color(0xFFF2C99A);
  static const pale = Color(0xFFF5F2EE);
  static const muted = Color(0xFFAAB8CB);
}

abstract final class AstraeaTheme {
  static ThemeData get light => ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AstraeaColors.starlight,
      onPrimary: AstraeaColors.night,
      secondary: AstraeaColors.gold,
      onSecondary: AstraeaColors.night,
      tertiary: Color(0xFFB9AAFF),
      surface: AstraeaColors.panel,
      onSurface: AstraeaColors.pale,
      error: Color(0xFFFF8A92),
      onError: AstraeaColors.night,
    ),
    scaffoldBackgroundColor: AstraeaColors.night,
    cardColor: AstraeaColors.panel,
    appBarTheme: const AppBarTheme(
      backgroundColor: AstraeaColors.night,
      foregroundColor: AstraeaColors.pale,
      elevation: 0,
      centerTitle: false,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF091A30),
      indicatorColor: AstraeaColors.panelRaised,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final color = states.contains(WidgetState.selected)
            ? AstraeaColors.pale
            : AstraeaColors.muted;
        return TextStyle(fontSize: 11, color: color);
      }),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AstraeaColors.starlight,
        foregroundColor: AstraeaColors.night,
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AstraeaColors.pale,
        side: const BorderSide(color: Color(0xFF496385)),
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    cardTheme: CardThemeData(
      color: AstraeaColors.panel,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0x334E6D91)),
      ),
      margin: EdgeInsets.zero,
    ),
    useMaterial3: true,
  );
}
