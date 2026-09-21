import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';

class DoctorAvatarPlaceholder extends StatelessWidget {
  const DoctorAvatarPlaceholder({
    super.key,
    this.size = 48,
    this.iconColor = AppColors.primary,
    //CR hardcode color
    this.backgroundColor = const Color(0xFFE8FBF6),
    this.circle = true,
    this.iconSize,
  });

  final double size;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool circle;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        //CR hardcode color
        color: backgroundColor ?? const Color(0xFFE8FBF6),
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          color: iconColor ?? AppColors.primary,
          size: iconSize ?? (size * 0.5),
        ),
      ),
    );
  }
}
