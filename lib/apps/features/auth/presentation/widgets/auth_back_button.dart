import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class AuthBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool circular;

  const AuthBackButton({super.key, this.onPressed, this.circular = false});

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      onPressed:
          onPressed ??
          () {
            if (context.canPop()) {
              context.pop();
            } else {
              const OnboardingRoute().go(context);
            }
          },
      icon: const Icon(
        Icons.arrow_back_rounded,
        color: AppColors.textMain,
        size: 24,
      ),
      padding: EdgeInsets.zero,
      tooltip: context.t.back,
    );

    if (!circular) {
      return Align(alignment: Alignment.centerLeft, child: button);
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.outline.withAlpha(128)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C0C3268),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: button,
    );
  }
}
