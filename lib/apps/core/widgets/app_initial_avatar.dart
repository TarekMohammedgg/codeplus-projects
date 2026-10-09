import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

/// Round badge with the first letter of [name] (admin header).
class AppInitialAvatar extends StatelessWidget {
  const AppInitialAvatar({
    super.key,
    required this.name,
    this.onTap,
    this.radius = 16,
  });

  final String name;
  final VoidCallback? onTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.primary,
        child: Text(
          trimmed.isEmpty ? '' : trimmed[0].toUpperCase(),
          style: context.bold14White,
        ),
      ),
    );
  }
}
