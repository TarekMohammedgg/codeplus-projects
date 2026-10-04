import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Loading state for a list screen: the real list item, built with
/// placeholder data, repeated and skeletonized.
class AppListSkeleton extends StatelessWidget {
  const AppListSkeleton({
    super.key,
    required this.itemBuilder,
    this.itemCount = 5,
    this.padding,
    this.spacing = 0,
  });

  final WidgetBuilder itemBuilder;
  final int itemCount;
  final EdgeInsetsGeometry? padding;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: padding,
        itemCount: itemCount,
        separatorBuilder: (_, _) => SizedBox(height: spacing),
        itemBuilder: (context, _) => itemBuilder(context),
      ),
    );
  }
}
