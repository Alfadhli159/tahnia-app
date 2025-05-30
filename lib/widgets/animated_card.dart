import 'package:flutter/material.dart';
import 'package:tahania_app/config/animations/app_animations.dart';
import 'package:tahania_app/config/theme/app_theme.dart';

class AnimatedCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isSelected;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final double borderRadius;
  final Color? backgroundColor;
  final bool enableAnimation;

  const AnimatedCard({
    Key? key,
    required this.child,
    this.onTap,
    this.isSelected = false,
    this.padding = const EdgeInsets.all(16.0),
    this.elevation = 2.0,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.enableAnimation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor ?? theme.cardColor;

    Widget card = Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: isSelected
            ? BorderSide(color: AppTheme.primaryColor, width: 2.0)
            : BorderSide.none,
      ),
      color: effectiveBackgroundColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );

    if (enableAnimation) {
      card = AppAnimations.contactSelectionAnimation(
        child: card,
        isSelected: isSelected,
      );
    }

    return card;
  }
}

class AnimatedListCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isSelected;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final double borderRadius;
  final Color? backgroundColor;
  final int index;

  const AnimatedListCard({
    Key? key,
    required this.child,
    required this.index,
    this.onTap,
    this.isSelected = false,
    this.padding = const EdgeInsets.all(16.0),
    this.elevation = 2.0,
    this.borderRadius = 12.0,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppAnimations.staggeredListItem(
      index: index,
      child: AnimatedCard(
        onTap: onTap,
        isSelected: isSelected,
        padding: padding,
        elevation: elevation,
        borderRadius: borderRadius,
        backgroundColor: backgroundColor,
        child: child,
      ),
    );
  }
}

class AnimatedMessageCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isVisible;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final double borderRadius;
  final Color? backgroundColor;

  const AnimatedMessageCard({
    Key? key,
    required this.child,
    required this.isVisible,
    this.onTap,
    this.padding = const EdgeInsets.all(16.0),
    this.elevation = 2.0,
    this.borderRadius = 12.0,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppAnimations.messageAnimation(
      isVisible: isVisible,
      child: AnimatedCard(
        onTap: onTap,
        padding: padding,
        elevation: elevation,
        borderRadius: borderRadius,
        backgroundColor: backgroundColor,
        child: child,
      ),
    );
  }
} 