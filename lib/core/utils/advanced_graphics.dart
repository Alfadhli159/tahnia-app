import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import 'error_handler.dart';

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
      child: CachedImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: placeholder,
        errorWidget: errorWidget,
      ),
    );
  }

  static Widget buildAnimatedContainer({
    required Widget child,
    Duration duration = AppConstants.defaultAnimationDuration,
    Curve curve = AppConstants.defaultAnimationCurve,
  }) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  static Widget buildAnimatedList({
    required List<Widget> children,
    Duration duration = AppConstants.defaultAnimationDuration,
    Curve curve = AppConstants.defaultAnimationCurve,
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
    return PerformanceOverlay(
      enabled: showPerformanceOverlay,
      child: child,
    );
  }

  static Widget buildRepaintBoundary({
    required Widget child,
  }) {
    return RepaintBoundary(
      child: child,
    );
  }
}
