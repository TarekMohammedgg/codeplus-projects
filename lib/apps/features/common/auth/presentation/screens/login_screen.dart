import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_field.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/cubit/auth_state.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/widgets/auth_buttons.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/widgets/auth_header.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/widgets/forgot_password_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/validators.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.repository});

  final AuthRepository? repository;

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = AuthCubit(
      repository:
          widget.repository ??
          FirebaseAuthRepository(authService: AuthService()),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _authCubit.close();
    super.dispose();
  }

  void signIn() {
    if (!formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    _authCubit.signIn(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  void signInWithGoogle() {
    FocusScope.of(context).unfocus();
    _authCubit.signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authCubit,
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          switch (state) {
            case AuthFailure(:final errorMessage):
              context.showErrorSnackBar(errorMessage);
            case AuthSuccess(action: AuthAction.signIn) ||
                AuthSuccess(action: AuthAction.googleSignIn):
              const HomeRoute().go(context);
            default:
              break;
          }
        },
        builder: (context, state) {
          final isAnyLoading = state is AuthLoading;
          final isEmailLoading =
              state is AuthLoading && state.action == AuthAction.signIn;
          final isGoogleLoading =
              state is AuthLoading && state.action == AuthAction.googleSignIn;

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
                      title: tr.welcomeBack,
                      subtitle: tr.loginSubtitle,
                    ),
                    32.verticalSpace,
                    SocialAuthButton(
                      label: tr.google,
                      image: Assets.assetsDesignGoogleLogo,
                      isLoading: isGoogleLoading,
                      onPressed: isAnyLoading ? null : signInWithGoogle,
                    ),
                    32.verticalSpace,
                    AppTextField(
                      controller: emailController,
                      hintText: tr.emailHint,
                      prefixIcon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      validator: (value) => AppValidators.validateEmail(value),
                    ),
                    18.verticalSpace,
                    AppTextField(
                      controller: passwordController,
                      hintText: tr.enterPasswordHint,
                      prefixIcon: Icons.lock_outline_rounded,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      validator: (value) =>
                          AppValidators.validateRequiredPassword(value),
                    ),
                    _ForgotPasswordButton(disabled: isAnyLoading),
                    24.verticalSpace,
                    AppPrimaryButton(
                      label: tr.logIn,
                      isLoading: isEmailLoading,
                      onPressed: isAnyLoading ? null : signIn,
                      height: 54,
                      fontSize: 16,
                    ),
                    28.verticalSpace,
                    _SignUpFooter(disabled: isAnyLoading),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  final bool disabled;

  const _ForgotPasswordButton({this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: disabled
            ? null
            : () => ForgotPasswordBottomSheet.show(context),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: context.medium14Primary.copyWith(fontSize: 13.5),
        ),
        child: Text(tr.forgotPassword),
      ),
    );
  }
}

class _SignUpFooter extends StatelessWidget {
  final bool disabled;

  const _SignUpFooter({this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(tr.dontHaveAccount, style: context.regular14TextSecondary),
          TextButton(
            onPressed: disabled
                ? null
                : () => const SignupRoute().push(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.only(left: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: context.semiBold14Primary,
            ),
            child: Text(tr.joinUs),
          ),
        ],
      ),
    );
  }
}
