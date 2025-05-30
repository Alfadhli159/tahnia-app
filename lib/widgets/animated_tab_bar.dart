import 'package:flutter/material.dart';
import 'package:tahania_app/config/theme/app_theme.dart';

class AnimatedTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final bool isScrollable;
  final EdgeInsetsGeometry padding;
  final double height;
  final double indicatorHeight;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final double fontSize;
  final FontWeight selectedFontWeight;
  final FontWeight unselectedFontWeight;
  final bool showIndicator;
  final bool enableAnimation;
  final Duration animationDuration;
  final Curve animationCurve;

  const AnimatedTabBar({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
    this.isScrollable = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.height = 48.0,
    this.indicatorHeight = 3.0,
    this.borderRadius = 8.0,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.fontSize = 16.0,
    this.selectedFontWeight = FontWeight.bold,
    this.unselectedFontWeight = FontWeight.normal,
    this.showIndicator = true,
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
    final effectiveSelectedColor = selectedColor ?? AppTheme.primaryColor;
    final effectiveUnselectedColor = unselectedColor ??
        (isDark ? AppTheme.darkTextColor.withOpacity(0.5) : AppTheme.textSecondaryColor);
    final effectiveIndicatorColor = indicatorColor ?? AppTheme.primaryColor;

    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: List.generate(
          tabs.length,
          (index) {
            final isSelected = index == selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (showIndicator && isSelected)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: AnimatedContainer(
                          duration: animationDuration,
                          curve: animationCurve,
                          height: indicatorHeight,
                          decoration: BoxDecoration(
                            color: effectiveIndicatorColor,
                            borderRadius: BorderRadius.circular(indicatorHeight / 2),
                          ),
                        ),
                      ),
                    AnimatedDefaultTextStyle(
                      duration: animationDuration,
                      curve: animationCurve,
                      style: TextStyle(
                        color: isSelected ? effectiveSelectedColor : effectiveUnselectedColor,
                        fontSize: fontSize,
                        fontWeight: isSelected ? selectedFontWeight : unselectedFontWeight,
                      ),
                      child: Text(
                        tabs[index],
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AnimatedTabBarView extends StatelessWidget {
  final List<Widget> children;
  final int selectedIndex;
  final bool enableAnimation;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool physics;

  const AnimatedTabBarView({
    Key? key,
    required this.children,
    required this.selectedIndex,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.physics = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: animationDuration,
      switchInCurve: animationCurve,
      switchOutCurve: animationCurve,
      child: children[selectedIndex],
    );
  }
}

class AnimatedTabController extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> children;
  final int initialIndex;
  final bool isScrollable;
  final EdgeInsetsGeometry padding;
  final double height;
  final double indicatorHeight;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final double fontSize;
  final FontWeight selectedFontWeight;
  final FontWeight unselectedFontWeight;
  final bool showIndicator;
  final bool enableAnimation;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool physics;

  const AnimatedTabController({
    Key? key,
    required this.tabs,
    required this.children,
    this.initialIndex = 0,
    this.isScrollable = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.height = 48.0,
    this.indicatorHeight = 3.0,
    this.borderRadius = 8.0,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.fontSize = 16.0,
    this.selectedFontWeight = FontWeight.bold,
    this.unselectedFontWeight = FontWeight.normal,
    this.showIndicator = true,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.physics = true,
  }) : super(key: key);

  @override
  State<AnimatedTabController> createState() => _AnimatedTabControllerState();
}

class _AnimatedTabControllerState extends State<AnimatedTabController> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedTabBar(
          tabs: widget.tabs,
          selectedIndex: _selectedIndex,
          onTap: _onTap,
          isScrollable: widget.isScrollable,
          padding: widget.padding,
          height: widget.height,
          indicatorHeight: widget.indicatorHeight,
          borderRadius: widget.borderRadius,
          backgroundColor: widget.backgroundColor,
          selectedColor: widget.selectedColor,
          unselectedColor: widget.unselectedColor,
          indicatorColor: widget.indicatorColor,
          fontSize: widget.fontSize,
          selectedFontWeight: widget.selectedFontWeight,
          unselectedFontWeight: widget.unselectedFontWeight,
          showIndicator: widget.showIndicator,
          enableAnimation: widget.enableAnimation,
          animationDuration: widget.animationDuration,
          animationCurve: widget.animationCurve,
        ),
        Expanded(
          child: AnimatedTabBarView(
            children: widget.children,
            selectedIndex: _selectedIndex,
            enableAnimation: widget.enableAnimation,
            animationDuration: widget.animationDuration,
            animationCurve: widget.animationCurve,
            physics: widget.physics,
          ),
        ),
      ],
    );
  }
} 