import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/features/patient/profile/presentation/screens/privacy_policy_screen.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../helpers/test_app.dart';

void main() {
  testWidgets(
    'PrivacyPolicyScreen renders app bar, title, bullets, and content',
    (WidgetTester tester) async {
      final tr = AppLocale.en.buildSync();

      await tester.pumpWidget(buildTestApp(const PrivacyPolicyScreen()));
      await tester.pumpAndSettle();

      expect(find.text(tr.privacyPolicy), findsOneWidget);
      expect(find.text(tr.privacyPolicyTitle), findsOneWidget);
      expect(find.text(tr.privacyPolicyIntro), findsOneWidget);
      expect(find.text(tr.privacyPolicyBullet1), findsOneWidget);
      expect(find.text(tr.privacyPolicyBullet2), findsOneWidget);
      expect(find.text(tr.privacyPolicyBullet3), findsOneWidget);
      expect(find.text(tr.privacyPolicyBullet4), findsOneWidget);
      expect(find.text(tr.privacyPolicyOutro), findsOneWidget);
    },
  );
}
