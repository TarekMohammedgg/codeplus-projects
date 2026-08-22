import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/validators.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/auth_text_field.dart';

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
    context.unfocus();
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    context.showSuccessSnackBar(context.t.passwordResetSuccess);
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
              Row(
                children: [
                  const AuthBackButton(circular: true),
                  const Spacer(),
                  Image.asset(Assets.assetsDesignDoctorHuntLogo, height: 28),
                  const Spacer(),
                ],
              ),
              18.verticalSpace,
              const Center(child: ResetPasswordHeroIllustration(size: 110)),
              16.verticalSpace,
              Text(
                t.resetYourPassword,
                textAlign: TextAlign.center,
                style: context.bold26TextMain,
              ),
              6.verticalSpace,
              Text(
                t.resetPasswordSubtitle,
                textAlign: TextAlign.center,
                style: context.regular14TextSub.copyWith(
                  height: 1.35,
                ),
              ),
              20.verticalSpace,
              Text(
                t.emailAddress,
                style: context.semiBold14TextMain,
              ),
              6.verticalSpace,
              AuthTextField(
                controller: emailController,
                hintText: t.emailHint,
                prefixIcon: Icons.mail_outline_rounded,
                iconColor: AppColors.textSecondary,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.email],
                validator: (value) => AppValidators.validateEmail(value, t),
              ),
              20.verticalSpace,
              AuthPrimaryButton(
                label: t.sendResetLink,
                icon: Icons.send_rounded,
                onPressed: sendResetLink,
                height: 52,
                fontSize: 16,
              ),
              24.verticalSpace,
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      t.rememberedPassword,
                      style: context.regular14TextSub,
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

class ResetPasswordHeroIllustration extends StatelessWidget {
  final double size;

  const ResetPasswordHeroIllustration({super.key, this.size = 110});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.softMint,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.lock_reset_rounded,
          size: size * 0.5,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }
}
