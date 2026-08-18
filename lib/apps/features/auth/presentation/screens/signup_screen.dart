import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medora/apps/core/router/routes.dart';
import 'package:medora/generated/app_strings.dart';
import 'package:medora/generated/app_styles.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/auth_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool termsAccepted = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void createAccount() {
    FocusScope.of(context).unfocus();
    context.push(Routes.otpVerification);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthBackButton(circular: true),
                const SizedBox(height: 16),
                const Text(
                  AppStrings.createYourAccount,
                  style: TextStyle(
                    color: AppStyles.navy,
                    fontFamily: 'serif',
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.signupSubtitle,
                  style: AppStyles.body.copyWith(
                    color: const Color(0xFF53637C),
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  controller: nameController,
                  semanticLabel: AppStrings.fullName,
                  hintText: AppStrings.fullNameHint,
                  prefixIcon: Icons.person_outline_rounded,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  minHeight: 52,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppStrings.enterFullName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                AuthTextField(
                  controller: emailController,
                  semanticLabel: AppStrings.emailAddress,
                  hintText: AppStrings.emailAddress,
                  prefixIcon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  minHeight: 52,
                  validator: validateEmail,
                ),
                const SizedBox(height: 12),
                AuthTextField(
                  controller: passwordController,
                  semanticLabel: AppStrings.password,
                  hintText: AppStrings.passwordHint,
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.newPassword],
                  minHeight: 52,
                  validator: validatePassword,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.verified_user_outlined,
                      color: AppStyles.success,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.passwordLengthNotice,
                      style: AppStyles.body.copyWith(
                        color: AppStyles.textSecondary,
                        fontSize: 13,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        key: const Key('terms-checkbox'),
                        value: termsAccepted,
                        onChanged: (value) {
                          setState(() => termsAccepted = value ?? false);
                        },
                        side: const BorderSide(
                          color: AppStyles.primaryBlue,
                          width: 1.5,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text.rich(
                          TextSpan(
                            style: AppStyles.body.copyWith(
                              color: AppStyles.navy,
                              fontSize: 13.5,
                              height: 1.35,
                            ),
                            children: [
                              const TextSpan(text: AppStrings.agreeTermsPrefix),
                              TextSpan(
                                text: AppStrings.termsOfService,
                                style: AppStyles.action.copyWith(
                                  fontSize: 13.5,
                                ),
                              ),
                              const TextSpan(text: AppStrings.andText),
                              TextSpan(
                                text: AppStrings.privacyPolicy,
                                style: AppStyles.action.copyWith(
                                  fontSize: 13.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AuthPrimaryButton(
                  label: AppStrings.createAccount,
                  onPressed: createAccount,
                  height: 52,
                  fontSize: 16,
                ),
                const SizedBox(height: 18),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        AppStrings.alreadyHaveAccount,
                        style: AppStyles.body.copyWith(
                          color: AppStyles.navy,
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

  String? validatePassword(String? value) {
    if ((value ?? '').length < 8) {
      return AppStrings.useAtLeast8Characters;
    }
    return null;
  }
}
