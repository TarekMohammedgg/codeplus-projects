import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/validators.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'otp_verification_bottom_sheet.dart';

class ForgotPasswordBottomSheet extends StatefulWidget {
  const ForgotPasswordBottomSheet({super.key});

  static Future<T?> show<T>(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
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

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void onContinue() {
    context.unfocus();
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final email = emailController.text.trim();
    Navigator.of(context).pop();
    OtpVerificationBottomSheet.show(context, email: email);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final t = context.t;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 14, 24, 24 + bottomInset),
      child: SingleChildScrollView(
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
              Text(
                t.forgotPassword,
                style: context.bold24TextMain,
              ),
              10.verticalSpace,
              Text(
                t.forgotPasswordSubtitle,
                style: context.regular14TextSub.copyWith(height: 1.4),
              ),
              24.verticalSpace,
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.email],
                validator: (value) => AppValidators.validateEmail(value, t),
                decoration: InputDecoration(
                  hintText: t.emailAddress,
                  hintStyle: context.regular14TextSub.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primaryGreen,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              24.verticalSpace,
              ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  t.continueText,
                  style: context.semiBold16White,
                ),
              ),
              8.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
