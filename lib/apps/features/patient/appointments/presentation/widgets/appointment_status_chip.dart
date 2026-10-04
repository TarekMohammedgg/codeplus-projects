import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: ShapeDecoration(color: bgColor, shape: const StadiumBorder()),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 3, backgroundColor: color),
          5.horizontalSpace,
          Text(
            label,
            style: context.medium10TextMain.copyWith(color: color, fontSize: 9),
          ),
        ],
      ),
    );
  }
}
