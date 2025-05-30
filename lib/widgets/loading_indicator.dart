import 'package:flutter/material.dart';
import 'package:tahania_app/config/theme/app_theme.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final bool isFullScreen;
  final Color? color;
  final double size;

  const LoadingIndicator({
    Key? key,
    this.message,
    this.isFullScreen = false,
    this.color,
    this.size = 40.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loadingWidget = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppTheme.primaryColor,
              ),
              strokeWidth: 3.0,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: color ?? AppTheme.textSecondaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    if (isFullScreen) {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
        child: loadingWidget,
      );
    }

    return loadingWidget;
  }
}

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    Key? key,
    this.width = double.infinity,
    this.height = 20.0,
    this.borderRadius = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[300]
            : Colors.grey[800],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;

  const LoadingOverlay({
    Key? key,
    required this.child,
    required this.isLoading,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
            child: LoadingIndicator(
              message: message,
              isFullScreen: true,
            ),
          ),
      ],
    );
  }
} 