import 'package:flutter/material.dart';

import 'package:doctor_hunt/generated/style_atoms.dart';

/// Uppercase caption shown above a form field.
class AppFieldLabel extends StatelessWidget {
  const AppFieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: context.semiBold12TextMain.copyWith(letterSpacing: 0.5),
      ),
    );
  }
}
