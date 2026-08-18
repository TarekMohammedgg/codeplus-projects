import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinput/pinput.dart';
import 'package:medora/apps/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:medora/generated/app_strings.dart';

void main() {
  testWidgets('OtpVerificationScreen renders all UI components properly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: OtpVerificationScreen()));

    // Verify Title & Subtitle
    expect(find.text(AppStrings.verifyYourNumber), findsOneWidget);
    expect(find.textContaining(AppStrings.defaultPhoneNumber), findsOneWidget);

    // Verify Pinput
    expect(find.byType(Pinput), findsOneWidget);

    // Verify Timer and Resend code button
    expect(find.text(AppStrings.resendTimerDefault), findsOneWidget);
    expect(find.text(AppStrings.resendCode), findsOneWidget);

    // Verify Continue button
    expect(find.text(AppStrings.continueText), findsOneWidget);
  });
}
