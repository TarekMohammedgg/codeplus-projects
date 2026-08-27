import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/features/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/profile/presentation/screens/profile_screen.dart';
import 'package:doctor_hunt/apps/features/profile/presentation/widgets/profile_header_section.dart';
import 'package:doctor_hunt/apps/features/profile/presentation/widgets/profile_info_card.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'test_app.dart';

void main() {
  testWidgets(
    'ProfileScreen renders header, personal information cards and log out button with passed data',
    (WidgetTester tester) async {
      final tr = AppLocale.en.buildSync();
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const profile = UserProfileModel(
        name: 'Dr. John Doe',
        contactNumber: '+1234567890',
        dateOfBirth: '01 01 1990',
        location: 'New York, USA',
      );

      await tester.pumpWidget(
        buildTestApp(const ProfileScreen(profile: profile)),
      );

      expect(find.byType(ProfileHeaderSection), findsOneWidget);
      expect(find.text(tr.profile), findsOneWidget);
      expect(find.text(tr.setUpYourProfile), findsOneWidget);
      expect(find.text(tr.personalInformation), findsOneWidget);
      expect(find.byType(ProfileInfoCard), findsNWidgets(4));
      expect(find.text('Dr. John Doe'), findsOneWidget);
      expect(find.text('+1234567890'), findsOneWidget);
      expect(find.text('01 01 1990'), findsOneWidget);
      expect(find.text('New York, USA'), findsOneWidget);
      expect(find.text(tr.logOut), findsOneWidget);
      expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
    },
  );

  testWidgets(
    'ProfileScreen renders cleanly with empty default profile from auth',
    (WidgetTester tester) async {
      final tr = AppLocale.en.buildSync();
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestApp(const ProfileScreen()));

      expect(find.byType(ProfileHeaderSection), findsOneWidget);
      expect(find.text(tr.profile), findsOneWidget);
      expect(find.text(tr.personalInformation), findsOneWidget);
      expect(find.byType(ProfileInfoCard), findsNWidgets(4));
      expect(find.text(tr.logOut), findsOneWidget);
    },
  );

  testWidgets(
    'ProfileScreen renders cleanly on compact screen without overflow',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestApp(const ProfileScreen()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ProfileScreen), findsOneWidget);
    },
  );
}
