import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/features/auth/presentation/screens/signup_screen.dart';
import 'package:doctor_hunt/apps/features/auth/presentation/widgets/auth_buttons.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'test_app.dart';

void main() {
  testWidgets(
    'SignupScreen renders Google social signup button properly and excludes Facebook',
    (WidgetTester tester) async {
      final tr = AppLocale.en.buildSync();

      await tester.pumpWidget(buildTestApp(const SignupScreen()));

      expect(find.text(tr.createYourAccount), findsOneWidget);
      expect(find.text(tr.signupSubtitle), findsOneWidget);

      expect(find.text(tr.google), findsOneWidget);
      expect(find.text(tr.facebook), findsNothing);
      expect(find.byType(SocialMark), findsOneWidget);

      expect(find.text(tr.fullNameHint), findsOneWidget);
      expect(find.text(tr.emailAddress), findsOneWidget);
      expect(find.text(tr.passwordHint), findsOneWidget);
      expect(find.text(tr.createAccount), findsOneWidget);
    },
  );
}
