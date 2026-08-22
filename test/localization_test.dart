import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'test_app.dart';

void main() {
  testWidgets('translations rebuild when the locale changes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp(const TranslationProbe()));
    expect(find.text('Doctor Hunt'), findsOneWidget);
    expect(AppLocale.en.buildSync().live, 'LIVE');

    await LocaleSettings.setLocale(AppLocale.ar);
    await tester.pumpAndSettle();

    expect(find.text('دكتور هانت'), findsOneWidget);
    expect(AppLocale.ar.buildSync().live, 'مباشر');
  });
}

class TranslationProbe extends StatelessWidget {
  const TranslationProbe({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(context.t.appName);
  }
}
