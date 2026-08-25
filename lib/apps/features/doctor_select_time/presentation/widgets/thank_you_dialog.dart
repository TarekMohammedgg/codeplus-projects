import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class ThankYouDialog extends StatelessWidget {
  const ThankYouDialog({
    super.key,
    required this.doctorName,
    required this.dateLabel,
    required this.timeSlot,
    this.onDone,
    this.onEdit,
  });

  final String doctorName;
  final String dateLabel;
  final String timeSlot;
  final VoidCallback? onDone;
  final VoidCallback? onEdit;

  static void show(
    BuildContext context, {
    required String doctorName,
    required String dateLabel,
    required String timeSlot,
    VoidCallback? onDone,
    VoidCallback? onEdit,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ThankYouDialog(
        doctorName: doctorName,
        dateLabel: dateLabel,
        timeSlot: timeSlot,
        onDone: onDone,
        onEdit: onEdit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Assets.assetsDesignThanks, width: 120, height: 120),
            24.verticalSpace,
            Text(
              tr.thankYou,
              style: context.bold28TextMain,
              textAlign: TextAlign.center,
            ),
            8.verticalSpace,
            Text(
              tr.appointmentSuccessful,
              style: context.semiBold16TextSecondary,
              textAlign: TextAlign.center,
            ),
            18.verticalSpace,
            Text(
              tr.appointmentBookedWith(
                name: doctorName,
                date: dateLabel,
                time: timeSlot,
              ),
              style: context.regular14TextSecondary.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.9),
                height: 1.45,
              ),
              textAlign: TextAlign.center,
            ),
            28.verticalSpace,
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed:
                    onDone ??
                    () {
                      Navigator.of(context).pop();
                      const HomeRoute().go(context);
                    },
                child: Text(tr.done, style: context.bold16White),
              ),
            ),
            14.verticalSpace,
            TextButton(
              onPressed: onEdit ?? () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: Text(
                tr.editYourAppointment,
                style: context.medium14TextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
