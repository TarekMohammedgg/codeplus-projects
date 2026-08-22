import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/features/settings/presentation/screens/settings_screen.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'test_app.dart';

void main() {
  testWidgets('settings switches between English and Arabic', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp(const SettingsScreen()));

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('العربية'), findsOneWidget);

    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();

    expect(find.text('الإعدادات'), findsOneWidget);
    expect(find.text('اللغة'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
  });

  tearDown(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });
}
