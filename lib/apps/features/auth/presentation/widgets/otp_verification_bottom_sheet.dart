import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class OtpVerificationBottomSheet extends StatefulWidget {
  final String? email;

  const OtpVerificationBottomSheet({super.key, this.email});

  static Future<T?> show<T>(BuildContext context, {String? email}) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => OtpVerificationBottomSheet(email: email),
    );
  }

  @override
  State<OtpVerificationBottomSheet> createState() =>
      OtpVerificationBottomSheetState();
}

class OtpVerificationBottomSheetState
    extends State<OtpVerificationBottomSheet> {
  final pinController = TextEditingController();
  final pinFocusNode = FocusNode();

  @override
  void dispose() {
    pinController.dispose();
    pinFocusNode.dispose();
    super.dispose();
  }

  void onContinue() {
    context.unfocus();
    Navigator.of(context).pop();
    const RoleSelectionRoute().push(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final t = context.t;

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: context.bold26Primary,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline, width: 1.2),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColors.primaryGreen, width: 1.6),
      ),
    );

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 14, 24, 24 + bottomInset),
      child: SingleChildScrollView(
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
              t.otpCodeTitle,
              style: context.bold24TextMain,
            ),
            10.verticalSpace,
            Text(
              widget.email == null || widget.email!.isEmpty
                  ? t.otpCodeDescription
                  : '${t.otpCodeDescription} ${widget.email}',
              style: context.regular14TextSub.copyWith(height: 1.4),
            ),
            28.verticalSpace,
            Center(
              child: Pinput(
                length: 4,
                controller: pinController,
                focusNode: pinFocusNode,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: defaultPinTheme,
                showCursor: true,
                cursor: Container(
                  width: 2,
                  height: 24,
                  color: AppColors.primaryGreen,
                ),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                onCompleted: (pin) => onContinue(),
              ),
            ),
            32.verticalSpace,
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
    );
  }
}
