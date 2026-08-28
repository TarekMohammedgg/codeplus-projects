import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/validators.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_field.dart';
import 'package:doctor_hunt/apps/features/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/auth/presentation/widgets/auth_buttons.dart';
import 'package:doctor_hunt/apps/features/auth/presentation/widgets/auth_header.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _termsAccepted = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_termsAccepted) {
      context.showWarningSnackBar(
        'يرجى الموافقة على شروط الخدمة وسياسة الخصوصية للمتابعة.',
      );
      return;
    }
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);
    try {
      await _authService.signUpWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
      );
      if (!mounted) return;
      context.showSuccessSnackBar('تم إنشاء الحساب بنجاح!');
      const RoleSelectionRoute().go(context);
    } catch (e) {
      if (!mounted) return;
      context.showErrorSnackBar(AppException.from(e).message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    FocusScope.of(context).unfocus();
    setState(() => _isGoogleLoading = true);
    try {
      final credential = await _authService.signInWithGoogle();
      if (!mounted) return;
      if (credential != null) const HomeRoute().go(context);
    } catch (e) {
      if (!mounted) return;
      context.showErrorSnackBar(AppException.from(e).message);
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
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
                isLoading: _isGoogleLoading,
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
              AppTextField(
                controller: _passwordController,
                hintText: tr.passwordHint,
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                validator: (value) => AppValidators.validatePassword(value),
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
                isLoading: _isLoading,
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
