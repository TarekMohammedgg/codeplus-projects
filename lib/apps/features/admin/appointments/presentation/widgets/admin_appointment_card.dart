import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AdminAppointmentCard extends StatelessWidget {
  const AdminAppointmentCard({
    super.key,
    required this.appointment,
    this.specialty,
    this.onTap,
  });

  final AppointmentModel appointment;
  final SpecialtyModel? specialty;
  final VoidCallback? onTap;

  String _formatDateTime(BuildContext context, DateTime dateTime) {
    try {
      final locale = Localizations.localeOf(context).toString();
      return DateFormat('EEE, d MMM · hh:mm a', locale).format(dateTime);
    } catch (_) {
      return DateFormat('EEE, d MMM · hh:mm a').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (appointment.status) {
      AppointmentStatus.upcoming => AppColors.primary,
      AppointmentStatus.completed => AppColors.primary,
      AppointmentStatus.cancelled => AppColors.error,
    };

    final statusText = switch (appointment.status) {
      AppointmentStatus.upcoming => context.tr.statusUpcoming,
      AppointmentStatus.completed => context.tr.statusCompleted,
      AppointmentStatus.cancelled => context.tr.statusCancelled,
    };

    final specialtyTitle = specialty?.localizedName ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 12,
            offset: Offset(0, 3),
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
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: appointment.doctorImageUrl != null
                            ? DoctorImage(
                                imageUrl: appointment.doctorImageUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                fallback: const DoctorAvatarPlaceholder(
                                  size: 50,
                                ),
                              )
                            : const DoctorAvatarPlaceholder(size: 50),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.doctorName,
                            style: context.semiBold16TextMain,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (specialtyTitle.isNotEmpty) ...[
                            2.verticalSpace,
                            Text(
                              specialtyTitle,
                              style: context.regular12TextSecondary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          6.verticalSpace,
                          // Patient name
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceMuted,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              context.tr.patientNameLabel(
                                name: appointment.patientName,
                              ),
                              style: context.medium12TextSecondary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statusText,
                        style: context.semiBold12Primary.copyWith(
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                12.verticalSpace,
                const Divider(color: AppColors.outlineSoft, height: 1),
                10.verticalSpace,
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    6.horizontalSpace,
                    Expanded(
                      child: Text(
                        _formatDateTime(context, appointment.startAt),
                        style: context.medium12TextSecondary,
                      ),
                    ),
                    if (appointment.fee > 0)
                      Text(
                        '\$${appointment.fee.toStringAsFixed(0)}',
                        style: context.semiBold14TextMain,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
