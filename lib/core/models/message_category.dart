import 'dart:convert';
import 'package:flutter/services.dart';

/// نموذج بيانات التصنيفات المتدرجة للرسائل
class MessageCategory {
  final String name;
  final String icon;
  final Map<String, OccasionCategory> occasions;

  const MessageCategory({
    required this.name,
    required this.icon,
    required this.occasions,
  });

  factory MessageCategory.fromJson(String name, Map<String, dynamic> json) {
    final occasionsMap = <String, OccasionCategory>{};
    
    if (json['occasions'] != null) {
      (json['occasions'] as Map<String, dynamic>).forEach((key, value) {
        occasionsMap[key] = OccasionCategory.fromJson(key, value);
      });
    }

    return MessageCategory(
      name: name,
      icon: json['icon'] ?? '📝',
      occasions: occasionsMap,
    );
  }

  List<String> get occasionNames => occasions.keys.toList();
  
  List<String> getPurposesForOccasion(String occasionName) {
    return occasions[occasionName]?.purposes ?? [];
  }
}

/// تصنيف المناسبة
class OccasionCategory {
  final String name;
  final List<String> purposes;

  const OccasionCategory({
    required this.name,
    required this.purposes,
  });

  factory OccasionCategory.fromJson(String name, Map<String, dynamic> json) {
    return OccasionCategory(
      name: name,
      purposes: List<String>.from(json['purposes'] ?? []),
    );
  }
}

/// خدمة تحميل التصنيفات
class MessageCategoriesService {
  static Map<String, MessageCategory>? _categories;
  static bool _isLoading = false;
  static DateTime? _lastLoadTime;
  static const Duration _cacheValidity = Duration(hours: 24);
  
  /// تحميل التصنيفات من ملف JSON
  static Future<Map<String, MessageCategory>> loadCategories() async {
    // إذا كانت البيانات محملة مسبقًا وصالحة، أعد استخدامها
    if (_categories != null && _lastLoadTime != null) {
      final now = DateTime.now();
      final diff = now.difference(_lastLoadTime!);
      
      // التحقق من صلاحية الكاش
      if (diff < _cacheValidity) {
        return _categories!;
      }
    }
    
    // منع تحميل متزامن متعدد
    if (_isLoading) {
      // انتظار حتى اكتمال التحميل الحالي
      while (_isLoading) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      if (_categories != null) return _categories!;
    }
    
    _isLoading = true;
    
    try {
      final String jsonString = await rootBundle.loadString('assets/data/message_categories.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      final categoriesMap = <String, MessageCategory>{};
      
      if (jsonData['messageTypes'] != null) {
        (jsonData['messageTypes'] as Map<String, dynamic>).forEach((key, value) {
          categoriesMap[key] = MessageCategory.fromJson(key, value);
        });
      }
      
      _categories = categoriesMap;
      _lastLoadTime = DateTime.now();
      return categoriesMap;
    } catch (e) {
      print('خطأ في تحميل التصنيفات: $e');
      return {};
    } finally {
      _isLoading = false;
    }
  }
  
  /// الحصول على أسماء أنواع الرسائل
  static Future<List<String>> getMessageTypeNames() async {
    final categories = await loadCategories();
    return categories.keys.toList();
  }
  
  /// الحصول على المناسبات لنوع رسالة معين
  static Future<List<String>> getOccasionsForType(String messageType) async {
    final categories = await loadCategories();
    return categories[messageType]?.occasionNames ?? [];
  }
  
  /// الحصول على الأغراض لمناسبة معينة
  static Future<List<String>> getPurposesForOccasion(String messageType, String occasion) async {
    final categories = await loadCategories();
    return categories[messageType]?.getPurposesForOccasion(occasion) ?? [];
  }
  
  /// الحصول على أيقونة نوع الرسالة
  static Future<String> getIconForMessageType(String messageType) async {
    final categories = await loadCategories();
    return categories[messageType]?.icon ?? '📝';
  }
  
  /// إعادة تعيين الكاش
  static void clearCache() {
    _categories = null;
  }
}
