import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GreetingCostManager {
  static const String _statsKey = 'greeting_stats';
  static const String _costKey = 'greeting_cost';
  
  // إحصائيات الاستخدام
  static Map<String, int> _usageStats = {
    'local': 0,
    'ai': 0,
    'cache_hits': 0,
    'total_requests': 0,
  };

  // تكاليف API
  static const double _aiCostPerRequest = 0.0001; // تكلفة تقريبية لكل طلب
  static double _totalCost = 0.0;

  // حدود التكلفة
  static const double _monthlyCostLimit = 50.0; // الحد الأقصى الشهري بالدولار
  static const int _aiRequestLimit = 1000; // الحد الأقصى لطلبات AI يومياً

  // مؤقتات للتحكم في الاستخدام
  static DateTime? _lastResetTime;
  static int _dailyAiRequests = 0;

  /// تهيئة المدير
  static Future<void> initialize() async {
    await _loadStats();
    await _loadCost();
    _checkAndResetCounters();
  }

  /// تسجيل طلب جديد
  static Future<void> logRequest({
    required bool isAI,
    required bool isCacheHit,
  }) async {
    _checkAndResetCounters();
    
    _usageStats['total_requests'] = (_usageStats['total_requests'] ?? 0) + 1;
    
    if (isCacheHit) {
      _usageStats['cache_hits'] = (_usageStats['cache_hits'] ?? 0) + 1;
    } else if (isAI) {
      if (_canMakeAIRequest()) {
        _usageStats['ai'] = (_usageStats['ai'] ?? 0) + 1;
        _dailyAiRequests++;
        _totalCost += _aiCostPerRequest;
        await _saveCost();
      } else {
        // إذا تجاوزنا الحد، نستخدم المنطق المحلي
        _usageStats['local'] = (_usageStats['local'] ?? 0) + 1;
      }
    } else {
      _usageStats['local'] = (_usageStats['local'] ?? 0) + 1;
    }

    await _saveStats();
  }

  /// التحقق من إمكانية إجراء طلب AI
  static bool _canMakeAIRequest() {
    if (_totalCost >= _monthlyCostLimit) return false;
    if (_dailyAiRequests >= _aiRequestLimit) return false;
    return true;
  }

  /// الحصول على إحصائيات الاستخدام
  static Map<String, dynamic> getStats() => {
      'usage': _usageStats,
      'cost': _totalCost,
      'daily_ai_requests': _dailyAiRequests,
      'cache_hit_rate': _calculateCacheHitRate(),
    };

  /// حساب نسبة نجاح التخزين المؤقت
  static double _calculateCacheHitRate() {
    final total = _usageStats['total_requests'] ?? 1;
    final hits = _usageStats['cache_hits'] ?? 0;
    return (hits / total) * 100;
  }

  /// التحقق وإعادة تعيين العدادات
  static void _checkAndResetCounters() {
    final now = DateTime.now();
    
    // إعادة تعيين العدادات اليومية
    if (_lastResetTime == null || 
        now.difference(_lastResetTime!).inDays >= 1) {
      _dailyAiRequests = 0;
      _lastResetTime = now;
    }

    // إعادة تعيين التكلفة الشهرية
    if (_lastResetTime != null && 
        now.month != _lastResetTime!.month) {
      _totalCost = 0.0;
      _lastResetTime = now;
    }
  }

  /// تحميل الإحصائيات
  static Future<void> _loadStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final statsJson = prefs.getString(_statsKey);
      if (statsJson != null) {
        _usageStats = Map<String, int>.from(jsonDecode(statsJson));
      }
    } catch (e) {
      _usageStats = {
        'local': 0,
        'ai': 0,
        'cache_hits': 0,
        'total_requests': 0,
      };
    }
  }

  /// حفظ الإحصائيات
  static Future<void> _saveStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_statsKey, jsonEncode(_usageStats));
    } catch (e) {
      // تجاهل أخطاء الحفظ
    }
  }

  /// تحميل التكلفة
  static Future<void> _loadCost() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _totalCost = prefs.getDouble(_costKey) ?? 0.0;
    } catch (e) {
      _totalCost = 0.0;
    }
  }

  /// حفظ التكلفة
  static Future<void> _saveCost() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_costKey, _totalCost);
    } catch (e) {
      // تجاهل أخطاء الحفظ
    }
  }
} 