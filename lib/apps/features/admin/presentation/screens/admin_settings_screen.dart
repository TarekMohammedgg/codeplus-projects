import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/features/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final email = authService.currentUser?.email ?? '';

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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
                            Text(email, style: context.regular14TextSecondary),
                          ],
                        ),
                      ),
                    ],
                  ),
                  32.verticalSpace,
                  OutlinedButton.icon(
                    onPressed: () async {
                      await authService.signOut();
                      if (!context.mounted) return;
                      const RoleSelectionRoute().go(context);
                    },
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: AppColors.error,
                    ),
                    label: Text(
                      tr.logOut,
                      style: context.semiBold16TextMain.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
