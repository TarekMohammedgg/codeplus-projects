import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

/// A standardized, reusable primary button widget with built-in loading state,
/// outline styling, and icon support for the Doctor Hunt application.
class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final double fontSize;
  final IconData? icon;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final bool isOutlined;

  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 54,
    this.fontSize = 16,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth = 1.2,
    this.borderRadius,
    this.padding,
    this.textStyle,
  }) : isOutlined = false;

  const AppPrimaryButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 54,
    this.fontSize = 16,
    this.icon,
    this.isLoading = false,
    this.backgroundColor = AppColors.transparent,
    this.foregroundColor = AppColors.primary,
    this.borderColor,
    this.borderWidth = 1.2,
    this.borderRadius,
    this.padding,
    this.textStyle,
  }) : isOutlined = true;

  @override
  Widget build(BuildContext context) {
    final effectiveBg = isOutlined
        ? (backgroundColor ?? AppColors.transparent)
        : (backgroundColor ?? AppColors.primary);
    final effectiveFg = isOutlined
        ? (foregroundColor ?? AppColors.primary)
        : (foregroundColor ?? AppColors.white);

    final effectiveRadius = borderRadius ?? AppTheme.buttonRadius;
    final effectiveBorderSide = isOutlined
        ? BorderSide(color: borderColor ?? effectiveFg, width: borderWidth)
        : (borderColor != null
              ? BorderSide(color: borderColor!, width: borderWidth)
              : BorderSide.none);

    Widget buildButtonChild() {
      if (isLoading) {
        return SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(effectiveFg),
          ),
        );
      }
      if (icon != null) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: fontSize + 3, color: effectiveFg),
            const SizedBox(width: 8),
            Text(label),
          ],
        );
      }
      return Text(label);
    }

    return SizedBox(
      width: width,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: effectiveBg,
                foregroundColor: effectiveFg,
                disabledForegroundColor: effectiveFg.withValues(alpha: 0.6),
                padding: padding,
                side: effectiveBorderSide,
                shape: RoundedRectangleBorder(borderRadius: effectiveRadius),
                textStyle:
                    textStyle ??
                    context.semiBold16TextMain.copyWith(
                      fontSize: fontSize,
                      color: effectiveFg,
                    ),
                elevation: 0,
              ),
              child: buildButtonChild(),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: effectiveBg,
                disabledBackgroundColor: effectiveBg.withValues(alpha: 0.6),
                foregroundColor: effectiveFg,
                padding: padding,
                shape: RoundedRectangleBorder(
                  borderRadius: effectiveRadius,
                  side: effectiveBorderSide,
                ),
                textStyle:
                    textStyle ??
                    context.semiBold16White.copyWith(fontSize: fontSize),
                elevation: 0,
              ),
              child: buildButtonChild(),
            ),
    );
  }
}
