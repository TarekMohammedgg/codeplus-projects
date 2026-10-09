import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_back_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_card.dart';
import 'package:doctor_hunt/apps/core/widgets/app_logout_dialog.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/profile_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/profile_state.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/widgets/profile_avatar.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

/// Needs a [ProfileCubit] and an [AuthCubit] above it (provided by the route).
class PatientSettingsScreen extends StatefulWidget {
  const PatientSettingsScreen({super.key});

  @override
  State<PatientSettingsScreen> createState() => _PatientSettingsScreenState();
}

class _PatientSettingsScreenState extends State<PatientSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _hasLoadedProfile = false;

  /// The switch starts from the stored value once, then is driven locally.
  void _syncNotifications(ProfileState state) {
    if (_hasLoadedProfile || state is! ProfileLoaded) return;
    _hasLoadedProfile = true;
    _notificationsEnabled = state.profile.notificationsEnabled;
  }

  @override
  void initState() {
    super.initState();
    _syncNotifications(context.read<ProfileCubit>().state);
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() => _notificationsEnabled = value);
    try {
      await context.read<ProfileCubit>().setNotifications(value);
    } catch (e) {
      if (!mounted) return;
      setState(() => _notificationsEnabled = !value);
      context.showErrorSnackBar(AppException.from(e).message);
    }
  }

  Future<void> _switchLanguage(AppLocale locale) async {
    final cubit = context.read<ProfileCubit>();
    await LocaleSettings.setLocale(locale);
    try {
      await cubit.setLanguage(locale.languageCode);
    } catch (e) {
      if (!mounted) return;
      context.showErrorSnackBar(AppException.from(e).message);
    }
  }

  Future<void> _confirmLogOut() async {
    final confirmed = await showLogoutConfirmDialog(context);

    if (confirmed && mounted) {
      await context.read<AuthCubit>().signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: AppBackButton.leading(onTap: () => context.pop()),
        title: Text(context.tr.settings, style: context.bold18TextMain),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (_, state) => setState(() => _syncNotifications(state)),
        builder: (context, state) => _buildSettingsContent(
          context,
          state is ProfileLoaded ? state.profile : null,
        ),
      ),
    );
  }

  Widget _buildSettingsContent(
    BuildContext context,
    UserProfileModel? profile,
  ) {
    final currentLocale = LocaleSettings.currentLocale;
    final tr = context.tr;
    final currentUser = context.read<ProfileCubit>().currentUser;

    final displayName = profile?.name.isNotEmpty == true
        ? profile!.name
        : (currentUser?.displayName?.isNotEmpty == true
              ? currentUser!.displayName!
              : tr.patientRoleTitle);

    final displayEmail = profile?.email.isNotEmpty == true
        ? profile!.email
        : (currentUser?.email ?? '');

    final avatarUrl = profile?.avatarUrl ?? currentUser?.photoURL;
    const chevron = Icon(
      Icons.chevron_right_rounded,
      color: AppColors.textSecondary,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            child: Row(
              children: [
                ProfileAvatar(avatarUrl: avatarUrl, size: 56),
                16.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayName,
                        style: context.bold16TextMain,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.verticalSpace,
                      Text(
                        displayEmail,
                        style: context.regular12TextSecondary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          16.verticalSpace,
          Text(tr.accountSettings, style: context.semiBold16TextSecondary),
          if (context.read<AuthCubit>().hasPasswordProvider)
            _SettingsListTile(
              key: const Key('settings_change_password_tile'),
              icon: Icons.lock_outline_rounded,
              iconBackgroundColor: AppColors.settingsPasswordBadge,
              title: tr.changePassword,
              trailing: chevron,
              onTap: () => const ChangePasswordRoute().push(context),
            ),
          _SettingsListTile(
            key: const Key('settings_notifications_tile'),
            icon: Icons.notifications_none_rounded,
            iconBackgroundColor: AppColors.settingsNotificationBadge,
            title: tr.notifications,
            trailing: Switch.adaptive(
              value: _notificationsEnabled,
              activeTrackColor: AppColors.switchActive,
              onChanged: _toggleNotifications,
            ),
          ),
          _SettingsListTile(
            key: const Key('settings_privacy_policy_tile'),
            icon: Icons.privacy_tip_outlined,
            iconBackgroundColor: AppColors.settingsPrivacyBadge,
            title: tr.privacyPolicy,
            trailing: chevron,
            onTap: () => const PrivacyPolicyRoute().push(context),
          ),
          24.verticalSpace,
          Text(tr.moreOptions, style: context.semiBold16TextSecondary),
          _SettingsListTile(
            key: const Key('settings_language_tile'),
            title: tr.language,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentLocale == AppLocale.ar
                      ? tr.arabicLanguage
                      : tr.englishLanguage,
                  style: context.regular12TextSecondary,
                ),
                4.horizontalSpace,
                chevron,
              ],
            ),
            onTap: () => _switchLanguage(
              currentLocale == AppLocale.ar ? AppLocale.en : AppLocale.ar,
            ),
          ),
          _SettingsListTile(
            key: const Key('settings_build_version_tile'),
            title: tr.buildVersion,
            trailing: Text(
              tr.versionValue,
              style: context.regular12TextSecondary,
            ),
          ),
          48.verticalSpace,
          AppPrimaryButton(
            key: const Key('settings_logout_button'),
            label: tr.logOut,
            icon: Icons.logout_rounded,
            height: 48,
            fontSize: 15,
            backgroundColor: AppColors.errorLight,
            foregroundColor: AppColors.error,
            onPressed: _confirmLogOut,
          ),
        ],
      ),
    );
  }
}

/// Flat row with a bottom divider, as in the Figma settings list.
class _SettingsListTile extends StatelessWidget {
  const _SettingsListTile({
    super.key,
    this.icon,
    this.iconBackgroundColor,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  final IconData? icon;
  final Color? iconBackgroundColor;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.outline)),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              CircleAvatar(
                radius: 16,
                backgroundColor: iconBackgroundColor,
                child: Icon(icon, size: 16, color: AppColors.white),
              ),
              20.horizontalSpace,
            ],
            Expanded(child: Text(title, style: context.regular16TextSecondary)),
            trailing,
          ],
        ),
      ),
    );
  }
}
