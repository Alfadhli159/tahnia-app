import 'package:flutter/material.dart';
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
    super.key,
    required this.children,
    this.width,
    this.height,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.separator,
  });

  @override
  Widget build(BuildContext context) => PerformanceUtils.buildWithPerformance(
      child: separator != null
          ? ListView.separated(
              key: const ValueKey('optimized_list'),
              itemCount: children.length,
              itemBuilder: (context, index) => children[index],
              separatorBuilder: (context, index) => separator!,
              padding: padding ?? const EdgeInsets.all(8),
              physics: physics ?? const BouncingScrollPhysics(),
              shrinkWrap: shrinkWrap,
              scrollDirection: scrollDirection,
            )
          : ListView(
              key: const ValueKey('optimized_list'),
              padding: padding ?? const EdgeInsets.all(8),
              physics: physics ?? const BouncingScrollPhysics(),
              shrinkWrap: shrinkWrap,
              scrollDirection: scrollDirection,
              children: children,
            ),
      maintainState: true,
    );
}
