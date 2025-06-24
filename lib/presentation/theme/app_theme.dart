import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.amber,
      scaffoldBackgroundColor: const Color(0xFFFFF8E1), // 연한 노란색 배경
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFFFB300), // 진한 노란색
        secondary: Color(0xFFFFC107),
        surface: Colors.white,
        onSurface: Color(0xFF333333),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFB300),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor: const Color(0xFF1A2F3A), // 어두운 청록색 배경
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF26A69A), // 청록색
        secondary: Color(0xFF80CBC4),
        surface: Color(0xFF263238),
        onSurface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A2F3A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
} 