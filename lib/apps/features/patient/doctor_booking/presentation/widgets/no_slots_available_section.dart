import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class NoSlotsAvailableSection extends StatelessWidget {
  const NoSlotsAvailableSection({
    super.key,
    required this.nextAvailableDateLabel,
    required this.onNextAvailabilityTap,
    required this.onContactClinicTap,
  });

  final String nextAvailableDateLabel;
  final VoidCallback onNextAvailabilityTap;
  final VoidCallback onContactClinicTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        8.verticalSpace,
        Text(
          context.tr.noSlotsAvailable,
          //CR hardcode textstyle
          // Solved
          style: context.regular14TextSecondary,
          textAlign: TextAlign.center,
        ),
        28.verticalSpace,
        AppPrimaryButton(
          label: context.tr.nextAvailabilityOn(date: nextAvailableDateLabel),
          onPressed: onNextAvailabilityTap,
          width: 306,
          height: 54,
          fontSize: 15,
          borderRadius: BorderRadius.circular(8),
        ),
        16.verticalSpace,
        Text(
          context.tr.or,
          //CR hardcode textstyle
          // Solved
          style: context.medium14TextSecondary,
          textAlign: TextAlign.center,
        ),
        16.verticalSpace,
        //CR use primary widget (any reuse widget)
        // Solved
        AppPrimaryButton.outlined(
          label: context.tr.contactClinic,
          onPressed: onContactClinicTap,
          width: 306,
          height: 54,
          backgroundColor: Colors.white,
          borderColor: AppColors.primary.withValues(alpha: 0.5),
          borderWidth: 1.2,
          borderRadius: BorderRadius.circular(8),
          textStyle: context.bold16Primary,
        ),
        24.verticalSpace,
      ],
    );
  }
}
