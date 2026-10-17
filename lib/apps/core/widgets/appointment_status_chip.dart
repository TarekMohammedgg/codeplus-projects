import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_status_pill.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class AppointmentStatusChip extends StatelessWidget {
  const AppointmentStatusChip({super.key, required this.status});

  final AppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bgColor, color) = switch (status) {
      AppointmentStatus.upcoming => (
        context.tr.statusUpcoming,
        AppColors.primaryLight,
        AppColors.primary,
      ),
      AppointmentStatus.completed => (
        context.tr.statusCompleted,
        AppColors.primaryLight,
        AppColors.primary,
      ),
      AppointmentStatus.cancelled => (
        context.tr.statusCancelled,
        AppColors.errorLight,
        AppColors.error,
      ),
    };

    return AppStatusPill(label: label, color: color, backgroundColor: bgColor);
  }
}
