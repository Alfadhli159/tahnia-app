import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GraphicsOptimizer {
  static Widget optimizeWidget({
    required Widget child,
    bool maintainState = true,
    bool enableRepaintBoundary = true,
    bool enablePerformanceOverlay = false,
  }) {
    Widget optimizedWidget = RepaintBoundary(child: child);

    if (enablePerformanceOverlay) {
      optimizedWidget = Stack(
        children: [
          optimizedWidget,
          const PerformanceOverlay(),
        ],
      );
    }

    return maintainState
        ? optimizedWidget
        : KeepAlive(
            keepAlive: false,
            child: optimizedWidget,
          );
  }

  static Widget optimizeImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) => CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) =>
          placeholder ?? const CircularProgressIndicator(),
      errorWidget: (context, url, error) =>
          errorWidget ?? const Icon(Icons.error),
    );

  static Widget optimizeListView({
    required List<Widget> children,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    Axis scrollDirection = Axis.vertical,
    Widget? separator,
  }) => SizedBox(
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
  }) => GridView.count(
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
