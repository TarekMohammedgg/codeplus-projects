import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/features/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/profile/data/profile_data.dart';
import 'package:doctor_hunt/apps/features/profile/presentation/widgets/profile_header_section.dart';
import 'package:doctor_hunt/apps/features/profile/presentation/widgets/profile_info_card.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.profile});

  final UserProfileModel? profile;

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      const HomeRoute().go(context);
    }
  }

  Future<void> _onLogOut(BuildContext context) async {
    await AuthService().signOut();
    if (context.mounted) {
      const LoginRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = profile ?? defaultUserProfile();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeaderSection(
                    avatarUrl: userProfile.avatarUrl,
                    onBackTap: () => _onBack(context),
                    onCameraTap: () {},
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
                            fontSize: 18,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        16.verticalSpace,
                        ProfileInfoCard(
                          label: tr.fullName,
                          value: userProfile.name,
                        ),
                        10.verticalSpace,
                        ProfileInfoCard(
                          label: tr.contactNumber,
                          value: userProfile.contactNumber,
                          showEditIcon: true,
                          onEdit: () {},
                        ),
                        10.verticalSpace,
                        ProfileInfoCard(
                          label: tr.dateOfBirth,
                          value: userProfile.dateOfBirth,
                          showEditIcon: true,
                          onEdit: () {},
                        ),
                        10.verticalSpace,
                        ProfileInfoCard(
                          label: tr.location,
                          value: userProfile.location,
                        ),
                        24.verticalSpace,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _onLogOut(context),
                  icon: const Icon(
                    Icons.logout_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: Text(tr.logOut, style: context.bold16White),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
