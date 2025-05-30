import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PerformanceUtils {
  static Widget buildWithPerformance({
    required Widget child,
    bool maintainState = true,
  }) {
    return maintainState
        ? KeepAliveWrapper(child: child)
        : child;
  }

  static Widget buildWithCache({
    required Widget child,
    required String key,
  }) {
    return RepaintBoundary(
      key: ValueKey(key),
      child: child,
    );
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class ImageCacheManager {
  static final ImageCacheManager _instance = ImageCacheManager._internal();
  factory ImageCacheManager() => _instance;
  ImageCacheManager._internal();

  void clearCache() {
    PaintingBinding.instance!.imageCache!.clear();
    PaintingBinding.instance!.imageCache!.clearLiveImages();
  }

  void evict(String url) {
    PaintingBinding.instance!.imageCache!.evict(url);
  }

  void setMaxSize(int maxSize) {
    PaintingBinding.instance!.imageCache!.maximumSize = maxSize;
  }
}
