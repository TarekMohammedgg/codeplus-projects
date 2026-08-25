import 'package:flutter_test/flutter_test.dart';
import 'package:pinput/pinput.dart';
import 'package:doctor_hunt/apps/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'test_app.dart';

void main() {
  testWidgets('OtpVerificationScreen renders all UI components properly', (
    WidgetTester tester,
  ) async {
    final tr = AppLocale.en.buildSync();

    await tester.pumpWidget(buildTestApp(const OtpVerificationScreen()));

    expect(find.text(tr.verifyYourNumber), findsOneWidget);
    expect(find.textContaining(tr.defaultPhoneNumber), findsOneWidget);

    expect(find.byType(Pinput), findsOneWidget);

    expect(find.text(tr.resendTimerDefault), findsOneWidget);
    expect(find.text(tr.resendCode), findsOneWidget);

    expect(find.text(tr.continueText), findsOneWidget);
  });
}
