import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_button.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

/// Cancel / confirm dialog. Returns `true` only on confirm.
Future<bool> showAppConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  Color confirmColor = AppColors.primary,
  TextStyle? titleStyle,
  TextStyle? cancelTextStyle,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title, style: titleStyle ?? context.semiBold16TextMain),
      content: Text(message, style: context.regular14TextSecondary),
      actions: [
        AppTextButton(
          label: context.tr.cancel,
          onPressed: () => Navigator.of(dialogContext).pop(false),
          textStyle: cancelTextStyle ?? context.medium14TextSecondary,
        ),
        AppTextButton(
          label: confirmLabel,
          onPressed: () => Navigator.of(dialogContext).pop(true),
          foregroundColor: confirmColor,
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
