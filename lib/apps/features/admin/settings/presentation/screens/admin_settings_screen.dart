import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_state.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

/// Admin shell tab. Signing out is enough: the router redirect handles
/// navigation.
class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  Future<void> _confirmLogOut(BuildContext context) async {
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
    if (confirmed == true && context.mounted) {
      await context.read<AuthCubit>().signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().currentUser;
    final displayName = user?.displayName?.trim() ?? '';

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        switch (state) {
          case AuthFailure(:final errorMessage):
            context.showErrorSnackBar(errorMessage);
          default:
            break;
        }
      },
      builder: (context, state) {
        final isLoggingOut =
            state is AuthLoading && state.action == AuthAction.signOut;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              AppHeaderSection(title: tr.settings, showSearchBar: false),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InkWell(
                        onTap: () => const AdminProfileRoute().push(context),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              ClipOval(
                                child: DoctorImage(
                                  imageUrl: user?.photoURL,
                                  width: 56,
                                  height: 56,
                                  fallback: const DoctorAvatarPlaceholder(
                                    size: 56,
                                  ),
                                ),
                              ),
                              14.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      displayName.isNotEmpty
                                          ? displayName
                                          : tr.adminRoleTitle,
                                      style: context.semiBold16TextMain,
                                    ),
                                    2.verticalSpace,
                                    Text(
                                      user?.email ?? '',
                                      style: context.regular14TextSecondary,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      32.verticalSpace,
                      AppPrimaryButton.outlined(
                        onPressed: isLoggingOut
                            ? null
                            : () => _confirmLogOut(context),
                        icon: Icons.logout_rounded,
                        label: tr.logOut,
                        foregroundColor: AppColors.error,
                        borderColor: AppColors.error,
                        isLoading: isLoggingOut,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
