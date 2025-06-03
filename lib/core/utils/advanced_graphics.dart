import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdvancedGraphics {
  static Widget buildOptimizedImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return RepaintBoundary(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: placeholder != null ? (context, url) => placeholder : null,
        errorWidget:
            errorWidget != null ? (context, url, error) => errorWidget : null,
      ),
    );
  }

  static Widget buildAnimatedContainer({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  static Widget buildAnimatedList({
    required List<Widget> children,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return AnimatedList(
      initialItemCount: children.length,
      itemBuilder: (context, index, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: children[index],
        );
      },
    );
  }

  static Widget buildCustomPaint({
    required CustomPainter painter,
    Size size = const Size(100, 100),
  }) {
    return CustomPaint(
      size: size,
      painter: painter,
    );
  }

  static Widget buildPerformanceOverlay({
    required Widget child,
    bool showPerformanceOverlay = false,
  }) {
    if (showPerformanceOverlay) {
      return Stack(
        children: [
          child,
          const PerformanceOverlay(),
        ],
      );
    }
    return child;
  }

  static Widget buildRepaintBoundary({
    required Widget child,
  }) {
    return RepaintBoundary(
      child: child,
    );
  }
}
