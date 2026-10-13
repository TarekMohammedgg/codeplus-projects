import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({
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
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(
                icon: Icons.home_rounded,
                label: tr.tabHome,
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              NavItem(
                icon: Icons.medical_services_rounded,
                label: tr.tabDoctors,
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              NavItem(
                icon: Icons.calendar_month_rounded,
                label: tr.tabAppointments,
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              NavItem(
                icon: Icons.person_rounded,
                label: tr.tabProfile,
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
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
    return Semantics(
      label: label,
      selected: isSelected,
      button: true,
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : AppColors.textSecondary.withValues(alpha: 0.6),
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
