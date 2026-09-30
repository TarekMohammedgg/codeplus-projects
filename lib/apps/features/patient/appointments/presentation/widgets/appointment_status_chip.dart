import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AppointmentStatusChip extends StatelessWidget {
  const AppointmentStatusChip({super.key, required this.status});

  final AppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bgColor, textColor) = switch (status) {
      AppointmentStatus.upcoming => (
        context.tr.statusUpcoming,
        AppColors.primary.withValues(alpha: 0.12),
        AppColors.primary,
      ),
      AppointmentStatus.completed => (
        context.tr.statusCompleted,
        const Color(0xFFE8F5E9),
        const Color(0xFF2E7D32),
      ),
      AppointmentStatus.cancelled => (
        context.tr.statusCancelled,
        AppColors.error.withValues(alpha: 0.12),
        AppColors.error,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: context.semiBold12TextMain.copyWith(color: textColor),
      ),
    );
  }
}
