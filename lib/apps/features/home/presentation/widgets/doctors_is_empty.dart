import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:flutter/material.dart';

class DoctorsIsEmpty extends StatelessWidget {
  const DoctorsIsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Center(
        child: Text(tr.noDoctorsFound, style: context.regular14TextSecondary),
      ),
    );
  }
}
