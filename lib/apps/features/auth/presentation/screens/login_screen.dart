import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/validators.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/forgot_password_bottom_sheet.dart';

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
    // context.unfocus();
    const HomeRoute().go(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              28.verticalSpace,
              AuthHeader(title: t.welcomeBack, subtitle: t.loginSubtitle),
              32.verticalSpace,
              const SocialLoginSection(),
              32.verticalSpace,
              AuthTextField(
                controller: emailController,
                hintText: t.emailHint,
                prefixIcon: Icons.mail_outline_rounded,
                iconColor: AppColors.textSecondary,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: (value) => AppValidators.validateEmail(value, t),
              ),
              18.verticalSpace,
              AuthTextField(
                controller: passwordController,
                hintText: t.enterPasswordHint,
                prefixIcon: Icons.lock_outline_rounded,
                iconColor: AppColors.textSecondary,
                isPassword: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                validator: (value) =>
                    AppValidators.validateRequiredPassword(value, t),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => ForgotPasswordBottomSheet.show(context),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryGreen,
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: context.medium14Primary.copyWith(fontSize: 13.5),
                  ),
                  child: Text(t.forgotPassword),
                ),
              ),
              24.verticalSpace,
              AuthPrimaryButton(
                label: t.logIn,
                onPressed: signIn,
                height: 54,
                fontSize: 16,
              ),
              28.verticalSpace,
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(t.dontHaveAccount, style: context.regular14TextSub),
                    TextButton(
                      onPressed: () => const SignupRoute().push(context),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.only(left: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: context.semiBold14Primary,
                      ),
                      child: Text(t.joinUs),
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

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SocialAuthButton(
            label: t.google,
            image: Assets.assetsDesignGoogleLogo,
            onPressed: () {
              const HomeRoute().go(context);
            },
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: SocialAuthButton(
            label: t.facebook,
            image: Assets.assetsDesignFacebookLogo,
            onPressed: () {
              const HomeRoute().go(context);
            },
          ),
        ),
      ],
    );
  }
}
