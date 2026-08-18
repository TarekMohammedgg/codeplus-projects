import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medora/apps/core/router/routes.dart';
import 'package:medora/generated/app_strings.dart';
import 'package:medora/generated/app_styles.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/login_hero_illustration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signIn() {
    FocusScope.of(context).unfocus();
    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                const Center(child: LoginHeroIllustration(size: 130)),
                const SizedBox(height: 16),
                Text(
                  AppStrings.welcomeBack,
                  textAlign: TextAlign.center,
                  style: AppStyles.display.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppStrings.loginSubtitle,
                  textAlign: TextAlign.center,
                  style: AppStyles.body.copyWith(
                    color: AppStyles.textSecondary,
                    fontSize: 14,
                    height: 1.3,
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
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  minHeight: 52,
                  validator: validateEmail,
                ),
                const SizedBox(height: 14),
                Text(
                  AppStrings.password,
                  style: AppStyles.label.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                AuthTextField(
                  controller: passwordController,
                  semanticLabel: AppStrings.password,
                  hintText: AppStrings.enterPasswordHint,
                  prefixIcon: Icons.lock_outline_rounded,
                  iconColor: AppStyles.textSecondary,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  minHeight: 52,
                  validator: (value) {
                    if ((value ?? '').isEmpty) {
                      return AppStrings.enterPassword;
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(Routes.resetPassword),
                    style: TextButton.styleFrom(
                      foregroundColor: AppStyles.primaryBlue,
                      padding: const EdgeInsets.only(top: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      textStyle: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: const Text(AppStrings.forgotPassword),
                  ),
                ),
                const SizedBox(height: 20),
                AuthPrimaryButton(
                  label: AppStrings.signIn,
                  onPressed: signIn,
                  height: 52,
                  fontSize: 16,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        AppStrings.newToMedora,
                        style: AppStyles.body.copyWith(
                          color: AppStyles.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push(Routes.signup),
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
                        child: const Text(AppStrings.createAnAccount),
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
