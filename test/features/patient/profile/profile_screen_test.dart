import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/repositories/profile_repository.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/screens/profile_screen.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/widgets/profile_header_section.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/widgets/profile_info_card.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/test_fakes.dart';

class _FakeProfileRepository implements ProfileRepository {
  _FakeProfileRepository({this.profile});

  final UserProfileModel? profile;

  @override
  Stream<UserProfileModel> streamProfile(String uid) {
    if (profile != null) {
      return Stream.value(profile!);
    }
    return const Stream.empty();
  }

  @override
  Future<void> updateProfile({
    required String uid,
    String? displayName,
    String? phone,
    DateTime? dob,
    String? gender,
    String? photoUrl,
    String? language,
    bool? notificationsEnabled,
  }) async {}
}

void main() {
  final testProfile = UserProfileModel(
    uid: 'user-123',
    name: 'Jane Doe',
    email: 'jane@example.com',
    phone: '+1234567890',
    dob: DateTime(1995, 5, 20),
    gender: 'Female',
    avatarUrl: 'https://example.com/avatar.png',
  );

  setUp(() {
    ensureTestServiceLocator();
    getIt.allowReassignment = true;
    getIt.registerLazySingleton<ProfileRepository>(
      () => _FakeProfileRepository(profile: testProfile),
    );
    getIt.registerLazySingleton<AuthRepository>(() => FakeAuthRepository());
    getIt.allowReassignment = false;
  });

  testWidgets(
    'ProfileScreen renders header, personal information cards without location, edit button and settings row',
    (WidgetTester tester) async {
      final tr = AppLocale.en.buildSync();
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestApp(ProfileScreen(profile: testProfile)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ProfileHeaderSection), findsOneWidget);
      expect(find.text(tr.profile), findsOneWidget);
      expect(find.text(tr.personalInformation), findsOneWidget);

      // 5 cards: Full name, Email, Contact number, Date of birth, Gender
      expect(find.byType(ProfileInfoCard), findsNWidgets(5));
      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.text('jane@example.com'), findsOneWidget);
      expect(find.text('+1234567890'), findsOneWidget);
      expect(find.textContaining('1995'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);

      // Out of scope location is NOT present
      expect(find.text(tr.location), findsNothing);

      // No back button in tab screen
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);

      // Edit button and Settings row
      expect(find.widgetWithText(AppPrimaryButton, tr.edit), findsOneWidget);
      expect(find.text(tr.settings), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    },
  );

  testWidgets('ProfileScreen renders "Not set" for empty profile fields', (
    WidgetTester tester,
  ) async {
    final tr = AppLocale.en.buildSync();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    const emptyProfile = UserProfileModel(
      uid: 'user-empty',
      name: '',
      email: '',
      phone: '',
    );

    await tester.pumpWidget(
      buildTestApp(const ProfileScreen(profile: emptyProfile)),
    );
    await tester.pumpAndSettle();

    expect(find.text(tr.notSet), findsWidgets);
  });

  testWidgets('Tapping Edit button and Settings row triggers navigation', (
    WidgetTester tester,
  ) async {
    final tr = AppLocale.en.buildSync();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final router = GoRouter(
      initialLocation: '/profile',
      routes: [
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileScreen(profile: testProfile),
        ),
        GoRoute(
          path: '/profile/edit',
          builder: (context, state) =>
              const Scaffold(body: Text('Edit Profile Screen')),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) =>
              const Scaffold(body: Text('Settings Screen')),
        ),
      ],
    );

    await tester.pumpWidget(buildTestRouterApp(router));
    await tester.pumpAndSettle();

    // Tap Edit button
    await tester.tap(find.widgetWithText(AppPrimaryButton, tr.edit));
    await tester.pumpAndSettle();
    expect(find.text('Edit Profile Screen'), findsOneWidget);

    // Return to Profile
    router.go('/profile');
    await tester.pumpAndSettle();

    // Tap Settings row
    await tester.tap(find.text(tr.settings));
    await tester.pumpAndSettle();
    expect(find.text('Settings Screen'), findsOneWidget);
  });

  testWidgets(
    'ProfileScreen renders cleanly on compact screen without overflow',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestApp(ProfileScreen(profile: testProfile)),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ProfileScreen), findsOneWidget);
    },
  );
}
