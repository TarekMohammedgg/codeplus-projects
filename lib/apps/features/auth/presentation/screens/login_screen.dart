import 'package:flutter/material.dart';
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
  final _authService = AuthService();

  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    if (!formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);
    try {
      await _authService.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (!mounted) return;
      const HomeRoute().go(context);
    } catch (e) {
      if (!mounted) return;
      context.showErrorSnackBar(AppException.from(e).message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> signInWithGoogle() async {
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
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              28.verticalSpace,
              AuthHeader(title: tr.welcomeBack, subtitle: tr.loginSubtitle),
              32.verticalSpace,
              SocialAuthButton(
                label: tr.google,
                image: Assets.assetsDesignGoogleLogo,
                isLoading: _isGoogleLoading,
                onPressed: isAnyLoading ? null : signInWithGoogle,
              ),
              32.verticalSpace,
              AuthTextField(
                controller: emailController,
                hintText: tr.emailHint,
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
                hintText: tr.enterPasswordHint,
                prefixIcon: Icons.lock_outline_rounded,
                iconColor: AppColors.textSecondary,
                isPassword: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                validator: (value) => AppValidators.validateRequiredPassword(value),
              ),
              _ForgotPasswordButton(disabled: isAnyLoading),
              24.verticalSpace,
              AuthPrimaryButton(
                label: tr.logIn,
                isLoading: _isLoading,
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
        onPressed: disabled ? null : () => ForgotPasswordBottomSheet.show(context),
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
            onPressed: disabled ? null : () => const SignupRoute().push(context),
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
