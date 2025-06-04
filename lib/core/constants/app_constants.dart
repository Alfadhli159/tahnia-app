import 'package:flutter/material.dart';

class AppConstants {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  // App Version
  static const String version = '1.0.0';

  // API Endpoints
  static const String baseUrl = 'https://api.example.com';
  static const int timeoutDuration = 30;

  // Cache Settings
  static const int imageCacheSize = 100; // MB
  static const int maxCacheAge = 7; // days

  // Theme Settings
  static const double defaultFontSize = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const double defaultPadding = 16.0;

  // Animation Settings
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Curve defaultAnimationCurve = Curves.easeInOut;

  // Memory Management
  static const int maxListSize = 100;
  static const int maxImageQuality = 80;

  // Network Settings
  static const int maxRetries = 3;
  static const int retryDelay = 1000; // milliseconds

  // Storage Settings
  static const String localStorageKey = 'app_data';
  static const int maxLocalStorageSize = 50; // MB

  // Error Handling
  static const String defaultErrorMessage =
      'حدث خطأ ما. يرجى المحاولة مرة أخرى.';
  static const int maxErrorRetries = 3;
}
