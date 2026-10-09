import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_status_pill.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AdminDoctorListTile extends StatelessWidget {
  const AdminDoctorListTile({
    super.key,
    required this.doctor,
    this.onTap,
    this.onEdit,
    this.onToggleActive,
  });

  final DoctorModel doctor;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  final VoidCallback? onToggleActive;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10);
    return DecoratedBox(
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
            padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 0, 12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: DoctorImage(
                    imageUrl: doctor.imageUrl,
                    width: 52,
                    height: 52,
                    fallback: const DoctorAvatarPlaceholder(size: 52),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.medium16TextMain,
                      ),
                      4.verticalSpace,
                      Text(
                        doctor.specialty,
                        style: context.regular12TextSecondary,
                      ),
                      4.verticalSpace,
                      Row(
                        children: [
                          DoctorStarRating(rating: doctor.rating, size: 12),
                          6.horizontalSpace,
                          Flexible(
                            child: Text(
                              tr.ratingSummary(
                                rating: doctor.rating.toStringAsFixed(1),
                                count: doctor.reviewsCount,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.regular10TextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AppStatusPill(
                  label: doctor.isActive ? tr.activeLabel : tr.inactiveLabel,
                  color: doctor.isActive ? AppColors.success : AppColors.error,
                  backgroundColor: doctor.isActive
                      ? AppColors.successLight
                      : AppColors.errorLight,
                ),
                PopupMenuButton<_DoctorAction>(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  color: AppColors.surface,
                  elevation: 4,
                  onSelected: (action) => switch (action) {
                    _DoctorAction.edit => onEdit?.call(),
                    _DoctorAction.toggleActive => onToggleActive?.call(),
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: _DoctorAction.edit,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: AppColors.textMain,
                          ),
                          10.horizontalSpace,
                          Text(tr.edit, style: context.medium14TextMain),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: _DoctorAction.toggleActive,
                      child: Row(
                        children: [
                          Icon(
                            doctor.isActive
                                ? Icons.block_rounded
                                : Icons.check_circle_outline_rounded,
                            size: 20,
                            color: doctor.isActive
                                ? AppColors.error
                                : AppColors.success,
                          ),
                          10.horizontalSpace,
                          Text(
                            doctor.isActive ? tr.deactivate : tr.activate,
                            style: context.medium14TextMain.copyWith(
                              color: doctor.isActive
                                  ? AppColors.error
                                  : AppColors.success,
                            ),
                          ),
                        ],
                      ),
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

enum _DoctorAction { edit, toggleActive }

class AdminStatsRow extends StatelessWidget {
  const AdminStatsRow({
    super.key,
    required this.totalCount,
    required this.activeCount,
  });

  final int totalCount;
  final int activeCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(label: tr.activeDoctors, count: activeCount),
        ),
        12.horizontalSpace,
        Expanded(
          child: _StatCard(label: tr.totalDoctors, count: totalCount),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceMuted),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowSubtle,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.regular11TextSecondary.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          4.verticalSpace,
          Text(
            NumberFormat.decimalPattern().format(count),
            style: context.bold18TextMain,
          ),
        ],
      ),
    );
  }
}

class AdminBottomNavigationBar extends StatelessWidget {
  const AdminBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            //CR hardcode color
            // Solved
            color: AppColors.shadowNavigation,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _AdminNavItem(
                icon: Icons.people_alt_rounded,
                label: tr.doctorsTitle,
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _AdminNavItem(
                icon: Icons.calendar_month_rounded,
                label: tr.appointments,
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _AdminNavItem(
                icon: Icons.settings_rounded,
                label: tr.settings,
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminNavItem extends StatelessWidget {
  const _AdminNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            4.verticalSpace,
            Text(
              label,
              style: context.medium12TextSecondary.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
