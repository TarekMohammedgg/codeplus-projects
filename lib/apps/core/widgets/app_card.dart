import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/theme/app_theme.dart';

/// White rounded card with the soft shadow used across details screens.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  static const _radius = BorderRadius.all(Radius.circular(16));

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: _radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: _radius,
        child: onTap == null
            ? content
            : InkWell(onTap: onTap, borderRadius: _radius, child: content),
      ),
    );
  }
}
