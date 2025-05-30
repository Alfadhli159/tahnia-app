import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'error_handler.dart';
import 'memory_manager.dart';
import 'cache_manager.dart';

class PerformanceOptimizer {
  static final PerformanceOptimizer _instance = PerformanceOptimizer._internal();
  factory PerformanceOptimizer() => _instance;
  PerformanceOptimizer._internal();

  final MemoryManager _memoryManager = MemoryManager();
  final ErrorHandler _errorHandler = ErrorHandler();
  final CacheManager _cacheManager = CacheManager();

  void optimizeWidget({
    required Widget child,
    bool maintainState = true,
    bool enableRepaintBoundary = true,
  }) {
    return PerformanceUtils.buildWithPerformance(
      child: RepaintBoundary(
        child: child,
      ),
      maintainState: maintainState,
    );
  }

  void optimizeImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    try {
      final cachedImage = _cacheManager.getImage(imageUrl);
      if (cachedImage != null) {
        return cachedImage;
      }

      final image = CachedImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: placeholder,
        errorWidget: errorWidget,
      );

      _cacheManager.setImage(imageUrl, image);
      return image;
    } catch (e) {
      _errorHandler.handleError(e);
      return errorWidget ?? const Icon(Icons.error);
    }
  }

  void optimizeListView({
    required List<Widget> children,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    Axis scrollDirection = Axis.vertical,
    Widget? separator,
  }) {
    return OptimizedListView(
      children: children,
      width: width,
      height: height,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
      separator: separator,
    );
  }

  void optimizeMemoryUsage() {
    _memoryManager._cleanupMemory();
    _cacheManager.clearExpired();
    _cacheManager.clearExpiredImages();
  }

  void dispose() {
    _memoryManager.dispose();
    _cacheManager.dispose();
  }
}
