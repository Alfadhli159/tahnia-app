import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// ويدجت لتحميل الصور بشكل محسن مع التخزين المؤقت
class OptimizedImage extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const OptimizedImage({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.backgroundColor,
  }) : assert(imageUrl != null || assetPath != null, 'يجب توفير imageUrl أو assetPath');

  @override
  Widget build(BuildContext context) {
    final Widget imageWidget = _buildImage();
    
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }
    
    return imageWidget;
  }

  Widget _buildImage() {
    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildErrorWidget(),
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 300),
        memCacheWidth: _calculateCacheWidth(),
        memCacheHeight: _calculateCacheHeight(),
      );
    } else if (assetPath != null) {
      return Image.asset(
        assetPath!,
        width: width,
        height: height,
        fit: fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            return child;
          }
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
        cacheWidth: _calculateCacheWidth(),
        cacheHeight: _calculateCacheHeight(),
      );
    } else {
      return _buildErrorWidget();
    }
  }

  Widget _buildPlaceholder() {
    if (placeholder != null) return placeholder!;
    
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? Colors.grey[200],
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (errorWidget != null) return errorWidget!;
    
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey[400],
          size: 24,
        ),
      ),
    );
  }

  // حساب العرض المناسب للتخزين المؤقت
  int? _calculateCacheWidth() {
    if (width == null) return null;
    return (width! * 2).round(); // ضعف العرض المطلوب للشاشات عالية الدقة
  }

  // حساب الارتفاع المناسب للتخزين المؤقت
  int? _calculateCacheHeight() {
    if (height == null) return null;
    return (height! * 2).round(); // ضعف الارتفاع المطلوب للشاشات عالية الدقة
  }
}
