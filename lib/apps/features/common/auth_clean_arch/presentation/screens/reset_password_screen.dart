import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/validators.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_field.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/presentation/controller/cubit/auth_state.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/presentation/widgets/auth_back_button.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/presentation/widgets/auth_hero_illustration.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/presentation/widgets/auth_navigation.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void sendResetLink() {
    context.unfocus();
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    _authCubit.resetPassword(email: emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        switch (state) {
          case AuthFailure(:final errorMessage):
            context.showErrorSnackBar(errorMessage);
          case AuthSuccess(action: AuthAction.resetPassword):
            context.showSuccessSnackBar(tr.passwordResetSuccess);
            context.popOrGoToLogin();
          default:
            break;
        }
      },
      builder: (context, state) {
        final isLoading =
            state is AuthLoading && state.action == AuthAction.resetPassword;

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
                  Row(
                    children: [
                      const AuthBackButton(circular: true),
                      const Spacer(),
                      Image.asset(
                        Assets.assetsDesignDoctorHuntLogo,
                        height: 28,
                      ),
                      const Spacer(),
                    ],
                  ),
                  18.verticalSpace,
                  const Center(
                    child: AuthHeroIllustration(
                      icon: Icons.lock_reset_rounded,
                      size: 110,
                    ),
                  ),
                  16.verticalSpace,
                  Text(
                    tr.resetYourPassword,
                    textAlign: TextAlign.center,
                    style: context.bold26TextMain,
                  ),
                  6.verticalSpace,
                  Text(
                    tr.resetPasswordSubtitle,
                    textAlign: TextAlign.center,
                    style: context.regular14TextSecondary.copyWith(
                      height: 1.35,
                    ),
                  ),
                  20.verticalSpace,
                  Text(tr.emailAddress, style: context.semiBold14TextMain),
                  6.verticalSpace,
                  AppTextField(
                    controller: emailController,
                    hintText: tr.emailHint,
                    prefixIcon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.email],
                    validator: (value) => AppValidators.validateEmail(value),
                  ),
                  20.verticalSpace,
                  AppPrimaryButton(
                    label: tr.sendResetLink,
                    icon: Icons.send_rounded,
                    isLoading: isLoading,
                    onPressed: isLoading ? null : sendResetLink,
                    height: 52,
                  ),
                  24.verticalSpace,
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          tr.rememberedPassword,
                          style: context.regular14TextSecondary,
                        ),
                        AppTextButton(
                          onPressed: context.popOrGoToLogin,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.only(left: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: context.semiBold14Primary,
                          label: tr.signIn,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
