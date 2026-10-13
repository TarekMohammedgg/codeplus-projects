import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.avatarUrl,
    this.size = 130,
    this.borderWidth = 3,
    this.borderColor,
    this.boxShadow,
  });

  final String? avatarUrl;
  final double size;
  final double borderWidth;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor ?? Colors.white.withValues(alpha: 0.8),
          width: borderWidth,
        ),
        boxShadow:
            boxShadow ??
            const [
              BoxShadow(
                //CR hardcode color
                // Solved
                color: AppColors.shadowStrong,
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
      ),
      child: ClipOval(
        child: DoctorImage(
          imageUrl: avatarUrl,
          width: size,
          height: size,
          fallback: DoctorAvatarPlaceholder(size: size),
        ),
      ),
    );
  }
}
