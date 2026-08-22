import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_buttons.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    this.phoneNumber = '+20 10 1234 5678',
  });

  @override
  State<OtpVerificationScreen> createState() => OtpVerificationScreenState();
}

class OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final pinController = TextEditingController();
  final pinFocusNode = FocusNode();

  @override
  void dispose() {
    pinController.dispose();
    pinFocusNode.dispose();
    super.dispose();
  }

  void verifyOtp() {
    context.unfocus();
    const RoleSelectionRoute().push(context);
  }

  void resendCode() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.t.codeSentAgain)));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    final defaultPinTheme = PinTheme(
      width: 68,
      height: 84,
      textStyle: context.bold32TextMain,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline, width: 1.2),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColors.primaryGreen, width: 1.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140EBE7E),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: AuthBackButton(circular: true),
            ),
            16.verticalSpace,
            const Center(child: OtpVerificationHeroIllustration(size: 160)),
            24.verticalSpace,
            Text(
              t.verifyYourNumber,
              textAlign: TextAlign.center,
              style: context.bold28TextMain.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            8.verticalSpace,
            Text.rich(
              TextSpan(
                style: context.regular14TextSub.copyWith(
                  fontSize: 14.5,
                  height: 1.35,
                ),
                children: [
                  TextSpan(text: t.otpSentTo),
                  TextSpan(
                    text: widget.phoneNumber,
                    style: context.bold14TextMain.copyWith(fontSize: 14.5),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            32.verticalSpace,
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
                  height: 28,
                  color: AppColors.primaryGreen,
                ),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                onCompleted: (pin) => verifyOtp(),
              ),
            ),
            32.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  color: AppColors.success,
                  size: 20,
                ),
                8.horizontalSpace,
                Text(
                  t.resendTimerDefault,
                  style: context.bold16TextMain,
                ),
              ],
            ),
            14.verticalSpace,
            const Center(
              child: SizedBox(
                width: 80,
                child: Divider(color: AppColors.outline, thickness: 1.2),
              ),
            ),
            14.verticalSpace,
            Center(
              child: TextButton(
                onPressed: resendCode,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  textStyle: context.bold16Primary.copyWith(fontSize: 15),
                ),
                child: Text(t.resendCode),
              ),
            ),
            32.verticalSpace,
            AuthPrimaryButton(
              label: t.continueText,
              onPressed: verifyOtp,
              height: 54,
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class OtpVerificationHeroIllustration extends StatelessWidget {
  final double size;

  const OtpVerificationHeroIllustration({super.key, this.size = 120});

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
          Icons.mark_email_read_outlined,
          size: size * 0.5,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }
}
