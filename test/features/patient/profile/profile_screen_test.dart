import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  Future<void> saveProfile({
    required String uid,
    required String name,
    required String phone,
    DateTime? dob,
    String? gender,
    String? currentPhotoUrl,
    Uint8List? newImageBytes,
    String? newImageName,
  }) async {}

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
    gender: Gender.female,
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
    'ProfileScreen renders header, personal information cards without location, and settings row',
    (WidgetTester tester) async {
      final tr = AppLocale.en.buildSync();
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestApp(_profileScreen(testProfile)));
      await tester.pumpAndSettle();

      expect(find.byType(ProfileHeaderSection), findsOneWidget);
      expect(find.text(tr.profile), findsOneWidget);
      expect(find.text(tr.personalInformation), findsOneWidget);

      expect(find.byType(ProfileInfoCard), findsNWidgets(5));
      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.text('jane@example.com'), findsOneWidget);
      expect(find.text('+1234567890'), findsOneWidget);
      expect(find.textContaining('1995'), findsOneWidget);
      expect(find.text(tr.female), findsOneWidget);

      expect(find.text(tr.location), findsNothing);

      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);

      expect(find.widgetWithText(AppPrimaryButton, tr.edit), findsNothing);
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

    await tester.pumpWidget(buildTestApp(_profileScreen(emptyProfile)));
    await tester.pumpAndSettle();

    expect(find.text(tr.notSet), findsWidgets);
  });

  testWidgets(
    'Tapping header edit button and Settings row triggers navigation',
    (WidgetTester tester) async {
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
            builder: (context, state) => _profileScreen(testProfile),
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

      final headerEditFinder = find.descendant(
        of: find.byType(ProfileHeaderSection),
        matching: find.byIcon(Icons.edit_outlined),
      );
      expect(headerEditFinder, findsOneWidget);
      await tester.tap(headerEditFinder);
      await tester.pumpAndSettle();
      expect(find.text('Edit Profile Screen'), findsOneWidget);

      router.go('/profile');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
      await tester.tap(find.byIcon(Icons.camera_alt_outlined));
      await tester.pumpAndSettle();
      expect(find.text('Edit Profile Screen'), findsOneWidget);

      router.go('/profile');
      await tester.pumpAndSettle();

      await tester.tap(find.text(tr.settings));
      await tester.pumpAndSettle();
      expect(find.text('Settings Screen'), findsOneWidget);
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

      await tester.pumpWidget(buildTestApp(_profileScreen(testProfile)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ProfileScreen), findsOneWidget);
    },
  );
}

Widget _profileScreen(UserProfileModel profile) {
  return BlocProvider<ProfileCubit>(
    create: (_) => ProfileCubit(
      repository: FakeProfileRepository(profile: profile),
      authRepository: FakeAuthRepository(),
    )..init(uid: profile.uid),
    child: const ProfileScreen(),
  );
}
