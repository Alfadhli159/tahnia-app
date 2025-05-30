import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'error_handler.dart';
import 'memory_manager_advanced.dart';
import 'graphics_optimizer_advanced.dart';

class PerformanceOptimizerAdvanced {
  static final PerformanceOptimizerAdvanced _instance = PerformanceOptimizerAdvanced._internal();
  factory PerformanceOptimizerAdvanced() => _instance;
  PerformanceOptimizerAdvanced._internal();

  final MemoryManagerAdvanced _memoryManager = MemoryManagerAdvanced();
  final GraphicsOptimizerAdvanced _graphicsOptimizer = GraphicsOptimizerAdvanced();
  final ErrorHandler _errorHandler = ErrorHandler();

  Widget optimizeWidget({
    required Widget child,
    bool maintainState = true,
    bool enableRepaintBoundary = true,
  }) {
    try {
      return PerformanceUtils.buildWithPerformance(
        child: enableRepaintBoundary
            ? RepaintBoundary(child: child)
            : child,
        maintainState: maintainState,
      );
    } catch (e) {
      _errorHandler.handleError(e);
      return child;
    }
  }

  Widget optimizeImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    try {
      return _graphicsOptimizer.optimizeImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: placeholder,
        errorWidget: errorWidget,
      );
    } catch (e) {
      _errorHandler.handleError(e);
      return errorWidget ?? const Icon(Icons.error);
    }
  }

  Widget optimizeListView({
    required List<Widget> children,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    Axis scrollDirection = Axis.vertical,
    Widget? separator,
  }) {
    try {
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
    } catch (e) {
      _errorHandler.handleError(e);
      return const SizedBox.shrink();
    }
  }

  void startPerformanceMonitoring() {
    _memoryManager.startMemoryMonitoring();
    _graphicsOptimizer.startImageMonitoring();
  }

  void dispose() {
    _memoryManager.dispose();
    _graphicsOptimizer.dispose();
  }
}
