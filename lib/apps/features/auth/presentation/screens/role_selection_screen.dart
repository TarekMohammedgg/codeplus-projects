import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/features/auth/data/models/user_role.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => RoleSelectionScreenState();
}

class RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole selectedRole = UserRole.patient;

  void onContinue() {
    const LoginRoute().go(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Center(
              child: Image.asset(
                Assets.assetsDesignSplashLogo,
                height: 76,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 36),
            Text(
              t.roleSelectionTitle,
              textAlign: TextAlign.center,
              style: context.bold24TextMain,
            ),
            const SizedBox(height: 8),
            Text(
              t.roleSelectionSubtitle,
              textAlign: TextAlign.center,
              style: context.regular14TextSub.copyWith(
                fontSize: 13.5,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            buildRoleCard(
              isSelected: selectedRole == UserRole.patient,
              icon: Icons.person_rounded,
              title: t.patientRoleTitle,
              description: t.patientRoleDescription,
              onTap: () {
                setState(() => selectedRole = UserRole.patient);
              },
            ),
            const SizedBox(height: 16),
            buildRoleCard(
              isSelected: selectedRole == UserRole.admin,
              icon: Icons.grid_view_rounded,
              title: t.adminRoleTitle,
              description: t.adminRoleDescription,
              onTap: () {
                setState(() => selectedRole = UserRole.admin);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28, bottom: 8),
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    t.continueText,
                    style: context.semiBold16White,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRoleCard({
    required bool isSelected,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryGreen
                  : const Color(0xFFE5E9EB),
              width: isSelected ? 1.8 : 1.2,
            ),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color(0x140EBE7E),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ]
                : const [
                    BoxShadow(
                      color: Color(0x06000000),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.softMint
                      : const Color(0xFFF1F4F6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? AppColors.primaryGreen
                      : const Color(0xFF8A94A6),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.bold16TextMain.copyWith(
                        fontSize: 17,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: context.regular14TextSub.copyWith(
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(left: 8, top: 2),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                )
              else
                const SizedBox(width: 22),
            ],
          ),
        ),
      ),
    );
  }
}
