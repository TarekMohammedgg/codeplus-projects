import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/core/widgets/app_search_bar.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'test_app.dart';

void main() {
  testWidgets('AppHeaderSection renders greeting and title properly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        const Scaffold(
          body: AppHeaderSection(
            greeting: 'Hello Alex',
            title: 'Find Your Specialist',
          ),
        ),
      ),
    );

    expect(find.text('Hello Alex'), findsOneWidget);
    expect(find.text('Find Your Specialist'), findsOneWidget);
  });

  testWidgets('AppHeaderSection renders back button and handles onBackTap', (
    WidgetTester tester,
  ) async {
    bool backTapped = false;

    await tester.pumpWidget(
      buildTestApp(
        Scaffold(
          body: AppHeaderSection(
            title: 'Details',
            onBackTap: () => backTapped = true,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pump();

    expect(backTapped, isTrue);
  });

  testWidgets('AppHeaderSection renders settings and handles onSettingsTap', (
    WidgetTester tester,
  ) async {
    bool settingsTapped = false;

    await tester.pumpWidget(
      buildTestApp(
        Scaffold(
          body: AppHeaderSection(
            title: 'Home',
            onSettingsTap: () => settingsTapped = true,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.settings_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.settings_rounded));
    await tester.pump();

    expect(settingsTapped, isTrue);
  });

  testWidgets('AppHeaderSection renders custom trailing and bottom widgets', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        const Scaffold(
          body: AppHeaderSection(
            title: 'Custom Header',
            trailing: Text('TrailingAction'),
            bottom: Text('BottomContent'),
          ),
        ),
      ),
    );

    expect(find.text('Custom Header'), findsOneWidget);
    expect(find.text('TrailingAction'), findsOneWidget);
    expect(find.text('BottomContent'), findsOneWidget);
  });

  testWidgets(
    'AppHeaderSection integrates AppSearchBar and passes searchController',
    (WidgetTester tester) async {
      final searchController = TextEditingController();

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: AppHeaderSection(
              title: 'Search Page',
              searchController: searchController,
            ),
          ),
        ),
      );

      expect(find.byType(AppSearchBar), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Neurologist');
      await tester.pump();

      expect(searchController.text, 'Neurologist');
    },
  );

  testWidgets(
    'AppHeaderSection renders profile placeholder and handles onProfileTap',
    (WidgetTester tester) async {
      bool profileTapped = false;

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: AppHeaderSection(
              title: 'Profile Page',
              showProfile: true,
              onProfileTap: () => profileTapped = true,
            ),
          ),
        ),
      );

      expect(find.byType(DoctorAvatarPlaceholder), findsOneWidget);
      await tester.tap(find.byType(DoctorAvatarPlaceholder));
      await tester.pump();

      expect(profileTapped, isTrue);
    },
  );
}
