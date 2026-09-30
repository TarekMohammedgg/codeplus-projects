import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_button.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/repositories/profile_repository.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class PatientSettingsScreen extends StatefulWidget {
  const PatientSettingsScreen({super.key, this.profileRepository, this.auth});

  final ProfileRepository? profileRepository;
  final FirebaseAuth? auth;

  @override
  State<PatientSettingsScreen> createState() => _PatientSettingsScreenState();
}

class _PatientSettingsScreenState extends State<PatientSettingsScreen> {
  ProfileRepository get _repository =>
      widget.profileRepository ?? getIt<ProfileRepository>();
  FirebaseAuth get _auth => widget.auth ?? getIt<FirebaseAuth>();

  bool _notificationsEnabled = true;
  bool _hasLoadedProfile = false;

  User? get _currentUser => _auth.currentUser;

  bool get _hasPasswordProvider {
    final user = _currentUser;
    if (user == null) return false;
    return user.providerData.any((p) => p.providerId == 'password');
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() => _notificationsEnabled = value);
    final uid = _currentUser?.uid;
    if (uid != null && uid.isNotEmpty) {
      await _repository.updateProfile(uid: uid, notificationsEnabled: value);
    }
  }

  Future<void> _switchLanguage(AppLocale locale) async {
    await LocaleSettings.setLocale(locale);
    final uid = _currentUser?.uid;
    if (uid != null && uid.isNotEmpty) {
      await _repository.updateProfile(uid: uid, language: locale.languageCode);
    }
  }

  Future<void> _confirmLogOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(tr.logOutConfirmTitle, style: context.semiBold16TextMain),
        content: Text(
          tr.logOutConfirmMessage,
          style: context.regular14TextSecondary,
        ),
        actions: [
          AppTextButton(
            label: tr.cancel,
            onPressed: () => Navigator.of(dialogContext).pop(false),
            textStyle: context.medium14TextSecondary,
          ),
          AppTextButton(
            label: tr.logOut,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            foregroundColor: AppColors.error,
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<AuthCubit>().signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = _currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: AppIconButton.back(onTap: () => context.pop()),
        centerTitle: true,
        title: Text(context.tr.settings, style: context.bold18TextMain),
      ),
      body: uid == null
          ? _buildSettingsContent(context)
          : StreamBuilder<UserProfileModel>(
              stream: _repository.streamProfile(uid),
              builder: (context, snapshot) {
                if (snapshot.hasData && !_hasLoadedProfile) {
                  _notificationsEnabled = snapshot.data!.notificationsEnabled;
                  _hasLoadedProfile = true;
                }
                return _buildSettingsContent(context);
              },
            ),
    );
  }

  Widget _buildSettingsContent(BuildContext context) {
    final currentLocale = LocaleSettings.currentLocale;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr.accountSettings, style: context.bold16TextMain),
          16.verticalSpace,
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowCard,
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                if (_hasPasswordProvider) ...[
                  _SettingsListTile(
                    key: const Key('settings_change_password_tile'),
                    icon: Icons.lock_outline_rounded,
                    title: context.tr.changePassword,
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                    ),
                    onTap: () => const ChangePasswordRoute().push(context),
                  ),
                  const Divider(height: 1, color: AppColors.outline),
                ],
                _SettingsListTile(
                  key: const Key('settings_notifications_tile'),
                  icon: Icons.notifications_none_rounded,
                  title: context.tr.notifications,
                  trailing: Switch.adaptive(
                    value: _notificationsEnabled,
                    activeTrackColor: AppColors.primary,
                    onChanged: _toggleNotifications,
                  ),
                ),
              ],
            ),
          ),
          28.verticalSpace,
          Text(context.tr.moreOptions, style: context.bold16TextMain),
          16.verticalSpace,
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowCard,
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: _SettingsListTile(
              key: const Key('settings_language_tile'),
              icon: Icons.language_rounded,
              title: context.tr.language,
              subtitle: currentLocale == AppLocale.ar
                  ? context.tr.arabicLanguage
                  : context.tr.englishLanguage,
              trailing: const Icon(
                Icons.swap_horiz_rounded,
                color: AppColors.primary,
              ),
              onTap: () {
                final nextLocale = currentLocale == AppLocale.ar
                    ? AppLocale.en
                    : AppLocale.ar;
                _switchLanguage(nextLocale);
              },
            ),
          ),
          36.verticalSpace,
          AppPrimaryButton.outlined(
            key: const Key('settings_logout_button'),
            label: context.tr.logOut,
            icon: Icons.logout_rounded,
            foregroundColor: AppColors.error,
            borderColor: AppColors.error,
            onPressed: _confirmLogOut,
          ),
          24.verticalSpace,
        ],
      ),
    );
  }
}

class _SettingsListTile extends StatelessWidget {
  const _SettingsListTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: AppColors.primary),
              ),
              14.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.semiBold14TextMain),
                    if (subtitle != null) ...[
                      2.verticalSpace,
                      Text(subtitle!, style: context.regular12TextSecondary),
                    ],
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
