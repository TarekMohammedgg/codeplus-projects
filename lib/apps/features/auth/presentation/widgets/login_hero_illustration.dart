import 'package:flutter/material.dart';

import 'package:medora/generated/image_assets.dart';

/// The supplied login reference contains the clinician artwork as part of the
/// screen composition rather than as a separate source asset. This bounded
/// crop keeps that artwork in the hero position while the surrounding screen
/// remains native Flutter UI.
class LoginHeroIllustration extends StatelessWidget {
  final double size;

  const LoginHeroIllustration({super.key, this.size = 130});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.assetsScreensDesignDoctorAvatarClean,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
