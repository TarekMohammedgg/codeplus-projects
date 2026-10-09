import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';

/// Circular profile photo; shows a person icon when there is no photo.
class AppProfileAvatar extends StatelessWidget {
  const AppProfileAvatar({
    super.key,
    required this.imageUrl,
    this.onTap,
    this.radius = 16,
  });

  final String? imageUrl;
  final VoidCallback? onTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: ClipOval(
        child: DoctorImage(
          imageUrl: imageUrl,
          width: size,
          height: size,
          fallback: DoctorAvatarPlaceholder(size: size),
        ),
      ),
    );
  }
}
