import 'package:flutter/material.dart';
import 'package:tahania_app/config/animations/app_animations.dart';
import 'package:tahania_app/config/theme/app_theme.dart';

class AnimatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const AnimatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 48.0,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor ?? AppTheme.primaryColor;
    final effectiveTextColor = textColor ?? Colors.white;

    return AppAnimations.scaleOnTap(
      onTap: isEnabled && !isLoading ? onPressed : null,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isEnabled ? effectiveBackgroundColor : effectiveBackgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled && !isLoading ? onPressed : null,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Padding(
              padding: padding,
              child: Center(
                child: isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
                          strokeWidth: 2.0,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icon != null) ...[
                            Icon(
                              icon,
                              color: effectiveTextColor,
                              size: 20.0,
                            ),
                            const SizedBox(width: 8.0),
                          ],
                          Text(
                            text,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: effectiveTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final double borderRadius;

  const AnimatedIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.iconColor,
    this.size = 48.0,
    this.iconSize = 24.0,
    this.borderRadius = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppTheme.primaryColor;
    final effectiveIconColor = iconColor ?? Colors.white;

    return AppAnimations.scaleOnTap(
      onTap: isEnabled && !isLoading ? onPressed : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isEnabled ? effectiveBackgroundColor : effectiveBackgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled && !isLoading ? onPressed : null,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: iconSize * 0.8,
                      height: iconSize * 0.8,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(effectiveIconColor),
                        strokeWidth: 2.0,
                      ),
                    )
                  : Icon(
                      icon,
                      color: effectiveIconColor,
                      size: iconSize,
                    ),
            ),
          ),
        ),
      ),
    );
  }
} 