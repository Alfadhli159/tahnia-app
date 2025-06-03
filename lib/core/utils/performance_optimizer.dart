import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'error_handler.dart';

class PerformanceOptimizer {
  static final PerformanceOptimizer _instance =
      PerformanceOptimizer._internal();
  factory PerformanceOptimizer() => _instance;
  PerformanceOptimizer._internal();

  final ErrorHandler _errorHandler = ErrorHandler();
  final Map<String, Widget> _imageCache = {};

  Widget optimizeWidget({
    required Widget child,
    bool maintainState = true,
    bool enableRepaintBoundary = true,
  }) {
    Widget optimizedWidget =
        enableRepaintBoundary ? RepaintBoundary(child: child) : child;

    return maintainState
        ? optimizedWidget
        : KeepAlive(
            keepAlive: false,
            child: optimizedWidget,
          );
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
      if (_imageCache.containsKey(imageUrl)) {
        return _imageCache[imageUrl]!;
      }

      final image = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) =>
            placeholder ?? const CircularProgressIndicator(),
        errorWidget: (context, url, error) =>
            errorWidget ?? const Icon(Icons.error),
      );

      _imageCache[imageUrl] = image;
      return image;
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
  }

  void optimizeMemoryUsage() {
    // Clear image cache if it gets too large
    if (_imageCache.length > 100) {
      _imageCache.clear();
    }
  }

  void dispose() {
    _imageCache.clear();
  }
}
