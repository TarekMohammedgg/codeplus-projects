import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AppSegmentedTabBar extends StatelessWidget {
  const AppSegmentedTabBar({
    super.key,
    required this.labels,
    this.controller,
    this.onTap,
  });

  final List<String> labels;
  final TabController? controller;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(8);
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: radius,
      ),
      child: TabBar(
        controller: controller,
        onTap: onTap,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: radius,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppColors.transparent,
        labelColor: AppColors.white,
        unselectedLabelColor: AppColors.primary,
        labelStyle: context.medium12White,
        unselectedLabelStyle: context.regular12Primary,
        labelPadding: EdgeInsets.zero,
        tabs: [for (final label in labels) Tab(text: label)],
      ),
    );
  }
}
