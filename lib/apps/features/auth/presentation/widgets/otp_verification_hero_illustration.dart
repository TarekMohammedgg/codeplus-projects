import 'package:flutter/material.dart';

import 'package:medora/generated/image_assets.dart';

/// Bounded crop for the OTP verification shield hero artwork from the supplied screen design.
class OtpVerificationHeroIllustration extends StatelessWidget {
  final double size;

  const OtpVerificationHeroIllustration({super.key, this.size = 170});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.assetsScreensDesignOtpShieldClean,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
