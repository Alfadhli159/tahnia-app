import 'package:flutter/material.dart';
import 'package:shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SmartGreetingService {
  static const String _cacheKey = 'greeting_cache';
  static const Duration _cacheDuration = Duration(days: 7);
  static const int _maxCacheSize = 1000;
  
  // قائمة المناسبات الشائعة التي تستخدم المنطق المحلي
  static const List<String> _commonOccasions = [
    'birthday', 'عيد ميلاد',
    'eid', 'عيد',
    'ramadan', 'رمضان',
    'wedding', 'زواج',
    'graduation', 'تخرج',
    'new_baby', 'مولود جديد',
    'new_job', 'وظيفة جديدة',
    'new_home', 'بيت جديد',
    'anniversary', 'ذكرى سنوية',
    'recovery', 'شفاء',
    'success', 'نجاح',
    'promotion', 'ترقية',
  ];

  // تخزين مؤقت للاقتراحات
  static Map<String, CachedGreeting> _cache = {};

  /// يقترح نص تهنئة ذكي بناءً على المناسبة واسم المستلم واللغة
  static Future<String> suggestGreeting({
    required String occasion,
    required String recipientName,
    String? senderName,
    Locale? locale,
    bool forceAI = false,
  }) async {
    // تحميل التخزين المؤقت
    await _loadCache();

    final lang = locale?.languageCode ?? 'ar';
    final name = recipientName.isNotEmpty ? recipientName : 'صديقي';
    final sender = senderName?.isNotEmpty == true ? senderName : '';

    // إنشاء مفتاح فريد للطلب
    final cacheKey = '${occasion}_${name}_${lang}_${sender}';

    // التحقق من وجود اقتراح في التخزين المؤقت
    if (!forceAI && _cache.containsKey(cacheKey)) {
      final cachedGreeting = _cache[cacheKey]!;
      if (!cachedGreeting.isExpired) {
        return cachedGreeting.greeting;
      }
    }

    // تحديد ما إذا كان سيتم استخدام المنطق المحلي أو الذكاء الاصطناعي
    final shouldUseLocalLogic = !forceAI && _commonOccasions.contains(occasion.toLowerCase());

    String greeting;
    if (shouldUseLocalLogic) {
      greeting = _getLocalGreeting(
        occasion: occasion,
        name: name,
        sender: sender,
        lang: lang,
      );
    } else {
      try {
        greeting = await _getAIGreeting(
          occasion: occasion,
          name: name,
          sender: sender,
          lang: lang,
        );
      } catch (e) {
        // في حالة فشل الذكاء الاصطناعي، نستخدم المنطق المحلي كنسخة احتياطية
        greeting = _getLocalGreeting(
          occasion: occasion,
          name: name,
          sender: sender,
          lang: lang,
        );
      }
    }

    // تخزين الاقتراح في التخزين المؤقت
    _cache[cacheKey] = CachedGreeting(
      greeting: greeting,
      timestamp: DateTime.now(),
    );

    // حفظ التخزين المؤقت
    await _saveCache();

    return greeting;
  }

  /// الحصول على تهنئة من المنطق المحلي
  static String _getLocalGreeting({
    required String occasion,
    required String name,
    required String sender,
    required String lang,
  }) {
    if (lang == 'en') {
      switch (occasion.toLowerCase()) {
        case 'birthday':
          return 'Happy Birthday, $name! Wishing you a wonderful year ahead filled with joy and success.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'eid':
          return 'Eid Mubarak, $name! May your days be filled with joy, peace, and blessings.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'ramadan':
          return 'Ramadan Kareem, $name! Wishing you a blessed month of spiritual growth and reflection.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'wedding':
          return 'Congratulations on your wedding, $name! Wishing you a lifetime of love, happiness, and beautiful memories.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'graduation':
          return 'Congratulations on your graduation, $name! Wishing you success in your future endeavors and all your dreams come true.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'new_baby':
          return 'Congratulations on your new baby, $name! Wishing your little one a life filled with love and happiness.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'new_job':
          return 'Congratulations on your new job, $name! Wishing you success and fulfillment in your new role.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'new_home':
          return 'Congratulations on your new home, $name! May it be filled with love, laughter, and wonderful memories.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'anniversary':
          return 'Happy Anniversary, $name! Wishing you many more years of love and happiness together.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'recovery':
          return 'Wishing you a speedy recovery, $name! May you return to full health soon.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'success':
          return 'Congratulations on your success, $name! Your hard work and dedication have paid off.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'promotion':
          return 'Congratulations on your promotion, $name! Wishing you continued success in your career.' + (sender.isNotEmpty ? ' — $sender' : '');
        default:
          return 'Congratulations, $name! Best wishes for your special occasion.' + (sender.isNotEmpty ? ' — $sender' : '');
      }
    } else {
      switch (occasion) {
        case 'عيد ميلاد':
        case 'birthday':
          return 'عيد ميلاد سعيد $name! أتمنى لك عامًا مليئًا بالفرح والنجاح.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'عيد':
        case 'eid':
          return 'عيد مبارك $name! أتمنى لك أيامًا مليئة بالفرح والسلام والبركة.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'رمضان':
        case 'ramadan':
          return 'رمضان كريم $name! أتمنى لك شهرًا مباركًا مليئًا بالنمو الروحي والتأمل.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'زواج':
        case 'wedding':
          return 'مبروك الزواج $name! أتمنى لك حياة مليئة بالحب والسعادة والذكريات الجميلة.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'تخرج':
        case 'graduation':
          return 'مبروك التخرج $name! أتمنى لك النجاح في مسيرتك المستقبلية وتحقيق جميع أحلامك.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'مولود جديد':
        case 'new_baby':
          return 'مبروك المولود الجديد $name! أتمنى لطفلك حياة مليئة بالحب والسعادة.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'وظيفة جديدة':
        case 'new_job':
          return 'مبروك الوظيفة الجديدة $name! أتمنى لك النجاح والرضا في دورك الجديد.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'بيت جديد':
        case 'new_home':
          return 'مبروك البيت الجديد $name! أتمنى أن يكون مليئًا بالحب والضحك والذكريات الجميلة.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'ذكرى سنوية':
        case 'anniversary':
          return 'عيد زواج سعيد $name! أتمنى لك المزيد من سنوات الحب والسعادة معًا.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'شفاء':
        case 'recovery':
          return 'أتمنى لك الشفاء العاجل $name! نتمنى أن تعود بصحة جيدة قريبًا.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'نجاح':
        case 'success':
          return 'مبروك نجاحك $name! لقد أثمرت جهودك وتفانيك.' + (sender.isNotEmpty ? ' — $sender' : '');
        case 'ترقية':
        case 'promotion':
          return 'مبروك الترقية $name! أتمنى لك المزيد من النجاح في مسيرتك المهنية.' + (sender.isNotEmpty ? ' — $sender' : '');
        default:
          return 'مبروك $name! أطيب التمنيات لمناسبتك الخاصة.' + (sender.isNotEmpty ? ' — $sender' : '');
      }
    }
  }

  /// الحصول على تهنئة من الذكاء الاصطناعي
  static Future<String> _getAIGreeting({
    required String occasion,
    required String name,
    required String sender,
    required String lang,
  }) async {
    // هنا يتم إضافة كود الاتصال بـ API الذكاء الاصطناعي
    // مثال باستخدام OpenAI API
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_API_KEY',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a greeting message generator. Generate a personalized greeting message.',
            },
            {
              'role': 'user',
              'content': 'Generate a ${lang == 'en' ? 'English' : 'Arabic'} greeting message for $occasion for $name${sender.isNotEmpty ? ' from $sender' : ''}.',
            },
          ],
          'temperature': 0.7,
          'max_tokens': 100,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('Failed to generate AI greeting');
      }
    } catch (e) {
      throw Exception('Failed to connect to AI service');
    }
  }

  /// تحميل التخزين المؤقت
  static Future<void> _loadCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheJson = prefs.getString(_cacheKey);
      if (cacheJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(cacheJson);
        _cache = decoded.map((key, value) => MapEntry(
          key,
          CachedGreeting.fromJson(value),
        ));

        // تنظيف التخزين المؤقت من العناصر منتهية الصلاحية
        _cleanExpiredCache();
      }
    } catch (e) {
      _cache = {};
    }
  }

  /// حفظ التخزين المؤقت
  static Future<void> _saveCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // تنظيف التخزين المؤقت قبل الحفظ
      _cleanExpiredCache();
      
      if (_cache.length > _maxCacheSize) {
        // إزالة أقدم العناصر إذا تجاوز الحجم الأقصى
        _removeOldestEntries();
      }
      
      await prefs.setString(_cacheKey, jsonEncode(_cache));
    } catch (e) {
      // تجاهل أخطاء التخزين المؤقت
    }
  }

  /// تنظيف التخزين المؤقت من العناصر منتهية الصلاحية
  static void _cleanExpiredCache() {
    _cache.removeWhere((key, value) => value.isExpired);
  }

  /// إزالة أقدم العناصر من التخزين المؤقت
  static void _removeOldestEntries() {
    final sortedEntries = _cache.entries.toList()
      ..sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));
    
    // إزالة 20% من أقدم العناصر
    final removeCount = (_maxCacheSize * 0.2).ceil();
    final entriesToKeep = sortedEntries.skip(removeCount);
    
    _cache = Map.fromEntries(entriesToKeep);
  }

  /// الحصول على إحصائيات التخزين المؤقت
  static Map<String, dynamic> getCacheStats() {
    return {
      'total_entries': _cache.length,
      'expired_entries': _cache.values.where((entry) => entry.isExpired).length,
      'oldest_entry': _cache.values.isEmpty ? null : _cache.values.reduce((a, b) => a.timestamp.isBefore(b.timestamp) ? a : b).timestamp,
      'newest_entry': _cache.values.isEmpty ? null : _cache.values.reduce((a, b) => a.timestamp.isAfter(b.timestamp) ? a : b).timestamp,
    };
  }

  /// يقترح نص تهنئة ذكي مع صورة بناءً على المناسبة واسم المستلم واللغة
  static Future<SmartGreeting> suggestGreetingWithMedia({
    required String occasion,
    required String recipientName,
    String? senderName,
    Locale? locale,
    bool forceAI = false,
  }) async {
    final greeting = await suggestGreeting(
      occasion: occasion,
      recipientName: recipientName,
      senderName: senderName,
      locale: locale,
      forceAI: forceAI,
    );

    final media = await _getGreetingMedia(occasion, locale?.languageCode ?? 'ar');

    return SmartGreeting(
      text: greeting,
      mediaUrl: media['url'],
      mediaType: media['type'],
    );
  }

  /// الحصول على وسائط مناسبة للتهنئة
  static Future<Map<String, String>> _getGreetingMedia(String occasion, String lang) async {
    // هنا يمكن إضافة منطق للحصول على صور أو فيديوهات مناسبة
    // يمكن استخدام API خارجي أو قاعدة بيانات محلية
    final mediaMap = {
      'birthday': {
        'url': 'assets/images/birthday.jpg',
        'type': 'image',
      },
      'eid': {
        'url': 'assets/images/eid.jpg',
        'type': 'image',
      },
      'ramadan': {
        'url': 'assets/images/ramadan.jpg',
        'type': 'image',
      },
      'wedding': {
        'url': 'assets/images/wedding.jpg',
        'type': 'image',
      },
      'graduation': {
        'url': 'assets/images/graduation.jpg',
        'type': 'image',
      },
      'new_baby': {
        'url': 'assets/images/baby.jpg',
        'type': 'image',
      },
      'new_job': {
        'url': 'assets/images/job.jpg',
        'type': 'image',
      },
      'new_home': {
        'url': 'assets/images/home.jpg',
        'type': 'image',
      },
      'anniversary': {
        'url': 'assets/images/anniversary.jpg',
        'type': 'image',
      },
      'recovery': {
        'url': 'assets/images/recovery.jpg',
        'type': 'image',
      },
      'success': {
        'url': 'assets/images/success.jpg',
        'type': 'image',
      },
      'promotion': {
        'url': 'assets/images/promotion.jpg',
        'type': 'image',
      },
    };

    return mediaMap[occasion.toLowerCase()] ?? {
      'url': 'assets/images/default.jpg',
      'type': 'image',
    };
  }
}

