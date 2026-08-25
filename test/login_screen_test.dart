import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/features/auth/presentation/screens/login_screen.dart';
import 'package:doctor_hunt/apps/features/auth/presentation/widgets/auth_buttons.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'test_app.dart';

void main() {
  testWidgets('LoginScreen renders Doctor Hunt UI components properly', (
    WidgetTester tester,
  ) async {
    final tr = AppLocale.en.buildSync();

    await tester.pumpWidget(buildTestApp(const LoginScreen()));

    expect(find.text(tr.welcomeBack), findsOneWidget);
    expect(find.text(tr.loginSubtitle), findsOneWidget);

    expect(find.text(tr.google), findsOneWidget);
    expect(find.text(tr.facebook), findsOneWidget);
    expect(find.byType(SocialMark), findsNWidgets(2));
    expect(find.byType(Image), findsWidgets);

    expect(find.text(tr.emailHint), findsOneWidget);
    expect(find.text(tr.enterPasswordHint), findsOneWidget);

    expect(find.text(tr.forgotPassword), findsOneWidget);
    expect(find.text(tr.logIn), findsOneWidget);

    expect(find.text(tr.dontHaveAccount), findsOneWidget);
    expect(find.text(tr.joinUs), findsOneWidget);
  });
}
