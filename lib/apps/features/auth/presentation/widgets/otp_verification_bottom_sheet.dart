import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/phone_utils.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class OtpVerificationBottomSheet extends StatefulWidget {
  final String? phoneNumber;

  const OtpVerificationBottomSheet({
    super.key,
    this.phoneNumber,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    String? phoneNumber,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => OtpVerificationBottomSheet(
        phoneNumber: phoneNumber,
      ),
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
    final smsCode = pinController.text.trim();
    if (smsCode.length != 6) {
      context.showWarningSnackBar(tr.enterSixDigitOtp);
      return;
    }

    context.unfocus();
    Navigator.of(context).pop();
    context.showSuccessSnackBar(tr.phoneVerifiedSuccess);
    const RoleSelectionRoute().push(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    final defaultPinTheme = PinTheme(
      width: 46,
      height: 52,
      textStyle: context.bold20Primary,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline, width: 1.2),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColors.primary, width: 1.6),
      ),
    );

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
                Text(tr.otpCodeTitle, style: context.bold24TextMain),
                10.verticalSpace,
                Text(
                  widget.phoneNumber != null && widget.phoneNumber!.isNotEmpty
                      ? '${tr.otpSentTo} ${PhoneUtils.formatForDisplay(widget.phoneNumber)}'
                      : tr.otpCodeDescription,
                  style: context.regular14TextSecondary.copyWith(height: 1.4),
                ),
                28.verticalSpace,
                Center(
                  child: Pinput(
                    length: 6,
                    controller: pinController,
                    focusNode: pinFocusNode,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: defaultPinTheme,
                    showCursor: true,
                    cursor: Container(
                      width: 2,
                      height: 24,
                      color: AppColors.primary,
                    ),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    onCompleted: (pin) => onContinue(),
                  ),
                ),
                32.verticalSpace,
                ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(tr.continueText, style: context.semiBold16White),
                ),
                8.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
