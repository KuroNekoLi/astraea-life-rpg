import 'package:flutter/material.dart';

abstract final class AstraeaTheme {
  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF514788)),
    useMaterial3: true,
  );
}
