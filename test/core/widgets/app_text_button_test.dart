import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_button.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import '../../helpers/test_app.dart';

void main() {
  group('AppTextButton', () {
    testWidgets('renders label and triggers onPressed callback when tapped', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: AppTextButton(
              label: 'Text Action',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Text Action'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      expect(tapped, isTrue);
    });

    testWidgets(
      'shows loading indicator and disables press when isLoading is true',
      (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          buildTestApp(
            Scaffold(
              body: AppTextButton(
                label: 'Loading Action',
                isLoading: true,
                onPressed: () => tapped = true,
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading Action'), findsNothing);

        await tester.tap(find.byType(TextButton));
        expect(tapped, isFalse);
      },
    );

    testWidgets('renders icon alongside label when icon is provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: AppTextButton(
              label: 'Close',
              icon: Icons.close_rounded,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('respects custom foregroundColor and padding', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: AppTextButton(
              label: 'Custom Red',
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              onPressed: () {},
            ),
          ),
        ),
      );

      final textButton = tester.widget<TextButton>(find.byType(TextButton));
      expect(
        textButton.style?.padding?.resolve({}),
        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      );
      expect(textButton.style?.foregroundColor?.resolve({}), Colors.red);
    });

    testWidgets(
      'defaults its text style to the semiBold14 atom instead of a literal TextStyle',
      (WidgetTester tester) async {
        late BuildContext capturedContext;

        await tester.pumpWidget(
          buildTestApp(
            Builder(
              builder: (context) {
                capturedContext = context;
                return Scaffold(
                  body: AppTextButton(label: 'Default Style', onPressed: () {}),
                );
              },
            ),
          ),
        );

        final textButton = tester.widget<TextButton>(find.byType(TextButton));
        final resolvedStyle = textButton.style?.textStyle?.resolve({});
        final expectedStyle = capturedContext.semiBold14.copyWith(
          color: AppColors.primary,
        );

        expect(resolvedStyle?.fontSize, expectedStyle.fontSize);
        expect(resolvedStyle?.fontWeight, expectedStyle.fontWeight);
        expect(resolvedStyle?.color, AppColors.primary);
      },
    );
  });
}
