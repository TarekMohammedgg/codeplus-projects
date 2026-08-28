import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

/// A standardized, reusable text field widget for the Doctor Hunt application.
///
/// Handles common patterns such as password visibility toggling, icon prefixes,
/// custom validation, content padding, and theme consistency across all screens.
class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final Color? prefixIconColor;
  final Widget? suffixIcon;
  final bool isPassword;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? minLines;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final int? errorMaxLines;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? style;
  final TextStyle? hintStyle;

  const AppTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.prefixWidget,
    this.prefixIconColor = AppColors.textSecondary,
    this.suffixIcon,
    this.isPassword = false,
    this.obscureText,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.maxLines = 1,
    this.minLines,
    this.fillColor,
    this.borderRadius,
    this.contentPadding,
    this.errorMaxLines = 2,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.style,
    this.hintStyle,
  });

  @override
  State<AppTextField> createState() => AppTextFieldState();
}

class AppTextFieldState extends State<AppTextField> {
  late bool _obscureText = widget.obscureText ?? widget.isPassword;

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPassword != widget.isPassword ||
        oldWidget.obscureText != widget.obscureText) {
      _obscureText = widget.obscureText ?? widget.isPassword;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? effectivePrefix;
    if (widget.prefixWidget != null) {
      effectivePrefix = widget.prefixWidget;
    } else if (widget.prefixIcon != null) {
      effectivePrefix = Icon(
        widget.prefixIcon,
        color: widget.prefixIconColor ?? AppColors.textSecondary,
      );
    }

    Widget? effectiveSuffix;
    if (widget.isPassword) {
      effectiveSuffix = IconButton(
        onPressed: () {
          setState(() => _obscureText = !_obscureText);
        },
        color: AppColors.textSecondary,
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
        tooltip: _obscureText ? tr.showPassword : tr.hidePassword,
      );
    } else {
      effectiveSuffix = widget.suffixIcon;
    }

    final effectiveMaxLines = widget.isPassword ? 1 : widget.maxLines;

    final border = widget.borderRadius != null
        ? OutlineInputBorder(
            borderRadius: widget.borderRadius!,
            borderSide: const BorderSide(color: AppColors.outline),
          )
        : null;

    final focusedBorder = widget.borderRadius != null
        ? OutlineInputBorder(
            borderRadius: widget.borderRadius!,
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          )
        : null;

    final errorBorder = widget.borderRadius != null
        ? OutlineInputBorder(
            borderRadius: widget.borderRadius!,
            borderSide: const BorderSide(color: AppColors.error),
          )
        : null;

    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      focusNode: widget.focusNode,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      maxLines: effectiveMaxLines,
      minLines: widget.minLines,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      autocorrect: !widget.isPassword,
      enableSuggestions: !widget.isPassword,
      style: widget.style ?? context.regular16TextMain.copyWith(height: 1.25),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle:
            widget.hintStyle ??
            context.regular16TextMain.copyWith(
              color: AppColors.textMain.withValues(alpha: 0.9),
              height: 1.25,
            ),
        prefixIcon: effectivePrefix,
        suffixIcon: effectiveSuffix,
        fillColor: widget.fillColor,
        contentPadding:
            widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        errorMaxLines: widget.errorMaxLines,
        border: border,
        enabledBorder: border,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
      ),
    );
  }
}
