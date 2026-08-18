import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medora/generated/app_strings.dart';
import 'package:medora/generated/app_styles.dart';

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
              context.go('/');
            }
          },
      icon: const Icon(
        Icons.arrow_back_rounded,
        color: AppStyles.navy,
        size: 24,
      ),
      padding: EdgeInsets.zero,
      tooltip: AppStrings.back,
    );

    if (!circular) {
      return Align(alignment: Alignment.centerLeft, child: button);
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppStyles.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppStyles.outline.withAlpha(128)),
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
