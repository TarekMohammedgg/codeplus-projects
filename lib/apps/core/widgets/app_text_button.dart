import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

/// A standardized, reusable text button widget with optional loading state
/// and icon support for the Doctor Hunt application.
class AppTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final IconData? icon;
  final double iconSize;
  final bool isLoading;
  final MaterialTapTargetSize? tapTargetSize;
  final Size? minimumSize;
  final AlignmentGeometry? alignment;

  const AppTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.textStyle,
    this.foregroundColor,
    this.padding,
    this.icon,
    this.iconSize = 18,
    this.isLoading = false,
    this.tapTargetSize,
    this.minimumSize,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveFg = foregroundColor ?? AppColors.primary;
    // Resolved once and set via TextButton's own `textStyle`, which
    // TextButton already applies to its child through DefaultTextStyle —
    // the label/icon below must not set their own style on top of it.
    final effectiveTextStyle = (textStyle ?? context.semiBold14).copyWith(
      color: effectiveFg,
    );

    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: effectiveFg,
        disabledForegroundColor: effectiveFg.withValues(alpha: 0.5),
        padding: padding,
        minimumSize: minimumSize,
        tapTargetSize: tapTargetSize,
        alignment: alignment,
        textStyle: effectiveTextStyle,
      ),
      child: isLoading
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(effectiveFg),
              ),
            )
          : icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: iconSize, color: effectiveFg),
                const SizedBox(width: 6),
                Text(label),
              ],
            )
          : Text(label),
    );
  }
}
