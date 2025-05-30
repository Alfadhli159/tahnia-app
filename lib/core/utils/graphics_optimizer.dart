import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../constants/app_constants.dart';

class GraphicsOptimizer {
  static Widget optimizeWidget({
    required Widget child,
    bool maintainState = true,
    bool enableRepaintBoundary = true,
    bool enablePerformanceOverlay = false,
  }) {
    return PerformanceUtils.buildWithPerformance(
      child: RepaintBoundary(
        child: child,
      ),
      maintainState: maintainState,
    );
  }

  static Widget optimizeImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return CachedImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder,
      errorWidget: errorWidget,
    );
  }

  static Widget optimizeListView({
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

  static Widget optimizeGrid({
    required List<Widget> children,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    Axis scrollDirection = Axis.vertical,
    int crossAxisCount = 2,
    double mainAxisSpacing = 8,
    double crossAxisSpacing = 8,
  }) {
    return GridView.count(
      key: const ValueKey('optimized_grid'),
      children: children,
      padding: padding ?? const EdgeInsets.all(8),
      physics: physics ?? const BouncingScrollPhysics(),
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: (width ?? 100) / (height ?? 100),
    );
  }
}
