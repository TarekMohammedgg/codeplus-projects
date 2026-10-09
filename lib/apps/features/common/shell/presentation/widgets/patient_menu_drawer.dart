import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/profile_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/profile_state.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/widgets/profile_avatar.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

/// Figma "21_Menu screen": the patient side menu opened from the Home avatar.
class PatientMenuDrawer extends StatelessWidget {
  const PatientMenuDrawer({
    super.key,
    required this.onTabTap,
    required this.onSettingsTap,
    required this.onLogoutTap,
  });

  /// Shell branch index: 0 Home, 1 Favorites, 2 Appointments.
  final ValueChanged<int> onTabTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onLogoutTap;

  @override
  Widget build(BuildContext context) {
    // Close the drawer first, then run the action from the shell.
    void closeThen(VoidCallback action) {
      Navigator.of(context).pop();
      action();
    }

    return Drawer(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.menuGradientStart, AppColors.menuGradientEnd],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _MenuProfileHeader(),
                72.verticalSpace,
                _MenuItem(
                  icon: Icons.home_rounded,
                  label: context.tr.tabHome,
                  onTap: () => closeThen(() => onTabTap(0)),
                ),
                _MenuItem(
                  icon: Icons.favorite_rounded,
                  label: context.tr.tabFavorites,
                  onTap: () => closeThen(() => onTabTap(1)),
                ),
                _MenuItem(
                  icon: Icons.calendar_month_rounded,
                  label: context.tr.myAppointments,
                  onTap: () => closeThen(() => onTabTap(2)),
                ),
                _MenuItem(
                  icon: Icons.settings_rounded,
                  label: context.tr.settings,
                  onTap: () => closeThen(onSettingsTap),
                ),
                const Spacer(),
                ListTile(
                  key: const Key('menu_logout_tile'),
                  contentPadding: EdgeInsets.zero,
                  iconColor: AppColors.white,
                  leading: const Icon(Icons.logout_rounded),
                  title: Text(context.tr.logOut, style: context.medium20White),
                  onTap: () => closeThen(onLogoutTap),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuProfileHeader extends StatelessWidget {
  const _MenuProfileHeader();

  @override
  Widget build(BuildContext context) {
    final profile = switch (context.watch<ProfileCubit>().state) {
      ProfileLoaded(:final profile) => profile,
      _ => null,
    };
    final phone = profile?.phone ?? '';

    return Row(
      children: [
        ProfileAvatar(
          avatarUrl: profile?.avatarUrl,
          size: 44,
          borderWidth: 0,
          boxShadow: const [],
        ),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile?.name ?? '',
                style: context.medium16White,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (phone.isNotEmpty) ...[
                4.verticalSpace,
                Row(
                  children: [
                    const Icon(
                      Icons.phone_rounded,
                      size: 12,
                      color: AppColors.white,
                    ),
                    4.horizontalSpace,
                    Text(phone, style: context.regular12White),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 16,
      iconColor: AppColors.white,
      leading: Icon(icon),
      title: Text(label, style: context.regular16White),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
