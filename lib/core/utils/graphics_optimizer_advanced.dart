import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'error_handler.dart';

class GraphicsOptimizerAdvanced {
  static final GraphicsOptimizerAdvanced _instance =
      GraphicsOptimizerAdvanced._internal();
  factory GraphicsOptimizerAdvanced() => _instance;
  GraphicsOptimizerAdvanced._internal();

  final Map<String, dynamic> _cachedImages = {};
  final Map<String, DateTime> _imageAccessTimes = {};
  final Duration _imageCacheDuration = const Duration(hours: 1);

  Widget optimizeImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    try {
      final cachedImage = _getCachedImage(imageUrl);
      if (cachedImage != null) {
        return cachedImage;
      }

      final image = _buildImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: placeholder,
        errorWidget: errorWidget,
      );

      _cacheImage(imageUrl, image);
      return image;
    } catch (e) {
      ErrorHandler().handleError(e);
      return errorWidget ?? const Icon(Icons.error);
    }
  }

  Widget _buildImage({
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
        placeholder: (context, url) =>
            placeholder ?? const CircularProgressIndicator(),
        errorWidget: (context, url, error) =>
            errorWidget ?? const Icon(Icons.error),
      ),
    );
  }

  dynamic _getCachedImage(String imageUrl) {
    if (!_cachedImages.containsKey(imageUrl)) return null;

    final cacheTime = _imageAccessTimes[imageUrl];
    if (cacheTime == null) return null;

    if (DateTime.now().difference(cacheTime) > _imageCacheDuration) {
      _removeCachedImage(imageUrl);
      return null;
    }

    _imageAccessTimes[imageUrl] = DateTime.now();
    return _cachedImages[imageUrl];
  }

  void _cacheImage(String imageUrl, dynamic image) {
    _cachedImages[imageUrl] = image;
    _imageAccessTimes[imageUrl] = DateTime.now();
    _cleanupImages();
  }

  void _removeCachedImage(String imageUrl) {
    _cachedImages.remove(imageUrl);
    _imageAccessTimes.remove(imageUrl);
  }

  void _cleanupImages() {
    final now = DateTime.now();

    final entriesToRemove = _imageAccessTimes.entries.where((entry) {
      return now.difference(entry.value) > _imageCacheDuration;
    }).toList();

    for (var entry in entriesToRemove) {
      _removeCachedImage(entry.key);
    }
  }

  void startImageMonitoring() {
    Timer.periodic(const Duration(minutes: 5), (timer) {
      _cleanupImages();
    });
  }

  void dispose() {
    _cachedImages.clear();
    _imageAccessTimes.clear();
  }
}
