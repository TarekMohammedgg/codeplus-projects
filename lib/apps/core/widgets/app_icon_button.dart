import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    this.child,
    this.icon,
    this.onTap,
    this.width = 38,
    this.height = 38,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.padding,
    this.margin,
    this.tooltip,
    this.iconSize = 16,
    this.iconColor,
    this.alignment = Alignment.center,
  });

  const AppIconButton.back({
    super.key,
    this.onTap,
    this.width = 38,
    this.height = 38,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.padding,
    this.margin,
    this.tooltip,
    this.iconSize = 16,
    this.iconColor,
    this.alignment = Alignment.center,
  }) : child = null,
       icon = Icons.arrow_back_ios_new_rounded;

  final Widget? child;
  final IconData? icon;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final String? tooltip;
  final double iconSize;
  final Color? iconColor;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(10);
    final effectiveBackgroundColor = backgroundColor ?? AppColors.surface;
    final effectiveBoxShadow =
        boxShadow ??
        const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ];

    final effectiveChild =
        child ??
        (icon != null
            ? Icon(
                icon,
                size: iconSize,
                color: iconColor ?? AppColors.textSecondary,
              )
            : null);

    Widget content = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        border: border,
        boxShadow: effectiveBoxShadow.isEmpty ? null : effectiveBoxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius is BorderRadius
              ? effectiveBorderRadius
              : BorderRadius.circular(10),
          child: padding != null
              ? Padding(
                  padding: padding!,
                  child: Align(alignment: alignment, child: effectiveChild),
                )
              : Align(alignment: alignment, child: effectiveChild),
        ),
      ),
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      content = Tooltip(message: tooltip!, child: content);
    }

    return content;
  }
}
