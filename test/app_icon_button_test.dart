import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'test_app.dart';

void main() {
  testWidgets('AppIconButton renders default child and default dimensions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        const Scaffold(
          body: AppIconButton(
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(AppIconButton), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(AppIconButton),
        matching: find.byType(Container),
      ),
    );

    expect(container.constraints?.minWidth, 38.0);
    expect(container.constraints?.minHeight, 38.0);
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, AppColors.surface);
    expect(decoration.borderRadius, BorderRadius.circular(10));
    expect(decoration.boxShadow?.length, 1);
  });

  testWidgets('AppIconButton handles onTap callback', (
    WidgetTester tester,
  ) async {
    bool tapped = false;

    await tester.pumpWidget(
      buildTestApp(
        Scaffold(
          body: AppIconButton(
            onTap: () => tapped = true,
            child: const Icon(Icons.search_rounded),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(AppIconButton));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets(
    'AppIconButton.back constructor sets default back icon and handles tap',
    (WidgetTester tester) async {
      bool backTapped = false;

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(body: AppIconButton.back(onTap: () => backTapped = true)),
        ),
      );

      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);

      await tester.tap(find.byType(AppIconButton));
      await tester.pump();

      expect(backTapped, isTrue);
    },
  );

  testWidgets('AppIconButton supports custom styling, icon, and tooltip', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        const Scaffold(
          body: AppIconButton(
            icon: Icons.settings_rounded,
            iconSize: 22,
            iconColor: Colors.white,
            width: 44,
            height: 44,
            backgroundColor: AppColors.primary,
            tooltip: 'Settings Button',
            boxShadow: [],
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.settings_rounded), findsOneWidget);
    expect(find.byType(Tooltip), findsOneWidget);

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(AppIconButton),
        matching: find.byType(Container),
      ),
    );

    expect(container.constraints?.minWidth, 44.0);
    expect(container.constraints?.minHeight, 44.0);
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, AppColors.primary);
    expect(decoration.boxShadow, isNull);
  });
}
