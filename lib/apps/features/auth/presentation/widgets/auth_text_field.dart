import 'package:flutter/material.dart';

import 'package:medora/generated/app_strings.dart';
import 'package:medora/generated/app_styles.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String semanticLabel;
  final String? hintText;
  final IconData prefixIcon;
  final Color iconColor;
  final bool isPassword;
  final double minHeight;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.semanticLabel,
    required this.prefixIcon,
    this.hintText,
    this.iconColor = AppStyles.primaryBlue,
    this.isPassword = false,
    this.minHeight = AppStyles.fieldHeight,
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
    return Semantics(
      textField: true,
      label: widget.semanticLabel,
      child: TextFormField(
        controller: widget.controller,
        obscureText: obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        autofillHints: widget.autofillHints,
        validator: widget.validator,
        onChanged: widget.onChanged,
        autocorrect: !widget.isPassword,
        enableSuggestions: !widget.isPassword,
        style: const TextStyle(
          color: AppStyles.navy,
          fontSize: 16,
          height: 1.25,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppStyles.body.copyWith(
            color: AppStyles.navy.withValues(alpha: 0.9),
            fontSize: 16,
            height: 1.25,
          ),
          prefixIcon: Icon(widget.prefixIcon, color: widget.iconColor),
          suffixIcon: widget.isPassword
              ? IconButton(
                  key: Key('${widget.semanticLabel}-visibility-button'),
                  onPressed: () {
                    setState(() => obscureText = !obscureText);
                  },
                  color: AppStyles.textSecondary,
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  tooltip: obscureText
                      ? AppStrings.showPassword
                      : AppStrings.hidePassword,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          errorMaxLines: 2,
        ),
      ),
    );
  }
}