/// نموذج للتهنئة الذكية مع الوسائط
class SmartGreeting {
  final String text;
  final String? mediaUrl;
  final String? mediaType;

  SmartGreeting({
    required this.text,
    this.mediaUrl,
    this.mediaType,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'mediaUrl': mediaUrl,
    'mediaType': mediaType,
  };

  factory SmartGreeting.fromJson(Map<String, dynamic> json) => SmartGreeting(
    text: json['text'],
    mediaUrl: json['mediaUrl'],
    mediaType: json['mediaType'],
  );
}

/// نموذج لتخزين التهاني المؤقتة
class CachedGreeting {
  final String greeting;
  final DateTime timestamp;
  final String? mediaUrl;
  final String? mediaType;

  CachedGreeting({
    required this.greeting,
    required this.timestamp,
    this.mediaUrl,
    this.mediaType,
  });

  bool get isExpired => DateTime.now().difference(timestamp) > SmartGreetingService._cacheDuration;

  Map<String, dynamic> toJson() => {
    'greeting': greeting,
    'timestamp': timestamp.toIso8601String(),
    'mediaUrl': mediaUrl,
    'mediaType': mediaType,
  };

  factory CachedGreeting.fromJson(Map<String, dynamic> json) => CachedGreeting(
    greeting: json['greeting'],
    timestamp: DateTime.parse(json['timestamp']),
    mediaUrl: json['mediaUrl'],
    mediaType: json['mediaType'],
  );
} 