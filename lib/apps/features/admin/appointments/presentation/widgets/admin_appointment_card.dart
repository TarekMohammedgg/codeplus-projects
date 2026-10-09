import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/formatters.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/appointment_info_tile.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/appointment_status_chip.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

const _actionHeight = 36.0;
const _actionRadius = BorderRadius.all(Radius.circular(6));

class AdminAppointmentCard extends StatelessWidget {
  const AdminAppointmentCard({
    super.key,
    required this.appointment,
    this.specialty,
    this.onTap,
    this.onCancel,
    this.onMarkCompleted,
  });

  final AppointmentModel appointment;
  final SpecialtyModel? specialty;

  /// Opens the appointment details (card tap and "View Details").
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onMarkCompleted;

  @override
  Widget build(BuildContext context) {
    final specialtyTitle = specialty?.localizedName ?? '';
    final radius = BorderRadius.circular(10);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(color: AppColors.shadowElevated, blurRadius: 20),
        ],
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: DoctorAvatarPlaceholder(size: 48, circle: false),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.patientName,
                            style: context.medium16TextMain,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          2.verticalSpace,
                          Text(
                            appointment.doctorName,
                            style: context.medium12TextSecondary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (specialtyTitle.isNotEmpty) ...[
                            2.verticalSpace,
                            Text(
                              specialtyTitle,
                              style: context.light12TextSecondary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    8.horizontalSpace,
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
                        label: context.tr.dateLabel,
                        value: formatDate(
                          appointment.startAt,
                          context.localeCode,
                        ),
                      ),
                    ),
                    6.horizontalSpace,
                    Expanded(
                      child: AppointmentInfoTile(
                        icon: Icons.schedule_rounded,
                        label: context.tr.timeLabel,
                        value: formatTime(
                          appointment.startAt,
                          context.localeCode,
                        ),
                      ),
                    ),
                    6.horizontalSpace,
                    Expanded(
                      child: AppointmentInfoTile(
                        icon: Icons.monetization_on_outlined,
                        label: context.tr.feeLabel,
                        value: formatFee(appointment.fee),
                      ),
                    ),
                  ],
                ),
                12.verticalSpace,
                if (appointment.status == AppointmentStatus.upcoming)
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: AppPrimaryButton.outlined(
                          key: Key('admin_cancel_button_${appointment.id}'),
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
                      Expanded(
                        child: AppPrimaryButton(
                          key: Key('admin_complete_button_${appointment.id}'),
                          label: context.tr.markCompleted,
                          onPressed: onMarkCompleted,
                          height: _actionHeight,
                          borderRadius: _actionRadius,
                          textStyle: context.medium12White,
                        ),
                      ),
                    ],
                  )
                else
                  AppPrimaryButton.outlined(
                    key: Key('admin_view_details_button_${appointment.id}'),
                    label: context.tr.viewDetails,
                    onPressed: onTap,
                    height: _actionHeight,
                    borderWidth: 1,
                    borderRadius: _actionRadius,
                    backgroundColor: AppColors.surface,
                    textStyle: context.medium12Primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
