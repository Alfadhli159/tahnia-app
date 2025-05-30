import 'package:flutter/material.dart';
import 'package:tahania_app/config/theme/app_theme.dart';

class AnimatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final ShapeBorder? shape;
  final double titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final bool automaticallyImplyLeading;
  final bool primary;
  final bool excludeHeaderSemantics;
  final double? leadingWidth;
  final TextStyle? titleTextStyle;
  final bool enableAnimation;
  final Duration animationDuration;
  final Curve animationCurve;

  const AnimatedAppBar({
    Key? key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.elevation = 0.0,
    this.backgroundColor,
    this.foregroundColor,
    this.height = kToolbarHeight,
    this.flexibleSpace,
    this.bottom,
    this.shape,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.automaticallyImplyLeading = true,
    this.primary = true,
    this.excludeHeaderSemantics = false,
    this.leadingWidth,
    this.titleTextStyle,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveBackgroundColor = backgroundColor ??
        (isDark ? AppTheme.darkSurfaceColor : AppTheme.surfaceColor);
    final effectiveForegroundColor = foregroundColor ??
        (isDark ? AppTheme.darkTextColor : AppTheme.textPrimaryColor);

    return AppBar(
      title: title != null
          ? AnimatedDefaultTextStyle(
              duration: animationDuration,
              curve: animationCurve,
              style: titleTextStyle ??
                  theme.textTheme.titleLarge?.copyWith(
                    color: effectiveForegroundColor,
                    fontWeight: FontWeight.bold,
                  ) ??
                  const TextStyle(),
              child: Text(title!),
            )
          : null,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      toolbarHeight: height,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      shape: shape,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      automaticallyImplyLeading: automaticallyImplyLeading,
      primary: primary,
      excludeHeaderSemantics: excludeHeaderSemantics,
      leadingWidth: leadingWidth,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height + (bottom?.preferredSize.height ?? 0.0));
}

class AnimatedSliverAppBar extends StatelessWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double expandedHeight;
  final bool floating;
  final bool pinned;
  final bool snap;
  final double elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final ShapeBorder? shape;
  final double titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final bool automaticallyImplyLeading;
  final bool primary;
  final bool excludeHeaderSemantics;
  final double? leadingWidth;
  final TextStyle? titleTextStyle;
  final bool enableAnimation;
  final Duration animationDuration;
  final Curve animationCurve;
  final double collapsedHeight;
  final double stretchMomentum;
  final double stretchTriggerOffset;
  final bool stretch;
  final double toolbarHeight;
  final double? leadingWidth;
  final bool forceElevated;
  final Color? shadowColor;
  final double? surfaceTintColor;

  const AnimatedSliverAppBar({
    Key? key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.expandedHeight = 200.0,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
    this.elevation = 0.0,
    this.backgroundColor,
    this.foregroundColor,
    this.flexibleSpace,
    this.bottom,
    this.shape,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.automaticallyImplyLeading = true,
    this.primary = true,
    this.excludeHeaderSemantics = false,
    this.leadingWidth,
    this.titleTextStyle,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.collapsedHeight = kToolbarHeight,
    this.stretchMomentum = 0.0,
    this.stretchTriggerOffset = 0.0,
    this.stretch = false,
    this.toolbarHeight = kToolbarHeight,
    this.forceElevated = false,
    this.shadowColor,
    this.surfaceTintColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveBackgroundColor = backgroundColor ??
        (isDark ? AppTheme.darkSurfaceColor : AppTheme.surfaceColor);
    final effectiveForegroundColor = foregroundColor ??
        (isDark ? AppTheme.darkTextColor : AppTheme.textPrimaryColor);

    return SliverAppBar(
      title: title != null
          ? AnimatedDefaultTextStyle(
              duration: animationDuration,
              curve: animationCurve,
              style: titleTextStyle ??
                  theme.textTheme.titleLarge?.copyWith(
                    color: effectiveForegroundColor,
                    fontWeight: FontWeight.bold,
                  ) ??
                  const TextStyle(),
              child: Text(title!),
            )
          : null,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      expandedHeight: expandedHeight,
      floating: floating,
      pinned: pinned,
      snap: snap,
      elevation: elevation,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      shape: shape,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      automaticallyImplyLeading: automaticallyImplyLeading,
      primary: primary,
      excludeHeaderSemantics: excludeHeaderSemantics,
      leadingWidth: leadingWidth,
      collapsedHeight: collapsedHeight,
      stretchMomentum: stretchMomentum,
      stretchTriggerOffset: stretchTriggerOffset,
      stretch: stretch,
      toolbarHeight: toolbarHeight,
      forceElevated: forceElevated,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
    );
  }
} 