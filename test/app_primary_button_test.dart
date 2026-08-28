import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'test_app.dart';

void main() {
  group('AppPrimaryButton', () {
    testWidgets('renders label and triggers onPressed callback when tapped', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: AppPrimaryButton(
              label: 'Submit',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      expect(tapped, isTrue);
    });

    testWidgets(
      'shows loading indicator and disables press when isLoading is true',
      (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          buildTestApp(
            Scaffold(
              body: AppPrimaryButton(
                label: 'Submit',
                isLoading: true,
                onPressed: () => tapped = true,
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Submit'), findsNothing);

        await tester.tap(find.byType(ElevatedButton));
        expect(tapped, isFalse);
      },
    );

    testWidgets('renders icon alongside label when icon is provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: AppPrimaryButton(
              label: 'Send',
              icon: Icons.send_rounded,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.send_rounded), findsOneWidget);
      expect(find.text('Send'), findsOneWidget);
    });
  });
}
