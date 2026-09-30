import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/profile_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/profile_state.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/widgets/profile_header_section.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/widgets/profile_info_card.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.profile});

  final UserProfileModel? profile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..init(initialProfile: profile),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return switch (state) {
              ProfileLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              ProfileError(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    message,
                    style: context.semiBold16TextSecondary,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              ProfileLoaded(:final profile) => _ProfileContent(
                profile: profile,
              ),
              ProfileInitial() => const Center(
                child: CircularProgressIndicator(),
              ),
            };
          },
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.profile});

  final UserProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final locale = TranslationProvider.of(
      context,
    ).translations.$meta.locale.languageCode;

    final dobFormatted = profile.dob != null
        ? DateFormat('d MMM yyyy', locale).format(profile.dob!)
        : tr.notSet;

    final genderFormatted =
        (profile.gender != null && profile.gender!.isNotEmpty)
        ? profile.gender!
        : tr.notSet;

    final nameFormatted = profile.name.isNotEmpty ? profile.name : tr.notSet;
    final emailFormatted = profile.email.isNotEmpty ? profile.email : tr.notSet;
    final phoneFormatted = profile.phone.isNotEmpty ? profile.phone : tr.notSet;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeaderSection(
            avatarUrl: profile.avatarUrl,
            onBackTap: null,
            onCameraTap: () => const EditProfileRoute().push(context),
          ),
          24.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr.personalInformation,
                  style: context.bold18TextMain.copyWith(
                    color: AppColors.textMain,
                  ),
                ),
                16.verticalSpace,
                ProfileInfoCard(label: tr.fullName, value: nameFormatted),
                10.verticalSpace,
                ProfileInfoCard(label: tr.email, value: emailFormatted),
                10.verticalSpace,
                ProfileInfoCard(label: tr.contactNumber, value: phoneFormatted),
                10.verticalSpace,
                ProfileInfoCard(label: tr.dateOfBirth, value: dobFormatted),
                10.verticalSpace,
                ProfileInfoCard(label: tr.gender, value: genderFormatted),
                24.verticalSpace,
                AppPrimaryButton(
                  label: tr.edit,
                  onPressed: () => EditProfileRoute(profile).push(context),
                ),
                16.verticalSpace,
                _SettingsTile(
                  onTap: () => const PatientSettingsRoute().push(context),
                ),
                24.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outline.withValues(alpha: 0.6)),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowSubtle,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.settings_outlined,
                color: AppColors.primary,
                size: 22,
              ),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  context.tr.settings,
                  style: context.semiBold16TextMain,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
