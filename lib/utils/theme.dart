import 'package:flutter/material.dart';

class AppTheme {
  // الثيم الفاتح الجذاب (Light Theme)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF0F5132), // زيتي محاسبي فاخر
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0F5132),
        primary: const Color(0xFF0F5132),
        secondary: const Color(0xFF198754),
        error: const Color(0xFFDC3545), // أحمر للمبالغ المستحقة والديون
        surface: const Color(0xFFF8F9FA),
      ),
      scaffoldBackgroundColor: const Color(0xFFF4F6F8),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F5132),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // الثيم الداكن المريح للعين (Dark Theme)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF198754),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF198754),
        secondary: Color(0xFF20C997),
        error: Color(0xFFE35D6A),
        surface: Color(0xFF212529),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF2D3238),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
