import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../utils/performance_utils.dart';

class OptimizedListView extends StatelessWidget {
  final List<Widget> children;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final Widget? separator;

  const OptimizedListView({
    Key? key,
    required this.children,
    this.width,
    this.height,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.separator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PerformanceUtils.buildWithPerformance(
      child: ListView.separated(
        key: const ValueKey('optimized_list'),
        children: children,
        separatorBuilder: (context, index) => separator ?? const SizedBox(height: 8),
        padding: padding ?? const EdgeInsets.all(8),
        physics: physics ?? const BouncingScrollPhysics(),
        shrinkWrap: shrinkWrap,
        scrollDirection: scrollDirection,
      ),
      maintainState: true,
    );
  }
}
