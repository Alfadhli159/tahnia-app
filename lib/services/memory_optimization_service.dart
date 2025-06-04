import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// خدمة تحسين استخدام الذاكرة في التطبيق
class MemoryOptimizationService {
  static final MemoryOptimizationService _instance = MemoryOptimizationService._internal();
  
  factory MemoryOptimizationService() => _instance;
  
  MemoryOptimizationService._internal();
  
  Timer? _cacheCleanupTimer;
  bool _isLowMemoryMode = false;
  int _failedCleanupAttempts = 0;
  static const int _maxFailedAttempts = 3;
  
  /// بدء خدمة تحسين الذاكرة
  void initialize() {
    // جدولة تنظيف الكاش كل ساعة بدلاً من 30 دقيقة
    _cacheCleanupTimer = Timer.periodic(
      const Duration(hours: 1), 
      (_) => _cleanupCache()
    );
  }
  
  /// تنظيف الكاش لتحرير الذاكرة
  Future<void> _cleanupCache() async {
    if (_failedCleanupAttempts >= _maxFailedAttempts) {
      debugPrint('⚠️ تم تجاوز الحد الأقصى لمحاولات تنظيف الكاش الفاشلة');
      return;
    }

    try {
      // تنظيف كاش الصور بشكل تدريجي
      if (_isLowMemoryMode) {
        await CachedNetworkImage.evictFromCache('');
        await DefaultCacheManager().emptyCache();
      } else {
        // في الوضع العادي، نقوم بتنظيف جزء من الكاش فقط
        final cacheManager = DefaultCacheManager();
        final files = await cacheManager.getFileFromCache("");
        if (files != null) {
          await cacheManager.removeFile(files.originalUrl);
        }
      }
      
      _failedCleanupAttempts = 0;
      debugPrint('✅ تم تنظيف الكاش بنجاح');
    } catch (e) {
      _failedCleanupAttempts++;
      debugPrint('❌ خطأ في تنظيف الكاش: $e');
    }
  }
  
  /// تنظيف الكاش يدويًا (يمكن استدعاؤها عند الحاجة)
  Future<void> cleanupCache() async {
    await _cleanupCache();
  }
  
  /// تفعيل وضع الذاكرة المنخفضة
  void enableLowMemoryMode() {
    _isLowMemoryMode = true;
    _cleanupCache();
  }
  
  /// إلغاء تفعيل وضع الذاكرة المنخفضة
  void disableLowMemoryMode() {
    _isLowMemoryMode = false;
  }
  
  /// التحقق من حالة وضع الذاكرة المنخفضة
  bool get isLowMemoryMode => _isLowMemoryMode;
  
  /// تحسين استخدام الذاكرة للصور
  ImageCache getOptimizedImageCache() {
    final cache = PaintingBinding.instance.imageCache;
    
    if (_isLowMemoryMode) {
      cache.maximumSize = 50;
      cache.maximumSizeBytes = 20 * 1024 * 1024;
    } else {
      cache.maximumSize = 100;
      cache.maximumSizeBytes = 50 * 1024 * 1024;
    }
    
    return cache;
  }
  
  /// تحرير الموارد عند إغلاق التطبيق
  void dispose() {
    _cacheCleanupTimer?.cancel();
    _cleanupCache();
  }
  
  /// تحسين أداء ListView
  ScrollPhysics getOptimizedScrollPhysics() => const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  
  /// الحصول على إعدادات تحسين الأداء للقوائم
  Widget Function(BuildContext, int) Function(
    Widget Function(BuildContext, int) childBuilder
  ) optimizeListViewBuilder({
    int? cacheExtent,
    bool addAutomaticKeepAlives = false,
    bool addRepaintBoundaries = true,
  }) => (Widget Function(BuildContext, int) childBuilder) {
      return (BuildContext context, int index) {
        final child = childBuilder(context, index);
        if (addRepaintBoundaries) {
          return RepaintBoundary(child: child);
        }
        return child;
      };
    };
}
