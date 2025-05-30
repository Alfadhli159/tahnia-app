import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig extends ChangeNotifier {
  // معلومات التطبيق الأساسية
  static const String appName = 'تهنئة';
  static const String appVersion = '1.0.0';
  static const int appBuildNumber = 1;
  static const String appDescription = 'تطبيق تهنئة للتهاني والرسائل التوعوية';

  // إعدادات Firebase
  static const String firebaseApiKey = 'AIzaSyAoAQ9pmbkQiTT4bW3pU0gECkyJuZuLEhk';
  static const String firebaseAuthDomain = 'tahnia-app.firebaseapp.com';
  static const String firebaseProjectId = 'tahnia-app';
  static const String firebaseStorageBucket = 'tahnia-app.firebasestorage.app';
  static const String firebaseMessagingSenderId = '858947494660';
  static const String firebaseAppId = '1:858947494660:android:8c22a635d58ae58d722651';

  // إعدادات API
  static const String apiBaseUrl = 'https://api.tahnia.app';
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;

  // إعدادات التخزين
  static const int maxImageSize = 5242880; // 5MB
  static const int maxVideoSize = 10485760; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedVideoTypes = ['mp4', 'mov', 'avi'];
  static const int maxMessageLength = 1000;
  static const int maxTemplateLength = 500;

  // إعدادات الإشعارات
  static const String notificationChannelId = 'tahnia_notifications';
  static const String notificationChannelName = 'تهنئة';
  static const String notificationChannelDescription = 'إشعارات تطبيق تهنئة';
  static const Duration notificationDelay = Duration(seconds: 2);
  static const int maxNotificationRetries = 3;

  // إعدادات الكاش
  static const int cacheDuration = 604800; // 7 days in seconds
  static const int maxCacheSize = 104857600; // 100MB
  static const Duration cacheCleanupInterval = Duration(days: 1);

  // إعدادات الأمان
  static const String encryptionKey = 'tahnia_secure_key_2024';
  static const String jwtSecret = 'tahnia_jwt_secret_2024';
  static const Duration tokenExpiration = Duration(days: 7);
  static const int maxLoginAttempts = 5;

  // ميزات التطبيق
  static const bool enableMessageScheduling = true;
  static const bool enableMessageTemplates = true;
  static const bool enableContactGroups = true;
  static const bool enableAutoReply = true;
  static const bool enableMessageHistory = true;
  static const bool enableMessageAnalytics = true;

  // رسائل النظام
  static const Map<String, String> systemMessages = {
    'loading': 'جاري التحميل...',
    'error': 'حدث خطأ، يرجى المحاولة مرة أخرى',
    'success': 'تمت العملية بنجاح',
    'noInternet': 'لا يوجد اتصال بالإنترنت',
    'retry': 'إعادة المحاولة',
    'cancel': 'إلغاء',
    'confirm': 'تأكيد',
    'delete': 'حذف',
    'edit': 'تعديل',
    'save': 'حفظ',
  };

  // إعدادات المستخدم
  ThemeMode _themeMode = ThemeMode.system;
  Locale _currentLocale = const Locale('ar', 'SA');
  bool _isFirstLaunch = true;
  bool _notificationsEnabled = true;
  bool _autoSaveContacts = true;
  bool _darkModeEnabled = false;
  bool _isLoggedIn = false;

  // Getters
  ThemeMode get themeMode => _themeMode;
  Locale get currentLocale => _currentLocale;
  bool get isFirstLaunch => _isFirstLaunch;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get autoSaveContacts => _autoSaveContacts;
  bool get darkModeEnabled => _darkModeEnabled;
  bool get isLoggedIn => _isLoggedIn;

  AppConfig() {
    // Settings are loaded asynchronously by the public loadSettings method
  }

  Future<void> loadSettings() async {
    await _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // تحميل إعدادات اللغة
    final languageCode = prefs.getString('languageCode') ?? 'ar';
    final countryCode = prefs.getString('countryCode') ?? 'SA';
    _currentLocale = Locale(languageCode, countryCode);
    
    // تحميل إعدادات الثيم
    final themeModeIndex = prefs.getInt('themeMode') ?? ThemeMode.system.index;
    _themeMode = ThemeMode.values[themeModeIndex];
    
    // تحميل إعدادات التطبيق
    _isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    _autoSaveContacts = prefs.getBool('autoSaveContacts') ?? true;
    _darkModeEnabled = prefs.getBool('darkModeEnabled') ?? false;
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Temporarily force locale to Arabic for debugging
    _currentLocale = const Locale('ar', 'SA');
    print('🌐 Forcing locale to Arabic: $_currentLocale'); // Add for debugging

    notifyListeners();
  }

  // تحديث إعدادات المستخدم
  Future<void> setLocale(Locale locale) async {
    if (_currentLocale == locale) return;
    _currentLocale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    await prefs.setString('countryCode', locale.countryCode ?? '');
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    notifyListeners();
  }

  Future<void> setFirstLaunch(bool value) async {
    if (_isFirstLaunch == value) return;
    _isFirstLaunch = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', value);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    if (_notificationsEnabled == value) return;
    _notificationsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    notifyListeners();
  }

  Future<void> setAutoSaveContacts(bool value) async {
    if (_autoSaveContacts == value) return;
    _autoSaveContacts = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoSaveContacts', value);
    notifyListeners();
  }

  Future<void> setDarkModeEnabled(bool value) async {
    if (_darkModeEnabled == value) return;
    _darkModeEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkModeEnabled', value);
    notifyListeners();
  }

  Future<void> setLoggedIn(bool value) async {
    if (_isLoggedIn == value) return;
    _isLoggedIn = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
    notifyListeners();
  }

  // إعادة تعيين الإعدادات
  Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _loadSettings();
  }

  // Feature Flags
  static const bool isAIMessagesEnabled = true;
  static const bool isAnalyticsEnabled = true;
  static const bool isCrashlyticsEnabled = true;
} 