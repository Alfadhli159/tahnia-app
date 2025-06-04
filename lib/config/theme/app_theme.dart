import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Tajawal',
    primaryColor: const Color(0xFF2196F3), // أزرق
    scaffoldBackgroundColor: Colors.white, // خلفية بيضاء
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2196F3), // أزرق
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white, // خلفية بيضاء
      selectedItemColor: Color(0xFF2196F3), // أزرق
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      unselectedLabelStyle: TextStyle(fontSize: 11),
      type: BottomNavigationBarType.fixed,
      elevation: 0, // إزالة الظل
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2196F3), // أزرق
        foregroundColor: Colors.white, // نص أبيض
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: false, // إزالة الخلفية
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2196F3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      hintStyle: const TextStyle(color: Colors.grey),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF2196F3), // أزرق
      foregroundColor: Colors.white,
    ),
    cardTheme: CardTheme(
      color: Colors.white, // خلفية بيضاء للكروت
      elevation: 0, // إزالة الظل
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.grey, width: 0.5), // حدود رفيعة
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF2196F3), // أزرق
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF222222)),
      headlineMedium: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF222222)),
      titleMedium: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF222222)),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF222222)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF222222)),
      labelLarge: TextStyle(fontSize: 12, color: Colors.grey),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
      secondary: const Color(0xFF1976D2),
      surface: Colors.white, // خلفية بيضاء
    ),
    useMaterial3: true,
  );
}
