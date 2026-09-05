import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/features/admin/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AdminDoctorListTile extends StatelessWidget {
  const AdminDoctorListTile({
    super.key,
    required this.doctor,
    this.onEdit,
    this.onDelete,
  });

  final AdminDoctorModel doctor;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: DoctorImage(
              imageUrl: doctor.imageUrl,
              width: 52,
              height: 52,
              fallback: const DoctorAvatarPlaceholder(size: 52),
            ),
          ),
          14.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doctor.name, style: context.semiBold16TextMain),
                2.verticalSpace,
                Text(doctor.specialty, style: context.regular14TextSecondary),
                6.verticalSpace,
                _ActiveBadge(isActive: doctor.isActive),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.textSecondary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            color: AppColors.surface,
            elevation: 4,
            onSelected: (value) {
              if (value == 'edit') {
                onEdit?.call();
              } else if (value == 'delete') {
                onDelete?.call();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'edit',
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
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_outline_rounded,
                      size: 20,
                      color: AppColors.error,
                    ),
                    10.horizontalSpace,
                    Text(
                      tr.delete,
                      style: context.medium14TextMain.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.success : AppColors.textSecondary;
    final bgColor = isActive ? AppColors.successLight : AppColors.outline;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? tr.activeLabel : tr.inactiveLabel,
        style: context.medium12TextSecondary.copyWith(color: color),
      ),
    );
  }
}

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
          child: _StatCard(
            icon: Icons.groups_rounded,
            label: tr.totalDoctors,
            count: totalCount,
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle_rounded,
            label: tr.activeLabel,
            count: activeCount,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.count,
  });

  final IconData icon;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: context.regular12TextSecondary),
                Text('$count', style: context.bold18TextMain),
              ],
            ),
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
            color: Color(0x12000000),
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
                icon: Icons.settings_rounded,
                label: tr.settings,
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
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
