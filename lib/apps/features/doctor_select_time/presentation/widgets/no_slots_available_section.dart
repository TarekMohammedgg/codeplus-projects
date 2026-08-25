import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
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
          tr.noSlotsAvailable,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF677294),
          ),
          textAlign: TextAlign.center,
        ),
        28.verticalSpace,
        SizedBox(
          width: 306,
          height: 54,
          child: ElevatedButton(
            onPressed: onNextAvailabilityTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              tr.nextAvailabilityOn(date: nextAvailableDateLabel),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        16.verticalSpace,
        const Text(
          'OR',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF677294),
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
              side: const BorderSide(color: Color(0xFF8CE3C3), width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Contact Clinic',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0EBE7F),
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
