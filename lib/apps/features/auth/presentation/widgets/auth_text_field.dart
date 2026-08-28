import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_field.dart';

/// Auth-specific convenience wrapper around [AppTextField].
class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final IconData prefixIcon;
  final Color iconColor;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.prefixIcon,
    this.hintText,
    this.iconColor = AppColors.primary,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText,
      prefixIcon: prefixIcon,
      prefixIconColor: iconColor,
      isPassword: isPassword,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
