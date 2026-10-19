import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/extensions/app_error_text.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_card.dart';
import 'package:doctor_hunt/apps/core/widgets/app_profile_avatar.dart';
import 'package:doctor_hunt/apps/core/widgets/app_logout_dialog.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_state.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  Future<void> _confirmLogOut(BuildContext context) async {
    final confirmed = await showLogoutConfirmDialog(context);
    if (confirmed && context.mounted) {
      await context.read<AuthCubit>().signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().currentUser;
    final displayName = user?.displayName ?? '';
    final name = displayName.isNotEmpty ? displayName : tr.adminRoleTitle;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        switch (state) {
          case AuthFailure(:final error):
            context.showErrorSnackBar(error.localized(context.tr));
          default:
            break;
        }
      },
      builder: (context, state) {
        final isLoggingOut =
            state is AuthLoading && state.action == AuthAction.signOut;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(tr.settings, style: context.bold18TextMain),
                      ),
                      AppProfileAvatar(
                        imageUrl: user?.photoUrl,
                        onTap: () => const AdminProfileRoute().push(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppCard(
                          padding: EdgeInsets.zero,
                          child: InkWell(
                            onTap: () =>
                                const AdminProfileRoute().push(context),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: DoctorImage(
                                      imageUrl: user?.photoUrl,
                                      width: 56,
                                      height: 56,
                                      fallback: const DoctorAvatarPlaceholder(
                                        size: 56,
                                      ),
                                    ),
                                  ),
                                  16.horizontalSpace,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: context.bold16TextMain,
                                        ),
                                        4.verticalSpace,
                                        Text(
                                          user?.email ?? '',
                                          style: context.regular12TextSecondary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        24.verticalSpace,
                        AppCard(
                          padding: EdgeInsets.zero,
                          child: ListTile(
                            onTap: () =>
                                const AdminProfileRoute().push(context),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.manage_accounts_outlined,
                                size: 20,
                                color: AppColors.primary,
                              ),
                            ),
                            title: Text(
                              tr.adminProfile,
                              style: context.semiBold14TextMain,
                            ),
                            subtitle: Text(
                              tr.adminProfileSubtitle,
                              style: context.regular12TextSecondary,
                            ),
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.textMain,
                            ),
                          ),
                        ),
                        32.verticalSpace,
                        AppPrimaryButton(
                          onPressed: isLoggingOut
                              ? null
                              : () => _confirmLogOut(context),
                          icon: Icons.logout_rounded,
                          label: tr.logOut,
                          height: 48,
                          fontSize: 15,
                          backgroundColor: AppColors.errorLight,
                          foregroundColor: AppColors.error,
                          isLoading: isLoggingOut,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
