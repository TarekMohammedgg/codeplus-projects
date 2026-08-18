import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medora/apps/core/router/routes.dart';
import 'package:medora/generated/app_strings.dart';
import 'package:medora/generated/app_styles.dart';
import 'package:medora/generated/image_assets.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/reset_password_hero_illustration.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void sendResetLink() {
    FocusScope.of(context).unfocus();
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    showMessage(AppStrings.passwordResetSuccess);
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const AuthBackButton(circular: true),
                    const Spacer(),
                    Image.asset(
                      Assets.assetsScreensDesignMedoraLogoMark,
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      AppStrings.appName,
                      style: TextStyle(
                        color: AppStyles.navy,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 18),
                const Center(child: ResetPasswordHeroIllustration(size: 130)),
                const SizedBox(height: 16),
                Text(
                  AppStrings.resetYourPassword,
                  textAlign: TextAlign.center,
                  style: AppStyles.display.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppStrings.resetPasswordSubtitle,
                  textAlign: TextAlign.center,
                  style: AppStyles.body.copyWith(
                    color: AppStyles.textSecondary,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppStrings.emailAddress,
                  style: AppStyles.label.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                AuthTextField(
                  controller: emailController,
                  semanticLabel: AppStrings.emailAddress,
                  hintText: AppStrings.emailHint,
                  prefixIcon: Icons.mail_outline_rounded,
                  iconColor: AppStyles.textSecondary,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.email],
                  minHeight: 52,
                  validator: validateEmail,
                ),
                const SizedBox(height: 20),
                AuthPrimaryButton(
                  label: AppStrings.sendResetLink,
                  icon: Icons.send_rounded,
                  onPressed: sendResetLink,
                  height: 52,
                  fontSize: 16,
                ),
                const SizedBox(height: 20),

                const SizedBox(height: 24),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        AppStrings.rememberedPassword,
                        style: AppStyles.body.copyWith(
                          color: AppStyles.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go(Routes.login);
                          }
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppStyles.primaryBlue,
                          padding: const EdgeInsets.only(left: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text(AppStrings.signIn),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return AppStrings.enterEmailAddress;
    if (!email.contains('@') || !email.contains('.')) {
      return AppStrings.enterValidEmailAddress;
    }
    return null;
  }
}
