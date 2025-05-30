import 'package:shared_preferences/shared_preferences.dart';

/// خدمة إدارة إعدادات التطبيق
class SettingsService {
  static const String _senderNameKey = 'sender_name';
  static const String _defaultSignatureKey = 'default_signature';
  static const String _autoSignatureKey = 'auto_signature';
  static const String _preferredLanguageKey = 'preferred_language';
  static const String _themeKey = 'theme_mode';
  
  static SharedPreferences? _prefs;
  
  /// تهيئة الخدمة
  static Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  
  /// الحصول على اسم المرسل
  static Future<String?> getSenderName() async {
    await initialize();
    return _prefs?.getString(_senderNameKey);
  }
  
  /// حفظ اسم المرسل
  static Future<bool> setSenderName(String name) async {
    await initialize();
    return await _prefs?.setString(_senderNameKey, name) ?? false;
  }
  
  /// الحصول على التوقيع الافتراضي
  static Future<String?> getDefaultSignature() async {
    await initialize();
    return _prefs?.getString(_defaultSignatureKey);
  }
  
  /// حفظ التوقيع الافتراضي
  static Future<bool> setDefaultSignature(String signature) async {
    await initialize();
    return await _prefs?.setString(_defaultSignatureKey, signature) ?? false;
  }
  
  /// الحصول على حالة التوقيع التلقائي
  static Future<bool> getAutoSignature() async {
    await initialize();
    return _prefs?.getBool(_autoSignatureKey) ?? true;
  }
  
  /// تعيين حالة التوقيع التلقائي
  static Future<bool> setAutoSignature(bool enabled) async {
    await initialize();
    return await _prefs?.setBool(_autoSignatureKey, enabled) ?? false;
  }
  
  /// الحصول على اللغة المفضلة
  static Future<String> getPreferredLanguage() async {
    await initialize();
    return _prefs?.getString(_preferredLanguageKey) ?? 'ar';
  }
  
  /// تعيين اللغة المفضلة
  static Future<bool> setPreferredLanguage(String language) async {
    await initialize();
    return await _prefs?.setString(_preferredLanguageKey, language) ?? false;
  }
  
  /// الحصول على وضع الثيم
  static Future<String> getThemeMode() async {
    await initialize();
    return _prefs?.getString(_themeKey) ?? 'system';
  }
  
  /// تعيين وضع الثيم
  static Future<bool> setThemeMode(String mode) async {
    await initialize();
    return await _prefs?.setString(_themeKey, mode) ?? false;
  }
  
  /// مسح جميع الإعدادات
  static Future<bool> clearAllSettings() async {
    await initialize();
    return await _prefs?.clear() ?? false;
  }
  
  /// الحصول على جميع الإعدادات
  static Future<Map<String, dynamic>> getAllSettings() async {
    await initialize();
    return {
      'senderName': await getSenderName(),
      'defaultSignature': await getDefaultSignature(),
      'autoSignature': await getAutoSignature(),
      'preferredLanguage': await getPreferredLanguage(),
      'themeMode': await getThemeMode(),
    };
  }
  
  /// استيراد الإعدادات
  static Future<bool> importSettings(Map<String, dynamic> settings) async {
    try {
      await initialize();
      
      if (settings['senderName'] != null) {
        await setSenderName(settings['senderName']);
      }
      
      if (settings['defaultSignature'] != null) {
        await setDefaultSignature(settings['defaultSignature']);
      }
      
      if (settings['autoSignature'] != null) {
        await setAutoSignature(settings['autoSignature']);
      }
      
      if (settings['preferredLanguage'] != null) {
        await setPreferredLanguage(settings['preferredLanguage']);
      }
      
      if (settings['themeMode'] != null) {
        await setThemeMode(settings['themeMode']);
      }
      
      return true;
    } catch (e) {
      print('خطأ في استيراد الإعدادات: $e');
      return false;
    }
  }
  
  /// التحقق من وجود إعدادات محفوظة
  static Future<bool> hasSettings() async {
    await initialize();
    final senderName = await getSenderName();
    return senderName != null && senderName.isNotEmpty;
  }
  
  /// إعداد الإعدادات الافتراضية
  static Future<void> setDefaultSettings() async {
    final hasExistingSettings = await hasSettings();
    
    if (!hasExistingSettings) {
      await setSenderName('المرسل');
      await setDefaultSignature('مع أطيب التحيات');
      await setAutoSignature(true);
      await setPreferredLanguage('ar');
      await setThemeMode('system');
    }
  }
}
