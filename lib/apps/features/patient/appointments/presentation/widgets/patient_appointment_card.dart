import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/formatters.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/appointment_info_tile.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/core/widgets/appointment_status_chip.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

const _actionHeight = 36.0;
const _actionRadius = BorderRadius.all(Radius.circular(6));

class PatientAppointmentCard extends StatelessWidget {
  const PatientAppointmentCard({
    super.key,
    required this.appointment,
    this.specialtyName,
    this.onViewDetails,
    this.onCancel,
    this.onRate,
  });

  final AppointmentModel appointment;
  final String? specialtyName;
  final VoidCallback? onViewDetails;
  final VoidCallback? onCancel;
  final VoidCallback? onRate;

  @override
  Widget build(BuildContext context) {
    final canRate =
        appointment.status == AppointmentStatus.completed &&
        !appointment.isReviewed;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: AppColors.shadowElevated, blurRadius: 20),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox.square(
                  dimension: 66,
                  child: DoctorImage(
                    imageUrl: appointment.doctorImageUrl,
                    fallback: const DoctorAvatarPlaceholder(circle: false),
                  ),
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctorName,
                      style: context.medium16TextMain,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (specialtyName?.isNotEmpty ?? false) ...[
                      5.verticalSpace,
                      Text(
                        specialtyName!,
                        style: context.light12TextSecondary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              10.horizontalSpace,
              AppointmentStatusChip(status: appointment.status),
            ],
          ),
          10.verticalSpace,
          const Divider(height: 1, color: AppColors.outlineSoft),
          10.verticalSpace,
          Row(
            children: [
              Expanded(
                child: AppointmentInfoTile(
                  icon: Icons.calendar_month_outlined,
                  label: context.tr.appointmentDate,
                  value: formatDate(appointment.startAt, context.localeCode),
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: AppointmentInfoTile(
                  icon: Icons.schedule_rounded,
                  label: context.tr.appointmentTime,
                  value: formatTime(appointment.startAt, context.localeCode),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          AppointmentInfoTile(
            icon: Icons.monetization_on_outlined,
            label: context.tr.consultationFee,
            value: formatFee(appointment.fee),
          ),
          if (canRate) ...[10.verticalSpace, _RatingPrompt(onTap: onRate)],
          if (appointment.status == AppointmentStatus.cancelled) ...[
            10.verticalSpace,
            Text(
              appointment.cancelledBy == CancelledBy.patient
                  ? context.tr.cancelledByYou
                  : context.tr.cancelledByClinic,
              style: context.regular10TextSecondary,
            ),
          ],
          10.verticalSpace,
          Row(
            children: [
              Expanded(
                child: AppPrimaryButton.outlined(
                  key: Key('view_details_button_${appointment.id}'),
                  label: context.tr.viewDetails,
                  onPressed: onViewDetails,
                  height: _actionHeight,
                  borderWidth: 1,
                  borderRadius: _actionRadius,
                  backgroundColor: AppColors.surface,
                  textStyle: context.medium12Primary,
                ),
              ),
              if (appointment.status == AppointmentStatus.upcoming &&
                  !appointment.hasStarted) ...[
                8.horizontalSpace,
                Expanded(
                  child: AppPrimaryButton.outlined(
                    key: Key('cancel_appointment_button_${appointment.id}'),
                    label: context.tr.cancelAppointment,
                    onPressed: onCancel,
                    height: _actionHeight,
                    borderWidth: 1,
                    borderRadius: _actionRadius,
                    backgroundColor: AppColors.errorLight,
                    foregroundColor: AppColors.error,
                    textStyle: context.medium12Error,
                  ),
                ),
              ] else if (canRate) ...[
                8.horizontalSpace,
                Expanded(
                  child: AppPrimaryButton(
                    key: Key('rate_doctor_button_${appointment.id}'),
                    label: context.tr.rateDoctor,
                    onPressed: onRate,
                    height: _actionHeight,
                    borderRadius: _actionRadius,
                    textStyle: context.medium12White,
                  ),
                ),
              ] else if (appointment.status == AppointmentStatus.completed) ...[
                8.horizontalSpace,
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      6.horizontalSpace,
                      Text(context.tr.reviewed, style: context.medium12Primary),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingPrompt extends StatelessWidget {
  const _RatingPrompt({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(6);

    return Material(
      color: AppColors.primaryLight,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: SizedBox(
          height: 30,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    context.tr.tapToRateYourVisit,
                    style: context.regular10TextSecondary,
                  ),
                ),
                for (var i = 0; i < 5; i++)
                  const Padding(
                    padding: EdgeInsetsDirectional.only(start: 4),
                    child: Icon(
                      Icons.star_border_rounded,
                      size: 15,
                      color: AppColors.rating,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
