import 'package:flutter/material.dart';
import 'package:tahania_app/config/theme/app_theme.dart';

class AnimatedBottomNavigationBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final double height;
  final double iconSize;
  final double fontSize;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final bool showLabels;
  final bool enableAnimation;
  final Duration animationDuration;
  final Curve animationCurve;
  final double elevation;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry padding;
  final bool isFloating;
  final double? width;
  final double borderRadius;
  final bool showSelectedLabels;
  final bool showUnselectedLabels;
  final BottomNavigationBarType type;
  final double selectedFontSize;
  final double unselectedFontSize;
  final FontWeight selectedFontWeight;
  final FontWeight unselectedFontWeight;

  const AnimatedBottomNavigationBar({
    Key? key,
    required this.items,
    required this.selectedIndex,
    required this.onTap,
    this.height = 56.0,
    this.iconSize = 24.0,
    this.fontSize = 12.0,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.showLabels = true,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.elevation = 8.0,
    this.shape,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.isFloating = false,
    this.width,
    this.borderRadius = 16.0,
    this.showSelectedLabels = true,
    this.showUnselectedLabels = true,
    this.type = BottomNavigationBarType.fixed,
    this.selectedFontSize = 12.0,
    this.unselectedFontSize = 12.0,
    this.selectedFontWeight = FontWeight.bold,
    this.unselectedFontWeight = FontWeight.normal,
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

    Widget navigationBar = Container(
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: elevation,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
          (index) {
            final isSelected = index == selectedIndex;
            final item = items[index];

            return GestureDetector(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: animationDuration,
                curve: animationCurve,
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: isSelected ? effectiveSelectedColor.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      size: iconSize,
                      color: isSelected ? effectiveSelectedColor : effectiveUnselectedColor,
                    ),
                    if (showLabels && (isSelected ? showSelectedLabels : showUnselectedLabels)) ...[
                      const SizedBox(height: 4.0),
                      AnimatedDefaultTextStyle(
                        duration: animationDuration,
                        curve: animationCurve,
                        style: TextStyle(
                          color: isSelected ? effectiveSelectedColor : effectiveUnselectedColor,
                          fontSize: isSelected ? selectedFontSize : unselectedFontSize,
                          fontWeight: isSelected ? selectedFontWeight : unselectedFontWeight,
                        ),
                        child: Text(
                          item.label ?? '',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    if (isFloating) {
      navigationBar = Padding(
        padding: const EdgeInsets.all(16.0),
        child: navigationBar,
      );
    }

    return navigationBar;
  }
}

class AnimatedBottomNavigationBarController extends StatefulWidget {
  final List<BottomNavigationBarItem> items;
  final List<Widget> children;
  final int initialIndex;
  final double height;
  final double iconSize;
  final double fontSize;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final bool showLabels;
  final bool enableAnimation;
  final Duration animationDuration;
  final Curve animationCurve;
  final double elevation;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry padding;
  final bool isFloating;
  final double? width;
  final double borderRadius;
  final bool showSelectedLabels;
  final bool showUnselectedLabels;
  final BottomNavigationBarType type;
  final double selectedFontSize;
  final double unselectedFontSize;
  final FontWeight selectedFontWeight;
  final FontWeight unselectedFontWeight;

  const AnimatedBottomNavigationBarController({
    Key? key,
    required this.items,
    required this.children,
    this.initialIndex = 0,
    this.height = 56.0,
    this.iconSize = 24.0,
    this.fontSize = 12.0,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.showLabels = true,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.elevation = 8.0,
    this.shape,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.isFloating = false,
    this.width,
    this.borderRadius = 16.0,
    this.showSelectedLabels = true,
    this.showUnselectedLabels = true,
    this.type = BottomNavigationBarType.fixed,
    this.selectedFontSize = 12.0,
    this.unselectedFontSize = 12.0,
    this.selectedFontWeight = FontWeight.bold,
    this.unselectedFontWeight = FontWeight.normal,
  }) : super(key: key);

  @override
  State<AnimatedBottomNavigationBarController> createState() =>
      _AnimatedBottomNavigationBarControllerState();
}

class _AnimatedBottomNavigationBarControllerState
    extends State<AnimatedBottomNavigationBarController> {
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
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: widget.children,
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        items: widget.items,
        selectedIndex: _selectedIndex,
        onTap: _onTap,
        height: widget.height,
        iconSize: widget.iconSize,
        fontSize: widget.fontSize,
        backgroundColor: widget.backgroundColor,
        selectedColor: widget.selectedColor,
        unselectedColor: widget.unselectedColor,
        showLabels: widget.showLabels,
        enableAnimation: widget.enableAnimation,
        animationDuration: widget.animationDuration,
        animationCurve: widget.animationCurve,
        elevation: widget.elevation,
        shape: widget.shape,
        padding: widget.padding,
        isFloating: widget.isFloating,
        width: widget.width,
        borderRadius: widget.borderRadius,
        showSelectedLabels: widget.showSelectedLabels,
        showUnselectedLabels: widget.showUnselectedLabels,
        type: widget.type,
        selectedFontSize: widget.selectedFontSize,
        unselectedFontSize: widget.unselectedFontSize,
        selectedFontWeight: widget.selectedFontWeight,
        unselectedFontWeight: widget.unselectedFontWeight,
      ),
    );
  }
} 