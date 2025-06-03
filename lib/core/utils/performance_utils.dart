import 'dart:async';
import 'package:flutter/material.dart';

/// Utility class for performance optimizations
class PerformanceUtils {
  static final Map<String, Timer> _timers = {};

  /// Builds a widget with performance monitoring
  static Widget buildWithPerformance({
    required Widget child,
    bool maintainState = false,
    String? debugLabel,
  }) =>
      // For now, just return the child widget
      // In the future, this could include performance monitoring
      child;

  /// Optimizes list building for large datasets
  static Widget buildOptimizedList({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
    ScrollController? controller,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    Axis scrollDirection = Axis.vertical,
  }) =>
      ListView.builder(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        controller: controller,
        physics: physics,
        padding: padding,
        shrinkWrap: shrinkWrap,
        scrollDirection: scrollDirection,
        // Add performance optimizations
        cacheExtent: 250.0,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
      );

  /// Debounces function calls to improve performance
  static void debounce(
    Duration duration,
    VoidCallback callback, {
    String? key,
  }) {
    _timers[key ?? 'default']?.cancel();
    _timers[key ?? 'default'] = Timer(duration, callback);
  }
}
