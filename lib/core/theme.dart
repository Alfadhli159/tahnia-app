import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.teal,
    scaffoldBackgroundColor: Color(0xFFFAF0E6),
    colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF2E8B57)),
    fontFamily: 'Cairo',
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}