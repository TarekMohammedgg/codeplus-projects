import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_state.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = context.read<AuthCubit>().currentUser?.email ?? '';

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        switch (state) {
          case AuthFailure(:final errorMessage):
            context.showErrorSnackBar(errorMessage);
          case AuthSuccess(action: AuthAction.signOut):
            const RoleSelectionRoute().go(context);
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
              AppHeaderSection(
                title: tr.settings,
                onBackTap: () => context.pop(),
                showSearchBar: false,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const DoctorAvatarPlaceholder(size: 56),
                          14.horizontalSpace,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tr.adminRoleTitle,
                                  style: context.semiBold16TextMain,
                                ),
                                2.verticalSpace,
                                Text(
                                  email,
                                  style: context.regular14TextSecondary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      32.verticalSpace,
                      //CR use primary widget (any reuse widget)
                      // Solved
                      AppPrimaryButton.outlined(
                        onPressed: isLoggingOut
                            ? null
                            : () => context.read<AuthCubit>().signOut(),
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
