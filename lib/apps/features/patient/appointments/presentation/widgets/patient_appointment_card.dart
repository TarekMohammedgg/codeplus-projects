import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/presentation/widgets/appointment_status_chip.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class PatientAppointmentCard extends StatelessWidget {
  const PatientAppointmentCard({
    super.key,
    required this.appointment,
    this.specialtyName,
    this.onTap,
    this.onCancel,
    this.onRate,
  });

  final AppointmentModel appointment;
  final String? specialtyName;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onRate;

  @override
  Widget build(BuildContext context) {
    final locale = LocaleSettings.currentLocale.languageCode;
    final formattedDate = DateFormat.yMMMd(locale).format(appointment.startAt);
    final formattedTime = DateFormat.jm(locale).format(appointment.startAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 72,
                        height: 72,
                        child: DoctorImage(
                          imageUrl: appointment.doctorImageUrl,
                          fallback: const DoctorAvatarPlaceholder(
                            circle: false,
                          ),
                        ),
                      ),
                    ),
                    14.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  appointment.doctorName,
                                  style: context.semiBold16TextMain,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              8.horizontalSpace,
                              AppointmentStatusChip(status: appointment.status),
                            ],
                          ),
                          4.verticalSpace,
                          if (specialtyName != null &&
                              specialtyName!.isNotEmpty) ...[
                            Text(
                              specialtyName!,
                              style: context.regular12TextSecondary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            4.verticalSpace,
                          ],
                          Text(
                            '\$${appointment.fee.toStringAsFixed(0)}',
                            style: context.bold14Primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                14.verticalSpace,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      6.horizontalSpace,
                      Text(formattedDate, style: context.medium12TextMain),
                      const Spacer(),
                      const Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      6.horizontalSpace,
                      Text(formattedTime, style: context.medium12TextMain),
                    ],
                  ),
                ),
                if (appointment.status == AppointmentStatus.upcoming) ...[
                  14.verticalSpace,
                  AppPrimaryButton.outlined(
                    key: Key('cancel_appointment_button_${appointment.id}'),
                    height: 42,
                    fontSize: 14,
                    label: context.tr.cancelAppointment,
                    foregroundColor: AppColors.error,
                    borderColor: AppColors.error,
                    onPressed: onCancel,
                  ),
                ] else if (appointment.status ==
                    AppointmentStatus.completed) ...[
                  14.verticalSpace,
                  if (!appointment.isReviewed)
                    AppPrimaryButton(
                      key: Key('rate_doctor_button_${appointment.id}'),
                      height: 42,
                      fontSize: 14,
                      label: context.tr.rateDoctor,
                      icon: Icons.star_rounded,
                      onPressed: onRate,
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        6.horizontalSpace,
                        Text(
                          context.tr.reviewed,
                          style: context.medium14Primary,
                        ),
                      ],
                    ),
                ] else if (appointment.status ==
                    AppointmentStatus.cancelled) ...[
                  14.verticalSpace,
                  Text(
                    appointment.cancelledBy == CancelledBy.patient
                        ? context.tr.cancelledByYou
                        : context.tr.cancelledByClinic,
                    style: context.regular12TextSecondary.copyWith(
                      color: AppColors.error,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
