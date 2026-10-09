import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

/// Icon + label on the start, value on the end (date, time, fee rows).
class AppointmentDetailRow extends StatelessWidget {
  const AppointmentDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        10.horizontalSpace,
        Text(label, style: context.regular14TextSecondary),
        const Spacer(),
        Text(
          value,
          style: context.semiBold14TextMain.copyWith(
            color: valueColor ?? AppColors.textMain,
          ),
        ),
      ],
    );
  }
}
