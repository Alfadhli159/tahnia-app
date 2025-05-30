import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // الألوان الأساسية
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color accentColor = Color(0xFFFF5722);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFB00020);
  
  // ألوان النص
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color textOnPrimaryColor = Color(0xFFFFFFFF);
  
  // ألوان الوضع الداكن
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkSurfaceColor = Color(0xFF1E1E1E);
  static const Color darkTextPrimaryColor = Color(0xFFFFFFFF);
  static const Color darkTextSecondaryColor = Color(0xFFB3B3B3);

  // الثيم الفاتح
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // نظام الألوان
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
        onPrimary: textOnPrimaryColor,
        onSecondary: textPrimaryColor,
        onSurface: textPrimaryColor,
        onBackground: textPrimaryColor,
        onError: textOnPrimaryColor,
      ),
      
      // الخط
      textTheme: _buildTextTheme(false),
      
      // شريط التطبيق
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textOnPrimaryColor,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textOnPrimaryColor,
          fontFamily: 'Cairo',
        ),
      ),
      
      // الأزرار
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textOnPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      
      // البطاقات
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // حقول الإدخال
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: const TextStyle(
          color: textSecondaryColor,
          fontFamily: 'Cairo',
        ),
        hintStyle: const TextStyle(
          color: textSecondaryColor,
          fontFamily: 'Cairo',
        ),
      ),
      
      // شريط التنقل السفلي
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Cairo',
        ),
      ),
      
      // الحوارات
      dialogTheme: DialogTheme(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
          fontFamily: 'Cairo',
        ),
        contentTextStyle: const TextStyle(
          fontSize: 16,
          color: textPrimaryColor,
          fontFamily: 'Cairo',
        ),
      ),
      
      // القوائم
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
          fontFamily: 'Cairo',
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 14,
          color: textSecondaryColor,
          fontFamily: 'Cairo',
        ),
      ),
      
      // الفواصل
      dividerTheme: const DividerThemeData(
        color: Colors.grey,
        thickness: 1,
        space: 1,
      ),
      
      // الأيقونات
      iconTheme: const IconThemeData(
        color: textSecondaryColor,
        size: 24,
      ),
      
      // التبديل
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor.withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),
    );
  }

  // الثيم الداكن
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // نظام الألوان
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: darkSurfaceColor,
        background: darkBackgroundColor,
        error: errorColor,
        onPrimary: textOnPrimaryColor,
        onSecondary: darkTextPrimaryColor,
        onSurface: darkTextPrimaryColor,
        onBackground: darkTextPrimaryColor,
        onError: textOnPrimaryColor,
      ),
      
      // الخط
      textTheme: _buildTextTheme(true),
      
      // شريط التطبيق
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurfaceColor,
        foregroundColor: darkTextPrimaryColor,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: darkTextPrimaryColor,
          fontFamily: 'Cairo',
        ),
      ),
      
      // الأزرار
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textOnPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      
      // البطاقات
      cardTheme: CardTheme(
        color: darkSurfaceColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // حقول الإدخال
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: const TextStyle(
          color: darkTextSecondaryColor,
          fontFamily: 'Cairo',
        ),
        hintStyle: const TextStyle(
          color: darkTextSecondaryColor,
          fontFamily: 'Cairo',
        ),
      ),
      
      // شريط التنقل السفلي
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: darkTextSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Cairo',
        ),
      ),
      
      // الحوارات
      dialogTheme: DialogTheme(
        backgroundColor: darkSurfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: darkTextPrimaryColor,
          fontFamily: 'Cairo',
        ),
        contentTextStyle: const TextStyle(
          fontSize: 16,
          color: darkTextPrimaryColor,
          fontFamily: 'Cairo',
        ),
      ),
      
      // القوائم
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: darkTextPrimaryColor,
          fontFamily: 'Cairo',
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 14,
          color: darkTextSecondaryColor,
          fontFamily: 'Cairo',
        ),
      ),
      
      // الفواصل
      dividerTheme: const DividerThemeData(
        color: Colors.grey,
        thickness: 1,
        space: 1,
      ),
      
      // الأيقونات
      iconTheme: const IconThemeData(
        color: darkTextSecondaryColor,
        size: 24,
      ),
      
      // التبديل
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor.withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),
    );
  }

  // بناء نظام النصوص
  static TextTheme _buildTextTheme(bool isDark) {
    final Color textColor = isDark ? darkTextPrimaryColor : textPrimaryColor;
    final Color secondaryTextColor = isDark ? darkTextSecondaryColor : textSecondaryColor;
    
    return GoogleFonts.cairoTextTheme().copyWith(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: secondaryTextColor,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
      ),
    );
  }

  // ألوان إضافية للتطبيق
  static const Map<String, Color> customColors = {
    'success': Color(0xFF4CAF50),
    'warning': Color(0xFFFF9800),
    'info': Color(0xFF2196F3),
    'danger': Color(0xFFF44336),
    'light': Color(0xFFF8F9FA),
    'dark': Color(0xFF343A40),
  };

  // الحصول على لون مخصص
  static Color getCustomColor(String name) {
    return customColors[name] ?? primaryColor;
  }

  // تدرجات الألوان
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentColor, Color(0xFFFF7043)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // الظلال
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
}
