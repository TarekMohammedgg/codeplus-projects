import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';

/// Circular user photo with a person-icon fallback. [elevated] adds the white
/// ring and shadow used on the profile header.
class AppProfileAvatar extends StatelessWidget {
  const AppProfileAvatar({
    super.key,
    required this.imageUrl,
    this.onTap,
    this.size = 32,
    this.elevated = false,
  });

  final String? imageUrl;
  final VoidCallback? onTap;
  final double size;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: size,
        height: size,
        decoration: elevated
            ? BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.8),
                  width: 3,
                ),
                boxShadow: const [
                  BoxShadow(
                    //CR hardcode color
                    // Solved
                    color: AppColors.shadowStrong,
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              )
            : null,
        child: ClipOval(
          child: DoctorImage(
            imageUrl: imageUrl,
            width: size,
            height: size,
            fallback: DoctorAvatarPlaceholder(size: size),
          ),
        ),
      ),
    );
  }
}
