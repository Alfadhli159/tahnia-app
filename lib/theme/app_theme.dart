import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF03A9F4);
  static const Color accentColor = Color(0xFF00BCD4);
  static const Color errorColor = Color(0xFFE57373);
  static const Color successColor = Color(0xFF81C784);
  static const Color warningColor = Color(0xFFFFB74D);
  static const Color infoColor = Color(0xFF64B5F6);

  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  static const Color dividerColor = Color(0xFFE0E0E0);

  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color textHintColor = Color(0xFFBDBDBD);

  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  static const double buttonElevation = 2.0;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: CardTheme(
        color: cardColor,
        elevation: cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: buttonElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[200],
        selectedColor: primaryColor.withOpacity(0.2),
        labelStyle: const TextStyle(color: textPrimaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textPrimaryColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textSecondaryColor,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
      ),
      iconTheme: const IconThemeData(
        color: textSecondaryColor,
        size: 24,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: buttonElevation,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimaryColor,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: cardElevation,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(borderRadius),
          ),
        ),
        elevation: cardElevation,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: const Color(0xFF1E1E1E),
        background: const Color(0xFF121212),
        error: errorColor,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardTheme: CardTheme(
        color: const Color(0xFF1E1E1E),
        elevation: cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: buttonElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Color(0xFF3C3C3C)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Color(0xFF3C3C3C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2C2C2C),
        selectedColor: primaryColor.withOpacity(0.2),
        labelStyle: const TextStyle(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF3C3C3C),
        thickness: 1,
        space: 1,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFFB0B0B0),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFFB0B0B0),
        size: 24,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: buttonElevation,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: primaryColor,
        unselectedItemColor: Color(0xFFB0B0B0),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF2C2C2C),
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: cardElevation,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(borderRadius),
          ),
        ),
        elevation: cardElevation,
      ),
    );
  }
} 