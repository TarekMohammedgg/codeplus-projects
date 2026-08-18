import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import 'package:medora/apps/core/router/routes.dart';
import 'package:medora/generated/app_strings.dart';
import 'package:medora/generated/app_styles.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/otp_verification_hero_illustration.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    this.phoneNumber = AppStrings.defaultPhoneNumber,
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
    FocusScope.of(context).unfocus();
    context.push(Routes.roleSelection);
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 68,
      height: 84,
      textStyle: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppStyles.navy,
      ),
      decoration: BoxDecoration(
        color: AppStyles.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppStyles.outline, width: 1.2),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppStyles.primaryBlue, width: 1.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x141D69EE),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: AppStyles.surface,
      ),
    );

    return Scaffold(
      backgroundColor: AppStyles.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppStyles.pageHorizontalPadding,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: AuthBackButton(circular: true),
              ),
              const SizedBox(height: 16),
              const Center(child: OtpVerificationHeroIllustration(size: 160)),
              const SizedBox(height: 24),
              Text(
                AppStrings.verifyYourNumber,
                textAlign: TextAlign.center,
                style: AppStyles.display.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  style: AppStyles.body.copyWith(
                    color: AppStyles.textSecondary,
                    fontSize: 14.5,
                    height: 1.35,
                  ),
                  children: [
                    const TextSpan(text: AppStrings.otpSentTo),
                    TextSpan(
                      text: widget.phoneNumber,
                      style: const TextStyle(
                        color: AppStyles.navy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Center(
                child: Pinput(
                  length: 4,
                  controller: pinController,
                  focusNode: pinFocusNode,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  showCursor: true,
                  cursor: Container(
                    width: 2,
                    height: 28,
                    color: AppStyles.primaryBlue,
                  ),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  onCompleted: (pin) => verifyOtp(),
                ),
              ),
              const SizedBox(height: 32),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: AppStyles.success,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    AppStrings.resendTimerDefault,
                    style: TextStyle(
                      color: AppStyles.navy,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Center(
                child: SizedBox(
                  width: 80,
                  child: Divider(color: AppStyles.outline, thickness: 1.2),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: AppStyles.primaryBlue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text(AppStrings.resendCode),
                ),
              ),
              const SizedBox(height: 32),
              AuthPrimaryButton(
                label: AppStrings.continueText,
                onPressed: verifyOtp,
                height: 54,
                fontSize: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
