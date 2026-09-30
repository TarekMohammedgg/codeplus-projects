import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class NoSlotsAvailableSection extends StatelessWidget {
  const NoSlotsAvailableSection({
    super.key,
    this.nextAvailableDateLabel,
    this.onNextAvailabilityTap,
  });

  final String? nextAvailableDateLabel;
  final VoidCallback? onNextAvailabilityTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        8.verticalSpace,
        Text(
          context.tr.noSlotsAvailable,
          style: context.regular14TextSecondary,
          textAlign: TextAlign.center,
        ),
        if (nextAvailableDateLabel != null &&
            onNextAvailabilityTap != null) ...[
          24.verticalSpace,
          AppPrimaryButton(
            label: context.tr.nextAvailabilityOn(date: nextAvailableDateLabel!),
            onPressed: onNextAvailabilityTap,
            width: 306,
            height: 54,
            fontSize: 15,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
        24.verticalSpace,
      ],
    );
  }
}
