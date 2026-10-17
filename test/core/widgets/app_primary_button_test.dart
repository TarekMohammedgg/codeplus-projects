import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import '../../helpers/test_app.dart';

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

    testWidgets('applies custom width, height, and padding properly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: AppPrimaryButton(
              label: 'Custom Size',
              width: 150,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              onPressed: () {},
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find
            .ancestor(
              of: find.byType(ElevatedButton),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(sizedBox.width, 150);
      expect(sizedBox.height, 40);
    });

    testWidgets(
      'outlined constructor renders OutlinedButton and triggers callback',
      (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          buildTestApp(
            Scaffold(
              body: AppPrimaryButton.outlined(
                label: 'Outlined Action',
                onPressed: () => tapped = true,
              ),
            ),
          ),
        );

        expect(find.text('Outlined Action'), findsOneWidget);
        expect(find.byType(OutlinedButton), findsOneWidget);
        await tester.tap(find.byType(OutlinedButton));
        expect(tapped, isTrue);
      },
    );

    testWidgets(
      'outlined constructor shows loading indicator and disables press',
      (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          buildTestApp(
            Scaffold(
              body: AppPrimaryButton.outlined(
                label: 'Outlined Action',
                isLoading: true,
                onPressed: () => tapped = true,
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Outlined Action'), findsNothing);

        await tester.tap(find.byType(OutlinedButton));
        expect(tapped, isFalse);
      },
    );
  });
}
