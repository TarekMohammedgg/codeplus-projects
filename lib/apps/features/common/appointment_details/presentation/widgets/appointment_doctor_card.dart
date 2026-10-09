import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/utils/formatters.dart';
import 'package:doctor_hunt/apps/core/widgets/app_card.dart';
import 'package:doctor_hunt/apps/core/widgets/appointment_status_chip.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

/// Doctor photo, name, status, specialty and fee at the top of the
/// patient and admin appointment details screens.
class AppointmentDoctorCard extends StatelessWidget {
  const AppointmentDoctorCard({
    super.key,
    required this.appointment,
    required this.specialtyName,
  });

  final AppointmentModel appointment;
  final String? specialtyName;

  @override
  Widget build(BuildContext context) {
    final specialty = specialtyName;
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 72,
              height: 72,
              child: DoctorImage(
                imageUrl: appointment.doctorImageUrl,
                fallback: const DoctorAvatarPlaceholder(circle: false),
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
                      ),
                    ),
                    8.horizontalSpace,
                    AppointmentStatusChip(status: appointment.status),
                  ],
                ),
                if (specialty != null && specialty.isNotEmpty) ...[
                  4.verticalSpace,
                  Text(specialty, style: context.regular12TextSecondary),
                ],
                8.verticalSpace,
                Text(formatFee(appointment.fee), style: context.bold14Primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
