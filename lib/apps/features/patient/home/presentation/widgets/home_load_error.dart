import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
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
            IconButton(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
                size: 28,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
