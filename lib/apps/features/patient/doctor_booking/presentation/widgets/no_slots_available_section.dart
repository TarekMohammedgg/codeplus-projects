import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/widgets/app_empty_state.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class NoSlotsAvailableSection extends StatelessWidget {
  const NoSlotsAvailableSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: context.tr.noSlotsAvailable,
      titleStyle: context.regular14TextSecondary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      imageWidth: 200,
      imageHeight: 200,
    );
  }
}
