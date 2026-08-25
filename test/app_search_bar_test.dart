import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/core/widgets/app_search_bar.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'test_app.dart';

void main() {
  testWidgets('AppSearchBar renders with default hint and prefix icon', (
    WidgetTester tester,
  ) async {
    final tr = AppLocale.en.buildSync();

    await tester.pumpWidget(buildTestApp(const Scaffold(body: AppSearchBar())));

    expect(find.text(tr.searchDoctorHint), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);
  });

  testWidgets('AppSearchBar renders custom hintText and custom prefixIcon', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        const Scaffold(
          body: AppSearchBar(
            hintText: 'Custom Search Hint',
            prefixIcon: Icon(Icons.medical_services_rounded),
          ),
        ),
      ),
    );

    expect(find.text('Custom Search Hint'), findsOneWidget);
    expect(find.byIcon(Icons.medical_services_rounded), findsOneWidget);
  });

  testWidgets(
    'AppSearchBar shows clear button when text is entered and clears text and triggers callbacks on clear tap',
    (WidgetTester tester) async {
      final controller = TextEditingController();
      String changedText = '';
      bool clearCalled = false;

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: AppSearchBar(
              controller: controller,
              onChanged: (val) => changedText = val,
              onClear: () => clearCalled = true,
            ),
          ),
        ),
      );

      final initialVisibility = tester.widget<Visibility>(
        find.byWidgetPredicate((w) => w is Visibility && w.child is IconButton),
      );
      expect(initialVisibility.visible, isFalse);

      await tester.enterText(find.byType(TextField), 'Cardiologist');
      await tester.pump();

      expect(controller.text, 'Cardiologist');
      expect(changedText, 'Cardiologist');

      final activeVisibility = tester.widget<Visibility>(
        find.byWidgetPredicate((w) => w is Visibility && w.child is IconButton),
      );
      expect(activeVisibility.visible, isTrue);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();

      expect(controller.text, isEmpty);
      expect(changedText, isEmpty);
      expect(clearCalled, isTrue);

      final clearedVisibility = tester.widget<Visibility>(
        find.byWidgetPredicate((w) => w is Visibility && w.child is IconButton),
      );
      expect(clearedVisibility.visible, isFalse);
    },
  );

  testWidgets('AppSearchBar handles onSubmitted callback', (
    WidgetTester tester,
  ) async {
    String submittedText = '';

    await tester.pumpWidget(
      buildTestApp(
        Scaffold(body: AppSearchBar(onSubmitted: (val) => submittedText = val)),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Dentist');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    expect(submittedText, 'Dentist');
  });

  testWidgets('AppSearchBar handles readOnly and onTap', (
    WidgetTester tester,
  ) async {
    bool tapped = false;

    await tester.pumpWidget(
      buildTestApp(
        Scaffold(
          body: AppSearchBar(readOnly: true, onTap: () => tapped = true),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
