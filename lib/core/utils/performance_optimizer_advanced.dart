import 'package:flutter/material.dart';
import 'error_handler.dart';
import 'memory_manager_advanced.dart';
import 'graphics_optimizer_advanced.dart';

class PerformanceOptimizerAdvanced {
  static final PerformanceOptimizerAdvanced _instance =
      PerformanceOptimizerAdvanced._internal();
  factory PerformanceOptimizerAdvanced() => _instance;
  PerformanceOptimizerAdvanced._internal();

  final MemoryManagerAdvanced _memoryManager = MemoryManagerAdvanced();
  final GraphicsOptimizerAdvanced _graphicsOptimizer =
      GraphicsOptimizerAdvanced();
  final ErrorHandler _errorHandler = ErrorHandler();

  Widget optimizeWidget({
    required Widget child,
    bool maintainState = true,
    bool enableRepaintBoundary = true,
  }) {
    try {
      final Widget optimizedWidget =
          enableRepaintBoundary ? RepaintBoundary(child: child) : child;

      return maintainState
          ? optimizedWidget
          : KeepAlive(
              keepAlive: false,
              child: optimizedWidget,
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
      return SizedBox(
        width: width,
        height: height,
        child: ListView.separated(
          padding: padding ?? EdgeInsets.zero,
          physics: physics ?? const BouncingScrollPhysics(),
          shrinkWrap: shrinkWrap,
          scrollDirection: scrollDirection,
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
          separatorBuilder: (context, index) => separator ?? const SizedBox(),
        ),
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
