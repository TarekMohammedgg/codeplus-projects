import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        16.verticalSpace,
        SizedBox(
          width: 306,
          height: 54,
          child: OutlinedButton(
            onPressed: onContactClinicTap,
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.5),
                width: 1.2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              context.tr.contactClinic,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        24.verticalSpace,
      ],
    );
  }
}
