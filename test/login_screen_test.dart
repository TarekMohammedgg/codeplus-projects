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
    final t = AppLocale.en.buildSync();

    await tester.pumpWidget(buildTestApp(const LoginScreen()));

    expect(find.text(t.welcomeBack), findsOneWidget);
    expect(find.text(t.loginSubtitle), findsOneWidget);

    expect(find.text(t.google), findsOneWidget);
    expect(find.text(t.facebook), findsOneWidget);
    expect(find.byType(SocialMark), findsNWidgets(2));
    expect(find.byType(Image), findsWidgets);

    expect(find.text(t.emailHint), findsOneWidget);
    expect(find.text(t.enterPasswordHint), findsOneWidget);

    expect(find.text(t.forgotPassword), findsOneWidget);
    expect(find.text(t.logIn), findsOneWidget);

    expect(find.text(t.dontHaveAccount), findsOneWidget);
    expect(find.text(t.joinUs), findsOneWidget);
  });
}
