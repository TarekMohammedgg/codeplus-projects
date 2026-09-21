import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';

class AuthHeroIllustration extends StatelessWidget {
  const AuthHeroIllustration({
    super.key,
    required this.icon,
    required this.size,
  });

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(icon, size: size * 0.5, color: AppColors.primary),
      ),
    );
  }
}
