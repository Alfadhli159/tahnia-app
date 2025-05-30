import 'package:flutter/material.dart';
import 'package:tahania_app/config/animations/app_animations.dart';
import 'package:tahania_app/config/theme/app_theme.dart';

class AnimatedDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final bool barrierDismissible;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final double? width;
  final double? height;
  final AlignmentGeometry alignment;
  final bool showCloseButton;
  final VoidCallback? onClose;

  const AnimatedDialog({
    Key? key,
    this.title,
    required this.content,
    this.actions,
    this.barrierDismissible = true,
    this.backgroundColor,
    this.borderRadius = 12.0,
    this.contentPadding = const EdgeInsets.all(16.0),
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.showCloseButton = true,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveBackgroundColor = backgroundColor ??
        (isDark ? AppTheme.darkSurfaceColor : AppTheme.surfaceColor);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null || showCloseButton)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    if (title != null)
                      Expanded(
                        child: Text(
                          title!,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: isDark ? AppTheme.darkTextColor : AppTheme.textPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (showCloseButton)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                          onClose?.call();
                        },
                        color: isDark ? AppTheme.darkTextColor : AppTheme.textSecondaryColor,
                      ),
                  ],
                ),
              ),
            Flexible(
              child: SingleChildScrollView(
                padding: contentPadding,
                child: content,
              ),
            ),
            if (actions != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AnimatedAlertDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final List<Widget>? actions;
  final bool barrierDismissible;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final double? width;
  final double? height;
  final AlignmentGeometry alignment;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;

  const AnimatedAlertDialog({
    Key? key,
    this.title,
    this.content,
    this.actions,
    this.barrierDismissible = true,
    this.backgroundColor,
    this.borderRadius = 12.0,
    this.contentPadding = const EdgeInsets.all(16.0),
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.showCloseButton = true,
    this.onClose,
    this.titleStyle,
    this.contentStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedDialog(
      title: title,
      content: Text(
        content ?? '',
        style: contentStyle ??
            theme.textTheme.bodyLarge?.copyWith(
              color: isDark ? AppTheme.darkTextColor : AppTheme.textPrimaryColor,
            ),
      ),
      actions: actions,
      barrierDismissible: barrierDismissible,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      contentPadding: contentPadding,
      width: width,
      height: height,
      alignment: alignment,
      showCloseButton: showCloseButton,
      onClose: onClose,
    );
  }
}

class AnimatedBottomSheet extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final bool isDismissible;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final double? height;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final bool enableDrag;
  final bool isScrollControlled;

  const AnimatedBottomSheet({
    Key? key,
    this.title,
    required this.content,
    this.actions,
    this.isDismissible = true,
    this.backgroundColor,
    this.borderRadius = 12.0,
    this.contentPadding = const EdgeInsets.all(16.0),
    this.height,
    this.showCloseButton = true,
    this.onClose,
    this.enableDrag = true,
    this.isScrollControlled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveBackgroundColor = backgroundColor ??
        (isDark ? AppTheme.darkSurfaceColor : AppTheme.surfaceColor);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (enableDrag)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              width: 40.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkTextColor.withOpacity(0.3) : AppTheme.textLightColor,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          if (title != null || showCloseButton)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: isDark ? AppTheme.darkTextColor : AppTheme.textPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (showCloseButton)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onClose?.call();
                      },
                      color: isDark ? AppTheme.darkTextColor : AppTheme.textSecondaryColor,
                    ),
                ],
              ),
            ),
          Flexible(
            child: SingleChildScrollView(
              padding: contentPadding,
              child: content,
            ),
          ),
          if (actions != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!,
              ),
            ),
        ],
      ),
    );
  }
} 