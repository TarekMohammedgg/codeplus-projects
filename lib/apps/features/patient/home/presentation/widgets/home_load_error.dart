import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:flutter/material.dart';

class HomeLoadError extends StatelessWidget {
  const HomeLoadError({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tr.serviceError,
              textAlign: TextAlign.center,
              style: context.semiBold16TextMain,
            ),
            const SizedBox(height: 12),
            AppIconButton(
              onTap: onRetry,
              icon: Icons.refresh_rounded,
              iconSize: 28,
              iconColor: AppColors.primary,
              width: 48,
              height: 48,
              tooltip: tr.retry,
            ),
          ],
        ),
      ),
    );
  }
}
