import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/theme/app_theme.dart';

/// Filled red heart when [isFavorite], grey outline otherwise.
class FavoriteHeartIcon extends StatelessWidget {
  const FavoriteHeartIcon({
    super.key,
    required this.isFavorite,
    required this.size,
  });

  final bool isFavorite;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
      color: isFavorite ? AppColors.favorite : AppColors.disabled,
      size: size,
    );
  }
}
