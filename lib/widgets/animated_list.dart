import 'package:flutter/material.dart';
import 'package:tahania_app/config/animations/app_animations.dart';
import 'package:tahania_app/config/theme/app_theme.dart';

class AnimatedList extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final bool primary;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;
  final bool reverse;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final bool enableStaggeredAnimation;
  final Duration staggeredAnimationDuration;
  final Curve staggeredAnimationCurve;

  const AnimatedList({
    Key? key,
    required this.children,
    this.padding = EdgeInsets.zero,
    this.spacing = 8.0,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.primary = false,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.reverse = false,
    this.emptyWidget,
    this.loadingWidget,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.onRetry,
    this.enableStaggeredAnimation = true,
    this.staggeredAnimationDuration = const Duration(milliseconds: 300),
    this.staggeredAnimationCurve = Curves.easeInOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: loadingWidget ?? const CircularProgressIndicator(),
      );
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              errorMessage ?? 'حدث خطأ',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.errorColor,
                  ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ],
        ),
      );
    }

    if (children.isEmpty) {
      return Center(
        child: emptyWidget ??
            Text(
              'لا توجد بيانات',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
            ),
      );
    }

    return ListView.separated(
      padding: padding,
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      primary: primary,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      reverse: reverse,
      itemCount: children.length,
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        final child = children[index];
        if (enableStaggeredAnimation) {
          return AppAnimations.staggeredListItem(
            index: index,
            child: child,
          );
        }
        return child;
      },
    );
  }
}

class AnimatedGrid extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final bool primary;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;
  final bool reverse;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final bool enableStaggeredAnimation;
  final Duration staggeredAnimationDuration;
  final Curve staggeredAnimationCurve;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final double mainAxisExtent;
  final bool reverseGrid;

  const AnimatedGrid({
    Key? key,
    required this.children,
    this.padding = EdgeInsets.zero,
    this.spacing = 8.0,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.primary = false,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.reverse = false,
    this.emptyWidget,
    this.loadingWidget,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.onRetry,
    this.enableStaggeredAnimation = true,
    this.staggeredAnimationDuration = const Duration(milliseconds: 300),
    this.staggeredAnimationCurve = Curves.easeInOut,
    required this.crossAxisCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
    this.mainAxisExtent = 0.0,
    this.reverseGrid = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: loadingWidget ?? const CircularProgressIndicator(),
      );
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              errorMessage ?? 'حدث خطأ',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.errorColor,
                  ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ],
        ),
      );
    }

    if (children.isEmpty) {
      return Center(
        child: emptyWidget ??
            Text(
              'لا توجد بيانات',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
            ),
      );
    }

    return GridView.builder(
      padding: padding,
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      primary: primary,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      reverse: reverse,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
        mainAxisExtent: mainAxisExtent,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) {
        final child = children[index];
        if (enableStaggeredAnimation) {
          return AppAnimations.staggeredListItem(
            index: index,
            child: child,
          );
        }
        return child;
      },
    );
  }
} 