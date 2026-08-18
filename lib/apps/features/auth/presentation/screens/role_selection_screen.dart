import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medora/apps/core/router/routes.dart';
import 'package:medora/generated/app_strings.dart';
import 'package:medora/generated/app_styles.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/role_selection_illustrations.dart';

enum UserRole { patient, provider }

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => RoleSelectionScreenState();
}

class RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole selectedRole = UserRole.patient;

  void onContinue() {
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: AuthBackButton(circular: true),
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.roleSelectionTitle,
                textAlign: TextAlign.center,
                style: AppStyles.display.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                AppStrings.roleSelectionSubtitle,
                textAlign: TextAlign.center,
                style: AppStyles.body.copyWith(
                  color: AppStyles.textSecondary,
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 24),
              buildRoleCard(
                isSelected: selectedRole == UserRole.patient,
                illustration: const RolePatientIllustration(size: 130),
                title: AppStrings.patientRoleTitle,
                description: AppStrings.patientRoleDescription,
                onTap: () {
                  setState(() => selectedRole = UserRole.patient);
                },
              ),
              const SizedBox(height: 16),
              buildRoleCard(
                isSelected: selectedRole == UserRole.provider,
                illustration: const RoleProviderIllustration(size: 130),
                title: AppStrings.providerRoleTitle,
                description: AppStrings.providerRoleDescription,
                onTap: () {
                  setState(() => selectedRole = UserRole.provider);
                },
              ),
              const SizedBox(height: 28),
              AuthPrimaryButton(
                label: AppStrings.continueText,
                onPressed: onContinue,
                height: 52,
                fontSize: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRoleCard({
    required bool isSelected,
    required Widget illustration,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
          decoration: BoxDecoration(
            color: AppStyles.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppStyles.primaryBlue : AppStyles.outline,
              width: isSelected ? 2.0 : 1.2,
            ),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color(0x121D69EE),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ]
                : AppStyles.softShadow,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              illustration,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppStyles.primaryBlue
                                : AppStyles.disabled,
                            width: isSelected ? 2.0 : 1.5,
                          ),
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppStyles.primaryBlue,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppStyles.navy,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: AppStyles.body.copyWith(
                        color: AppStyles.textSecondary,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
