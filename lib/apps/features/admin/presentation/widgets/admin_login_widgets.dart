import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';

class AdminLogo extends StatelessWidget {
  const AdminLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.admin_panel_settings_rounded,
          size: 38,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
