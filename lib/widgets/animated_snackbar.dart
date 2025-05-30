import 'package:flutter/material.dart';
import 'package:tahania_app/config/theme/app_theme.dart';

class AnimatedSnackBar extends StatelessWidget {
  final String message;
  final SnackBarType type;
  final Duration duration;
  final VoidCallback? onAction;
  final String? actionLabel;
  final bool showCloseIcon;
  final VoidCallback? onClose;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? actionColor;
  final double? width;
  final double elevation;
  final ShapeBorder? shape;
  final SnackBarBehavior behavior;
  final Animation<double>? animation;
  final bool isVisible;

  const AnimatedSnackBar({
    Key? key,
    required this.message,
    this.type = SnackBarType.info,
    this.duration = const Duration(seconds: 4),
    this.onAction,
    this.actionLabel,
    this.showCloseIcon = true,
    this.onClose,
    this.margin = const EdgeInsets.all(8.0),
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    this.borderRadius = 8.0,
    this.backgroundColor,
    this.textColor,
    this.actionColor,
    this.width,
    this.elevation = 2.0,
    this.shape,
    this.behavior = SnackBarBehavior.floating,
    this.animation,
    this.isVisible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveBackgroundColor = backgroundColor ??
        _getBackgroundColor(type, isDark);
    final effectiveTextColor = textColor ??
        (isDark ? AppTheme.darkTextColor : Colors.white);
    final effectiveActionColor = actionColor ??
        (isDark ? AppTheme.darkTextColor : Colors.white);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isVisible ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        offset: Offset(0, isVisible ? 0 : 0.1),
        child: Container(
          width: width,
          margin: margin,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: effectiveBackgroundColor,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: padding,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        message,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: effectiveTextColor,
                        ),
                      ),
                    ),
                    if (actionLabel != null && onAction != null)
                      TextButton(
                        onPressed: onAction,
                        child: Text(
                          actionLabel!,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: effectiveActionColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (showCloseIcon)
                      IconButton(
                        icon: const Icon(Icons.close, size: 20.0),
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          onClose?.call();
                        },
                        color: effectiveTextColor,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
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

  Color _getBackgroundColor(SnackBarType type, bool isDark) {
    switch (type) {
      case SnackBarType.success:
        return isDark ? Colors.green[800]! : Colors.green;
      case SnackBarType.error:
        return isDark ? Colors.red[800]! : Colors.red;
      case SnackBarType.warning:
        return isDark ? Colors.orange[800]! : Colors.orange;
      case SnackBarType.info:
      default:
        return isDark ? AppTheme.darkSurfaceColor : AppTheme.primaryColor;
    }
  }
}

enum SnackBarType {
  success,
  error,
  warning,
  info,
}

class SnackBarService {
  static void show({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
    String? actionLabel,
    bool showCloseIcon = true,
    VoidCallback? onClose,
    EdgeInsetsGeometry margin = const EdgeInsets.all(8.0),
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    double borderRadius = 8.0,
    Color? backgroundColor,
    Color? textColor,
    Color? actionColor,
    double? width,
    double elevation = 2.0,
    ShapeBorder? shape,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    final snackBar = SnackBar(
      content: AnimatedSnackBar(
        message: message,
        type: type,
        duration: duration,
        onAction: onAction,
        actionLabel: actionLabel,
        showCloseIcon: showCloseIcon,
        onClose: onClose,
        margin: margin,
        padding: padding,
        borderRadius: borderRadius,
        backgroundColor: backgroundColor,
        textColor: textColor,
        actionColor: actionColor,
        width: width,
        elevation: elevation,
        shape: shape,
        behavior: behavior,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: behavior,
      duration: duration,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.success,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.error,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.warning,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.info,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }
} 