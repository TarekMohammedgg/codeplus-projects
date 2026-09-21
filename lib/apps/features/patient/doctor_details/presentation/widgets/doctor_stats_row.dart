import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class DoctorStatsRow extends StatelessWidget {
  const DoctorStatsRow({
    super.key,
    required this.runningCount,
    required this.ongoingCount,
    required this.patientCount,
  });

  final int runningCount;
  final int ongoingCount;
  final int patientCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            //CR hardcode color
            color: Color(0x0C000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _DoctorStatItem(count: runningCount, label: tr.statRunning),
            ),
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: AppColors.outline,
            ),
            Expanded(
              child: _DoctorStatItem(count: ongoingCount, label: tr.statOngoing),
            ),
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: AppColors.outline,
            ),
            Expanded(
              child: _DoctorStatItem(count: patientCount, label: tr.statPatient),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorStatItem extends StatelessWidget {
  const _DoctorStatItem({required this.count, required this.label});

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(count.toString(), style: context.bold20TextMain),
        4.verticalSpace,
        Text(
          label,
          style: context.regular14TextSecondary.copyWith(
            fontSize: 13,
            color: AppColors.textSecondary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
