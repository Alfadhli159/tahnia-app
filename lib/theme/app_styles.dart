import 'package:flutter/material.dart';
import 'package:tahania_app/theme/app_theme.dart';

class AppStyles {
  // المسافات
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // أحجام العناصر
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;

  // أنماط البطاقات
  static final cardDecoration = BoxDecoration(
    color: AppTheme.cardColor,
    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // أنماط الأزرار
  static final primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppTheme.primaryColor,
    foregroundColor: Colors.white,
    elevation: AppTheme.buttonElevation,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: AppStyles.spacingL,
      vertical: AppStyles.spacingM,
    ),
  );

  static final secondaryButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: AppTheme.primaryColor,
    side: const BorderSide(color: AppTheme.primaryColor),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: AppStyles.spacingL,
      vertical: AppStyles.spacingM,
    ),
  );

  static final textButtonStyle = TextButton.styleFrom(
    foregroundColor: AppTheme.primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: AppStyles.spacingM,
      vertical: AppStyles.spacingS,
    ),
  );

  // أنماط حقول الإدخال
  static final inputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      borderSide: const BorderSide(color: AppTheme.dividerColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      borderSide: const BorderSide(color: AppTheme.dividerColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      borderSide: const BorderSide(color: AppTheme.primaryColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      borderSide: const BorderSide(color: AppTheme.errorColor),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppStyles.spacingM,
      vertical: AppStyles.spacingM,
    ),
  );

  // أنماط القوائم
  static final listTileStyle = ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppStyles.spacingM,
      vertical: AppStyles.spacingS,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
    ),
  );

  // أنماط الشريط العلوي
  static final appBarStyle = AppBarTheme(
    backgroundColor: AppTheme.primaryColor,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  // أنماط الشريط السفلي
  static final bottomNavigationBarStyle = BottomNavigationBarThemeData(
    backgroundColor: AppTheme.surfaceColor,
    selectedItemColor: AppTheme.primaryColor,
    unselectedItemColor: AppTheme.textSecondaryColor,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  );

  // أنماط الرسائل
  static final snackBarStyle = SnackBarThemeData(
    backgroundColor: AppTheme.textPrimaryColor,
    contentTextStyle: const TextStyle(color: Colors.white),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
    ),
    behavior: SnackBarBehavior.floating,
  );

  // أنماط النوافذ المنبثقة
  static final dialogStyle = DialogTheme(
    backgroundColor: AppTheme.surfaceColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
    ),
    elevation: AppTheme.cardElevation,
  );

  // أنماط الأوراق السفلية
  static final bottomSheetStyle = BottomSheetThemeData(
    backgroundColor: AppTheme.surfaceColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppTheme.borderRadius),
      ),
    ),
    elevation: AppTheme.cardElevation,
  );

  // أنماط التصنيفات
  static final chipStyle = ChipThemeData(
    backgroundColor: Colors.grey[200],
    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
    labelStyle: const TextStyle(color: AppTheme.textPrimaryColor),
    padding: const EdgeInsets.symmetric(
      horizontal: AppStyles.spacingM,
      vertical: AppStyles.spacingS,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
    ),
  );

  // أنماط الفواصل
  static final dividerStyle = const DividerThemeData(
    color: AppTheme.dividerColor,
    thickness: 1,
    space: 1,
  );

  // أنماط النصوص
  static final textStyles = const TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppTheme.textPrimaryColor,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppTheme.textPrimaryColor,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppTheme.textPrimaryColor,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppTheme.textPrimaryColor,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppTheme.textPrimaryColor,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: AppTheme.textPrimaryColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: AppTheme.textSecondaryColor,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppTheme.textPrimaryColor,
    ),
  );

  // أنماط الأيقونات
  static final iconStyle = const IconThemeData(
    color: AppTheme.textSecondaryColor,
    size: 24,
  );

  // أنماط الأزرار العائمة
  static final floatingActionButtonStyle = const FloatingActionButtonThemeData(
    backgroundColor: AppTheme.primaryColor,
    foregroundColor: Colors.white,
    elevation: AppTheme.buttonElevation,
  );
} 