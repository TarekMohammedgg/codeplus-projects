import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/validators.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_field.dart';
import '../../data/service/auth_service.dart';

class ForgotPasswordBottomSheet extends StatefulWidget {
  const ForgotPasswordBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => const ForgotPasswordBottomSheet(),
    );
  }

  @override
  State<ForgotPasswordBottomSheet> createState() =>
      ForgotPasswordBottomSheetState();
}

class ForgotPasswordBottomSheetState extends State<ForgotPasswordBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> onContinue() async {
    context.unfocus();
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final email = emailController.text.trim();
    final nav = Navigator.of(context);
    setState(() => _isLoading = true);

    try {
      await _authService.forgetpassword(email: email);
      if (!mounted) return;
      nav.pop();
      context.showSuccessSnackBar(tr.passwordResetSuccess);
    } catch (e) {
      if (!mounted) return;
      nav.pop();
      context.showErrorSnackBar(AppException.from(e).message);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 54,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.outline,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  24.verticalSpace,
                  Text(tr.forgotPassword, style: context.bold24TextMain),
                  10.verticalSpace,
                  Text(
                    tr.forgotPasswordSubtitle,
                    style: context.regular14TextSecondary.copyWith(height: 1.4),
                  ),
                  24.verticalSpace,
                  AppTextField(
                    controller: emailController,
                    hintText: tr.emailAddress,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.email],
                    validator: (value) => AppValidators.validateEmail(value),
                    onFieldSubmitted: (_) => onContinue(),
                  ),
                  24.verticalSpace,
                  AppPrimaryButton(
                    label: tr.continueText,
                    isLoading: _isLoading,
                    onPressed: onContinue,
                    height: 52,
                  ),
                  8.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
