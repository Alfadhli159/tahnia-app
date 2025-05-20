import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Cairo',
    primaryColor: Color(0xFF12947f),
    scaffoldBackgroundColor: Color(0xFFFFFBDE), // بيج فاتح
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFF12947f), // أخضر مزرق
      primary: Color(0xFF12947f),
      secondary: Color(0xFFE5C97B), // ذهبي
      background: Color(0xFFFFFBDE), // بيج
      onPrimary: Colors.white,
      onSecondary: Colors.black,
    ),
    textTheme: GoogleFonts.cairoTextTheme(),
    useMaterial3: true,
  );
}
