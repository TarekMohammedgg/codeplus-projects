import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AuthTextField extends StatefulWidget {
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
    this.iconColor = AppColors.primaryGreen,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.onChanged,
  });

  @override
  State<AuthTextField> createState() => AuthTextFieldState();
}

class AuthTextFieldState extends State<AuthTextField> {
  late bool obscureText = widget.isPassword;

  @override
  void didUpdateWidget(covariant AuthTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPassword != widget.isPassword) {
      obscureText = widget.isPassword;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      validator: widget.validator,
      onChanged: widget.onChanged,
      autocorrect: !widget.isPassword,
      enableSuggestions: !widget.isPassword,
      style: context.regular16TextMain.copyWith(height: 1.25),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: context.regular16TextMain.copyWith(
          color: AppColors.textMain.withValues(alpha: 0.9),
          height: 1.25,
        ),
        prefixIcon: Icon(widget.prefixIcon, color: widget.iconColor),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() => obscureText = !obscureText);
                },
                color: AppColors.textSecondary,
                icon: Icon(
                  obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                tooltip: obscureText
                    ? context.t.showPassword
                    : context.t.hidePassword,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        errorMaxLines: 2,
      ),
    );
  }
}
