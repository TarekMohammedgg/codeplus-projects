import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/validators.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import '../../data/service/auth_service.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/auth_header.dart';
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
  final _authService = AuthService();

  bool termsAccepted = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> createAccount() async {
    if (!formKey.currentState!.validate()) return;
    if (!termsAccepted) {
      context.showWarningSnackBar(
        'يرجى الموافقة على شروط الخدمة وسياسة الخصوصية للمتابعة.',
      );
      return;
    }
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);
    try {
      await _authService.signUpWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
      );
      if (!mounted) return;
      context.showSuccessSnackBar('تم إنشاء الحساب بنجاح!');
      const RoleSelectionRoute().go(context);
    } catch (e) {
      if (!mounted) return;
      context.showErrorSnackBar(AppException.from(e).message);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> signInWithGoogle() async {
    FocusScope.of(context).unfocus();
    setState(() => _isGoogleLoading = true);
    try {
      final credential = await _authService.signInWithGoogle();
      if (!mounted) return;
      if (credential != null) {
        const HomeRoute().go(context);
      }
    } catch (e) {
      if (!mounted) return;
      context.showErrorSnackBar(AppException.from(e).message);
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAnyLoading = _isLoading || _isGoogleLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              28.verticalSpace,
              AuthHeader(
                title: tr.createYourAccount,
                subtitle: tr.signupSubtitle,
              ),
              32.verticalSpace,
              SocialSignupSection(
                isLoading: _isGoogleLoading,
                onPressed: isAnyLoading ? null : signInWithGoogle,
              ),
              32.verticalSpace,
              AuthTextField(
                controller: nameController,
                hintText: tr.fullNameHint,
                prefixIcon: Icons.person_outline_rounded,
                iconColor: AppColors.textSecondary,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                validator: (value) => AppValidators.validateName(value),
              ),
              18.verticalSpace,
              AuthTextField(
                controller: emailController,
                hintText: tr.emailAddress,
                prefixIcon: Icons.mail_outline_rounded,
                iconColor: AppColors.textSecondary,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: (value) => AppValidators.validateEmail(value),
              ),
              18.verticalSpace,
              AuthTextField(
                controller: passwordController,
                hintText: tr.passwordHint,
                prefixIcon: Icons.lock_outline_rounded,
                iconColor: AppColors.textSecondary,
                isPassword: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                validator: (value) => AppValidators.validatePassword(value),
              ),
              8.verticalSpace,
              Row(
                children: [
                  const Icon(
                    Icons.verified_user_outlined,
                    color: AppColors.success,
                    size: 18,
                  ),
                  8.horizontalSpace,
                  Text(
                    tr.passwordLengthNotice,
                    style: context.regular14TextSecondary.copyWith(
                      fontSize: 13,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      key: const Key('terms-checkbox'),
                      value: termsAccepted,
                      onChanged: isAnyLoading
                          ? null
                          : (value) {
                              setState(() => termsAccepted = value ?? false);
                            },
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text.rich(
                        TextSpan(
                          style: context.regular14TextMain.copyWith(
                            fontSize: 13.5,
                            height: 1.35,
                          ),
                          children: [
                            TextSpan(text: tr.agreeTermsPrefix),
                            TextSpan(
                              text: tr.termsOfService,
                              style: context.semiBold14Primary.copyWith(
                                fontSize: 13.5,
                              ),
                            ),
                            TextSpan(text: tr.andText),
                            TextSpan(
                              text: tr.privacyPolicy,
                              style: context.semiBold14Primary.copyWith(
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
              24.verticalSpace,
              AuthPrimaryButton(
                label: tr.createAccount,
                isLoading: _isLoading,
                onPressed: isAnyLoading ? null : createAccount,
                height: 54,
                fontSize: 16,
              ),
              28.verticalSpace,
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      tr.alreadyHaveAccount,
                      style: context.regular14TextMain,
                    ),
                    TextButton(
                      onPressed: isAnyLoading
                          ? null
                          : () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                const LoginRoute().go(context);
                              }
                            },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.only(left: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: context.semiBold14Primary,
                      ),
                      child: Text(tr.signIn),
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

class SocialSignupSection extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const SocialSignupSection({
    super.key,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SocialAuthButton(
      label: tr.google,
      image: Assets.assetsDesignGoogleLogo,
      isLoading: isLoading,
      onPressed: onPressed,
    );
  }
}
