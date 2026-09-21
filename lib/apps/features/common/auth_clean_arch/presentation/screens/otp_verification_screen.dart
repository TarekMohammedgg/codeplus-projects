import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/phone_utils.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_button.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/presentation/widgets/auth_back_button.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/presentation/widgets/auth_hero_illustration.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => OtpVerificationScreenState();
}

class OtpVerificationScreenState extends State<OtpVerificationScreen> {
  static const _otpLength = 6;
  static const _resendSeconds = 60;
  // Stand-ins for the network calls until phone verification is implemented.
  static const _sendCodeDelay = Duration(milliseconds: 400);
  static const _verifyDelay = Duration(milliseconds: 300);

  final pinController = TextEditingController();
  final pinFocusNode = FocusNode();

  bool _isSendingCode = false;
  bool _isVerifying = false;
  int _remainingSeconds = _resendSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    pinController.dispose();
    pinFocusNode.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _remainingSeconds = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _sendOtpCode() async {
    if (_isSendingCode) return;
    setState(() => _isSendingCode = true);

    await Future.delayed(_sendCodeDelay);
    if (!mounted) return;
    setState(() => _isSendingCode = false);
    _startTimer();
    context.showSuccessSnackBar(tr.codeSentAgain);
  }

  Future<void> verifyOtp() async {
    final smsCode = pinController.text.trim();
    if (smsCode.length != _otpLength) {
      context.showWarningSnackBar(context.tr.enterSixDigitOtp);
      return;
    }

    context.unfocus();
    setState(() => _isVerifying = true);

    await Future.delayed(_verifyDelay);
    if (!mounted) return;
    setState(() => _isVerifying = false);
    context.showSuccessSnackBar(context.tr.phoneVerifiedSuccess);
    const HomeRoute().push(context);
  }

  void resendCode() {
    if (_remainingSeconds > 0 || _isSendingCode) return;
    _sendOtpCode();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 46,
      height: 52,
      textStyle: context.bold20TextMain,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppTheme.fieldRadius,
        border: Border.all(color: AppColors.outline, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowSubtle,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppTheme.fieldRadius,
        border: Border.all(color: AppColors.primary, width: 1.8),
        boxShadow: const [
          BoxShadow(
            color: AppColors.boxShadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
    );

    final isResendActive = _remainingSeconds == 0 && !_isSendingCode;

    return Scaffold(
      backgroundColor: AppColors.background,
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
            const Center(
              child: AuthHeroIllustration(
                icon: Icons.mark_email_read_outlined,
                size: 160,
              ),
            ),
            24.verticalSpace,
            Text(
              tr.verifyYourNumber,
              textAlign: TextAlign.center,
              style: context.bold28TextMain.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            8.verticalSpace,
            Text.rich(
              TextSpan(
                style: context.regular14TextSecondary.copyWith(
                  fontSize: 14.5,
                  height: 1.35,
                ),
                children: [
                  TextSpan(text: tr.otpSentTo),
                  TextSpan(
                    text: PhoneUtils.formatForDisplay(widget.phoneNumber),
                    style: context.bold14TextMain.copyWith(fontSize: 14.5),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            32.verticalSpace,
            Center(
              child: Pinput(
                length: _otpLength,
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
                onCompleted: (pin) => verifyOtp(),
              ),
            ),
            32.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: _remainingSeconds > 0
                      ? AppColors.success
                      : AppColors.textSecondary,
                  size: 20,
                ),
                8.horizontalSpace,
                Text(
                  _remainingSeconds == _resendSeconds
                      ? tr.resendTimerDefault
                      : '0:${_remainingSeconds.toString().padLeft(2, '0')}',
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
              child: AppTextButton(
                onPressed: isResendActive ? resendCode : null,
                label: tr.resendCode,
                isLoading: _isSendingCode,
                foregroundColor: isResendActive
                    ? AppColors.primary
                    : AppColors.textSecondary.withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                textStyle: context.bold16Primary.copyWith(fontSize: 15),
              ),
            ),
            32.verticalSpace,
            AppPrimaryButton(
              label: tr.continueText,
              isLoading: _isVerifying,
              onPressed: (_isVerifying || _isSendingCode) ? null : verifyOtp,
            ),
          ],
        ),
      ),
    );
  }
}
