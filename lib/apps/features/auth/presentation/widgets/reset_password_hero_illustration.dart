import 'package:flutter/material.dart';

import 'package:medora/generated/image_assets.dart';

/// Bounded crop for the reset password lock hero artwork from the supplied screen design.
class ResetPasswordHeroIllustration extends StatelessWidget {
  final double size;

  const ResetPasswordHeroIllustration({super.key, this.size = 130});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.assetsScreensDesignResetLockCleanPng,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
