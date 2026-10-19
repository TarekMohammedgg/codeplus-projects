import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/extensions/app_error_text.dart';
import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/utils/formatters.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/profile_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/profile_state.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/widgets/profile_header_section.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/widgets/profile_info_card.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) => switch (state) {
          ProfileInitial() || ProfileLoading() => Skeletonizer(
            child: _ProfileContent(
              profile: UserProfileModel(
                name: BoneMock.fullName,
                email: BoneMock.email,
                phone: BoneMock.phone,
              ),
            ),
          ),
          ProfileError(:final error) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                error.localized(context.tr),
                style: context.semiBold16TextSecondary,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ProfileLoaded(:final profile) => _ProfileContent(profile: profile),
        },
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
    String dobFormatted;
    if (profile.dob != null) {
      dobFormatted = formatDate(profile.dob!, context.localeCode);
    } else {
      dobFormatted = tr.notSet;
    }

    final genderFormatted = switch (profile.gender) {
      Gender.male => tr.male,
      Gender.female => tr.female,
      null => tr.notSet,
    };

    final nameFormatted = profile.name.isNotEmpty ? profile.name : tr.notSet;
    final emailFormatted = profile.email.isNotEmpty ? profile.email : tr.notSet;
    final phoneFormatted = profile.phone.isNotEmpty ? profile.phone : tr.notSet;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeaderSection(
            avatarUrl: profile.avatarUrl,
            onBackTap: () => context.pop(),
            onEditTap: () => EditProfileRoute(profile).push(context),
            onCameraTap: () => EditProfileRoute(profile).push(context),
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
                ProfileInfoCard(
                  label: tr.fullName,
                  value: nameFormatted,
                  showEditIcon: true,
                  onEdit: () => EditProfileRoute(profile).push(context),
                ),
                10.verticalSpace,
                ProfileInfoCard(label: tr.email, value: emailFormatted),
                10.verticalSpace,
                ProfileInfoCard(
                  label: tr.contactNumber,
                  value: phoneFormatted,
                  showEditIcon: true,
                  onEdit: () => EditProfileRoute(profile).push(context),
                ),
                10.verticalSpace,
                ProfileInfoCard(label: tr.dateOfBirth, value: dobFormatted),
                10.verticalSpace,
                ProfileInfoCard(label: tr.gender, value: genderFormatted),
                24.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
