import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_card.dart';
import 'package:doctor_hunt/apps/core/widgets/appointment_detail_row.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

/// Date, time and fee of an appointment, separated by dividers.
/// [extraRows] (e.g. "cancelled by") are appended with the same spacing.
class AppointmentSummaryCard extends StatelessWidget {
  const AppointmentSummaryCard({
    super.key,
    required this.date,
    required this.time,
    required this.fee,
    this.extraRows = const [],
  });

  final String date;
  final String time;
  final String fee;
  final List<Widget> extraRows;

  @override
  Widget build(BuildContext context) {
    final rows = [
      AppointmentDetailRow(
        icon: Icons.calendar_today_outlined,
        label: context.tr.appointmentDate,
        value: date,
      ),
      AppointmentDetailRow(
        icon: Icons.access_time_rounded,
        label: context.tr.appointmentTime,
        value: time,
      ),
      AppointmentDetailRow(
        icon: Icons.payments_outlined,
        label: context.tr.consultationFee,
        value: fee,
        valueColor: AppColors.primary,
      ),
      ...extraRows,
    ];

    return AppCard(
      child: Column(
        children: [
          for (final (index, row) in rows.indexed) ...[
            if (index > 0) ...[
              12.verticalSpace,
              const Divider(height: 1, color: AppColors.outline),
              12.verticalSpace,
            ],
            row,
          ],
        ],
      ),
    );
  }
}
