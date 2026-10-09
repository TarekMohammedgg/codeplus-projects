import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.image,
    this.imagePath = Assets.assetsEmptyState,
    this.imageWidth = 160,
    this.imageHeight = 160,
    this.action,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
  });

  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;

  final Widget? image;
  final String imagePath;
  final double imageWidth;
  final double imageHeight;
  final Widget? action;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            image ??
                Image.asset(
                  imagePath,
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.contain,
                ),
            20.verticalSpace,
            Text(
              title,
              style: titleStyle ?? context.semiBold18TextMain,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              8.verticalSpace,
              Text(
                subtitle!,
                style: context.regular14TextSecondary,
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[24.verticalSpace, action!],
          ],
        ),
      ),
    );
  }
}
