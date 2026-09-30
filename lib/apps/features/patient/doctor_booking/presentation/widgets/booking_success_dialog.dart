import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/models/booking_draft.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

/// Shown after the appointment is saved. [onDone] leads to My Appointments.
class BookingSuccessDialog extends StatelessWidget {
  const BookingSuccessDialog({
    super.key,
    required this.draft,
    required this.onDone,
  });

  final BookingDraft draft;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final locale = context.tr.$meta.locale.languageCode;
    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Assets.assetsDesignThanks, width: 120, height: 120),
            24.verticalSpace,
            Text(
              context.tr.thankYou,
              style: context.bold28TextMain,
              textAlign: TextAlign.center,
            ),
            8.verticalSpace,
            Text(
              context.tr.appointmentSuccessful,
              style: context.semiBold16TextSecondary,
              textAlign: TextAlign.center,
            ),
            18.verticalSpace,
            Text(
              context.tr.appointmentBookedWith(
                name: draft.doctor.name,
                date: DateFormat.yMMMEd(locale).format(draft.startAt),
                time: DateFormat.jm(locale).format(draft.startAt),
              ),
              style: context.regular14TextSecondary.copyWith(height: 1.45),
              textAlign: TextAlign.center,
            ),
            12.verticalSpace,
            Text(
              context.tr.bookingStatusUpcoming,
              style: context.semiBold14Primary,
              textAlign: TextAlign.center,
            ),
            28.verticalSpace,
            AppPrimaryButton(
              label: context.tr.done,
              onPressed: onDone,
              height: 52,
            ),
          ],
        ),
      ),
    );
  }
}
