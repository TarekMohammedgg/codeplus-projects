import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/formatters.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/models/booking_draft.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

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
    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 26, 20, 73),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Assets.assetsDesignThanks, width: 156, height: 156),
            12.verticalSpace,
            Text(
              context.tr.thankYou,
              style: context.medium36TextMain.copyWith(fontSize: 38),
              textAlign: TextAlign.center,
            ),
            5.verticalSpace,
            Text(
              context.tr.appointmentSuccessful,
              style: context.regular20TextSecondary,
              textAlign: TextAlign.center,
            ),
            28.verticalSpace,
            Text(
              context.tr.appointmentBookedWith(
                name: draft.doctor.name,
                date: DateFormat.MMMMd(
                  context.localeCode,
                ).format(draft.startAt),
                time: formatTime(draft.startAt, context.localeCode),
              ),
              style: context.regular14TextSecondary.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
            32.verticalSpace,
            AppPrimaryButton(
              label: context.tr.done,
              onPressed: onDone,
              textStyle: context.medium18White,
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        ),
      ),
    );
  }
}
