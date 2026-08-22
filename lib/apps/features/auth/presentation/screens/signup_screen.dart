import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
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
import '../widgets/otp_verification_bottom_sheet.dart';

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
    context.unfocus();
    OtpVerificationBottomSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;

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
              AuthHeader(
                title: t.createYourAccount,
                subtitle: t.signupSubtitle,
              ),
              32.verticalSpace,
              SocialSignupSection(),
              32.verticalSpace,
              AuthTextField(
                controller: nameController,
                hintText: t.fullNameHint,
                prefixIcon: Icons.person_outline_rounded,
                iconColor: AppColors.textSecondary,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                validator: (value) => AppValidators.validateName(value, t),
              ),
              18.verticalSpace,
              AuthTextField(
                controller: emailController,
                hintText: t.emailAddress,
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
                hintText: t.passwordHint,
                prefixIcon: Icons.lock_outline_rounded,
                iconColor: AppColors.textSecondary,
                isPassword: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                validator: (value) =>
                    AppValidators.validatePassword(value, t),
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
                    t.passwordLengthNotice,
                    style: context.regular14TextSub.copyWith(
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
                      onChanged: (value) {
                        setState(() => termsAccepted = value ?? false);
                      },
                      side: const BorderSide(
                        color: AppColors.primaryGreen,
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
                            TextSpan(text: t.agreeTermsPrefix),
                            TextSpan(
                              text: t.termsOfService,
                              style: context.semiBold14Primary.copyWith(fontSize: 13.5),
                            ),
                            TextSpan(text: t.andText),
                            TextSpan(
                              text: t.privacyPolicy,
                              style: context.semiBold14Primary.copyWith(fontSize: 13.5),
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
                label: t.createAccount,
                onPressed: createAccount,
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
                      t.alreadyHaveAccount,
                      style: context.regular14TextMain,
                    ),
                    TextButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          const LoginRoute().go(context);
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.only(left: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: context.semiBold14Primary,
                      ),
                      child: Text(t.signIn),
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
  const SocialSignupSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return Row(
      children: [
        Expanded(
          child: SocialAuthButton(
            label: t.google,
            image: Assets.assetsDesignGoogleLogo,
            onPressed: () => OtpVerificationBottomSheet.show(context),
          ),
        ),
        14.horizontalSpace,
        Expanded(
          child: SocialAuthButton(
            label: t.facebook,
            image: Assets.assetsDesignFacebookLogo,
            onPressed: () => OtpVerificationBottomSheet.show(context),
          ),
        ),
      ],
    );
  }
}
