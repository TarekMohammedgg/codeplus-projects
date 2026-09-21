import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/validators.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_field.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_state.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/widgets/auth_buttons.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/widgets/auth_header.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, this.repository});

  final AuthRepository? repository;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AuthCubit _authCubit;

  bool _termsAccepted = false;

  @override
  void initState() {
    super.initState();
    _authCubit = widget.repository != null
        ? AuthCubit(repository: widget.repository!)
    //CR Bad DI: Avoid checking `getIt.isRegistered` with manual fallback instantiations in UI initState.
    //CR Use `getIt<Cubit>()` directly or inject via constructor.
        : (getIt.isRegistered<AuthCubit>()
              ? getIt<AuthCubit>()
              : AuthCubit(
    //CR Bad DI: Avoid checking `getIt.isRegistered` with manual fallback instantiations in UI initState.
    //CR Use `getIt<Cubit>()` directly or inject via constructor.
                  repository: getIt.isRegistered<AuthRepository>()
                      ? getIt<AuthRepository>()
                      : FirebaseAuthRepository(authService: AuthService()),
                ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _authCubit.close();
    super.dispose();
  }

  void _createAccount() {
    if (!_formKey.currentState!.validate()) return;
    if (!_termsAccepted) {
      context.showWarningSnackBar(
        //CR hardcode text
        'يرجى الموافقة على شروط الخدمة وسياسة الخصوصية للمتابعة.',
      );
      return;
    }
    FocusScope.of(context).unfocus();

    _authCubit.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
    );
  }

  void _signInWithGoogle() {
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
            case AuthSuccess(action: AuthAction.signUp):
              //CR hardcode text
              context.showSuccessSnackBar('تم إنشاء الحساب بنجاح!');
              const HomeRoute().go(context);
            case AuthSuccess(action: AuthAction.googleSignIn):
              const HomeRoute().go(context);
            default:
              break;
          }
        },
        builder: (context, state) {
          final isAnyLoading = state is AuthLoading;
          final isEmailLoading =
              state is AuthLoading && state.action == AuthAction.signUp;
          final isGoogleLoading =
              state is AuthLoading && state.action == AuthAction.googleSignIn;

          return Scaffold(
            backgroundColor: AppColors.background,
            body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    28.verticalSpace,
                    AuthHeader(
                      title: tr.createYourAccount,
                      subtitle: tr.signupSubtitle,
                    ),
                    32.verticalSpace,
                    SocialAuthButton(
                      label: tr.google,
                      image: Assets.assetsDesignGoogleLogo,
                      isLoading: isGoogleLoading,
                      onPressed: isAnyLoading ? null : _signInWithGoogle,
                    ),
                    32.verticalSpace,
                    AppTextField(
                      controller: _nameController,
                      hintText: tr.fullNameHint,
                      prefixIcon: Icons.person_outline_rounded,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      validator: (value) => AppValidators.validateName(value),
                    ),
                    18.verticalSpace,
                    AppTextField(
                      controller: _emailController,
                      hintText: tr.emailAddress,
                      prefixIcon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      validator: (value) => AppValidators.validateEmail(value),
                    ),
                    18.verticalSpace,
                    AppPasswordTextField(
                      controller: _passwordController,
                      hintText: tr.passwordHint,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: (value) =>
                          AppValidators.validatePassword(value),
                    ),
                    8.verticalSpace,
                    const _PasswordHintRow(),
                    20.verticalSpace,
                    _TermsCheckbox(
                      value: _termsAccepted,
                      disabled: isAnyLoading,
                      onChanged: (value) =>
                          setState(() => _termsAccepted = value ?? false),
                    ),
                    24.verticalSpace,
                    AppPrimaryButton(
                      label: tr.createAccount,
                      isLoading: isEmailLoading,
                      onPressed: isAnyLoading ? null : _createAccount,
                      height: 54,
                      fontSize: 16,
                    ),
                    28.verticalSpace,
                    _LoginFooter(disabled: isAnyLoading),
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

class _PasswordHintRow extends StatelessWidget {
  const _PasswordHintRow();

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class _TermsCheckbox extends StatelessWidget {
  final bool value;
  final bool disabled;
  final ValueChanged<bool?> onChanged;

  const _TermsCheckbox({
    required this.value,
    required this.onChanged,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: disabled ? null : onChanged,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        8.horizontalSpace,
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
                    style: context.semiBold14Primary.copyWith(fontSize: 13.5),
                  ),
                  TextSpan(text: tr.andText),
                  TextSpan(
                    text: tr.privacyPolicy,
                    style: context.semiBold14Primary.copyWith(fontSize: 13.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginFooter extends StatelessWidget {
  final bool disabled;

  const _LoginFooter({this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(tr.alreadyHaveAccount, style: context.regular14TextMain),
          //CR use primary widget (any reuse widget)
          TextButton(
            onPressed: disabled
                ? null
                : () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      const LoginRoute().go(context);
                    }
                  },
            //CR use primary widget (any reuse widget)
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
    );
  }
}
