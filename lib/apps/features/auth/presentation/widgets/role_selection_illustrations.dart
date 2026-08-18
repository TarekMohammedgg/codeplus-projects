import 'package:flutter/material.dart';

import 'package:medora/generated/image_assets.dart';

class RolePatientIllustration extends StatelessWidget {
  final double size;

  const RolePatientIllustration({super.key, this.size = 130});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.assetsScreensDesignRolePatientClean,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

class RoleProviderIllustration extends StatelessWidget {
  final double size;

  const RoleProviderIllustration({super.key, this.size = 130});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.assetsScreensDesignRoleProviderClean,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
