import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, dynamic> _jsonData;
  late Map<String, String> _flattenedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) => Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Future<bool> load() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/translations/${locale.languageCode}.json'
      );
      _jsonData = json.decode(jsonString);
      _flattenedStrings = _flattenMap(_jsonData);
      
      debugPrint('BuildContext locale: $locale');
      return true;
    } catch (e) {
      debugPrint('Error loading translations: $e');
      _jsonData = {};
      _flattenedStrings = {};
      return false;
    }
  }

  Map<String, String> _flattenMap(Map<String, dynamic> map, [String prefix = '']) {
    final result = <String, String>{};
    
    map.forEach((key, value) {
      final newKey = prefix.isEmpty ? key : '$prefix.$key';
      
      if (value is Map<String, dynamic>) {
        result.addAll(_flattenMap(value, newKey));
      } else {
        result[newKey] = value.toString();
      }
    });
    
    return result;
  }

  String translate(String key, {Map<String, String>? params}) {
    String translation = _getTranslation(key);
    
    if (params != null) {
      params.forEach((paramKey, paramValue) {
        translation = translation.replaceAll('{$paramKey}', paramValue);
      });
    }
    
    return translation;
  }

  String _getTranslation(String key) {
    // البحث في الخريطة المسطحة أولاً
    if (_flattenedStrings.containsKey(key)) {
      return _flattenedStrings[key]!;
    }
    
    // البحث في البيانات الأصلية
    final value = _getNestedValue(_jsonData, key);
    if (value != null) {
      return value;
    }
    
    // إذا لم توجد الترجمة، إرجاع المفتاح مع رسالة تحذير
    debugPrint('Sample translation ($key): $key');
    return key;
  }

  String? _getNestedValue(Map<String, dynamic> map, String key) {
    final keys = key.split('.');
    dynamic current = map;
    
    for (final k in keys) {
      if (current is Map && current.containsKey(k)) {
        current = current[k];
      } else {
        return null;
      }
    }
    
    return current?.toString();
  }

  // ترجمات سريعة للنصوص الشائعة
  String get appName => translate('app.name');
  String get save => translate('common.save');
  String get cancel => translate('common.cancel');
  String get delete => translate('common.delete');
  String get edit => translate('common.edit');
  String get search => translate('common.search');
  String get loading => translate('common.loading');
  String get error => translate('common.error');
  String get success => translate('common.success');
  String get retry => translate('common.retry');

  // ترجمات التهاني
  String get sendGreeting => translate('greetings.send_greeting');
  String get messageType => translate('greetings.message_type');
  String get occasionType => translate('greetings.occasion_type');
  String get occasion => translate('greetings.occasion');
  String get senderName => translate('greetings.sender_name');
  String get recipientName => translate('greetings.recipient_name');
  String get message => translate('greetings.message');
  String get generate => translate('greetings.generate');
  String get contacts => translate('greetings.contacts');

  // ترجمات الإعدادات
  String get settings => translate('settings.title');
  String get language => translate('settings.language');
  String get theme => translate('settings.theme');
  String get notifications => translate('settings.notifications');
  String get about => translate('settings.about');

  // التحقق من وجود الترجمة
  bool hasTranslation(String key) => _getTranslation(key) != key;

  // الحصول على جميع المفاتيح المتاحة
  List<String> get availableKeys => _flattenedStrings.keys.toList();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// مساعد للترجمة السريعة
class L10n {
  static String of(BuildContext context, String key, {Map<String, String>? params}) => AppLocalizations.of(context).translate(key, params: params);
  
  static bool hasTranslation(BuildContext context, String key) => AppLocalizations.of(context).hasTranslation(key);
}

// ثوابت الترجمة
class TranslationKeys {
  // التطبيق
  static const String appName = 'app.name';
  static const String appDescription = 'app.description';
  
  // عام
  static const String save = 'common.save';
  static const String cancel = 'common.cancel';
  static const String delete = 'common.delete';
  static const String edit = 'common.edit';
  static const String search = 'common.search';
  static const String loading = 'common.loading';
  static const String error = 'common.error';
  static const String success = 'common.success';
  static const String retry = 'common.retry';
  
  // التهاني
  static const String sendGreeting = 'greetings.send_greeting';
  static const String messageType = 'greetings.message_type';
  static const String occasionType = 'greetings.occasion_type';
  static const String occasion = 'greetings.occasion';
  static const String senderName = 'greetings.sender_name';
  static const String recipientName = 'greetings.recipient_name';
  static const String message = 'greetings.message';
  static const String generate = 'greetings.generate';
  static const String contacts = 'greetings.contacts';
  
  // الإعدادات
  static const String settings = 'settings.title';
  static const String language = 'settings.language';
  static const String theme = 'settings.theme';
  static const String notifications = 'settings.notifications';
  static const String about = 'settings.about';
  
  // السجل
  static const String history = 'history.title';
  static const String sent = 'history.sent';
  static const String scheduled = 'history.scheduled';
  static const String drafts = 'history.drafts';
  
  // القوالب
  static const String templates = 'templates.title';
  static const String addTemplate = 'templates.add';
  static const String editTemplate = 'templates.edit';
  static const String deleteTemplate = 'templates.delete';
}
