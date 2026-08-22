import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/features/auth/presentation/screens/login_screen.dart';
import 'package:doctor_hunt/apps/features/auth/presentation/screens/signup_screen.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'test_app.dart';

void main() {
  testWidgets('Login and signup headers use matching typography', (
    WidgetTester tester,
  ) async {
    final t = AppLocale.en.buildSync();

    await tester.pumpWidget(buildTestApp(const LoginScreen()));
    final loginTitle = tester.widget<Text>(find.text(t.welcomeBack));
    final loginSubtitle = tester.widget<Text>(find.text(t.loginSubtitle));

    await tester.pumpWidget(buildTestApp(const SignupScreen()));
    final signupTitle = tester.widget<Text>(find.text(t.createYourAccount));
    final signupSubtitle = tester.widget<Text>(find.text(t.signupSubtitle));

    expect(signupTitle.style, loginTitle.style);
    expect(signupSubtitle.style, loginSubtitle.style);
    expect(signupTitle.softWrap, isTrue);
    expect(signupSubtitle.softWrap, isTrue);
  });
}
