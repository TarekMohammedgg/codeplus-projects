import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/edit_profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/repositories/profile_repository.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/screens/edit_profile_screen.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../../../../helpers/test_app.dart';
import '../../../../../../helpers/test_fakes.dart';

void main() {
  setUp(() {
    ensureTestServiceLocator();
  });

  final testProfile = UserProfileModel(
    uid: 'user_123',
    name: 'Jane Doe',
    email: 'jane@example.com',
    phone: '+201012345678',
    dob: DateTime(1995, 5, 20),
    gender: Gender.female,
    avatarUrl: 'https://example.com/avatar.jpg',
  );

  testWidgets(
    'EditProfileScreen pre-fills profile data and has read-only email',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestApp(_editScreen(testProfile)));
      await tester.pumpAndSettle();

      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.text('jane@example.com'), findsOneWidget);
      expect(find.text('+201012345678'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);

      final emailFinder = find.byKey(const Key('edit_profile_email_field'));
      final emailTextField = tester.widget<TextField>(
        find.descendant(of: emailFinder, matching: find.byType(TextField)),
      );
      expect(emailTextField.readOnly, isTrue);
    },
  );

  testWidgets('Gender selection toggles between male and female', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestApp(_editScreen(testProfile)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Male'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Female'));
    await tester.pumpAndSettle();
  });

  testWidgets(
    'Form validation blocks submission if name is empty or phone is invalid',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final fakeRepo = FakeProfileRepository();
      getIt.allowReassignment = true;
      getIt.registerLazySingleton<ProfileRepository>(() => fakeRepo);
      getIt.allowReassignment = false;

      await tester.pumpWidget(buildTestApp(_editScreen(testProfile, fakeRepo)));
      await tester.pumpAndSettle();

      final nameFinder = find.byKey(const Key('edit_profile_name_field'));
      await tester.enterText(nameFinder, '');
      await tester.pumpAndSettle();

      final saveFinder = find.byKey(const Key('edit_profile_save_button'));
      await tester.tap(saveFinder);
      await tester.pumpAndSettle();

      expect(find.text(tr.enterFullName), findsNWidgets(2));
      expect(fakeRepo.lastUpdatedUid, isNull);

      await tester.enterText(nameFinder, 'Valid Name');
      final phoneFinder = find.byKey(const Key('edit_profile_phone_field'));
      await tester.enterText(phoneFinder, '123');
      await tester.pumpAndSettle();

      await tester.tap(saveFinder);
      await tester.pumpAndSettle();

      expect(find.text(tr.enterValidPhoneNumber), findsOneWidget);
      expect(fakeRepo.lastUpdatedUid, isNull);
    },
  );

  testWidgets('Valid form saves profile and updates repository', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final fakeRepo = FakeProfileRepository();
    getIt.allowReassignment = true;
    getIt.registerLazySingleton<ProfileRepository>(() => fakeRepo);
    getIt.allowReassignment = false;

    await tester.pumpWidget(buildTestApp(_editScreen(testProfile, fakeRepo)));
    await tester.pumpAndSettle();

    final nameFinder = find.byKey(const Key('edit_profile_name_field'));
    await tester.enterText(nameFinder, 'Jane Smith');

    final phoneFinder = find.byKey(const Key('edit_profile_phone_field'));
    await tester.enterText(phoneFinder, '01098765432');
    await tester.pumpAndSettle();

    final saveFinder = find.byKey(const Key('edit_profile_save_button'));
    await tester.tap(saveFinder);
    await tester.pumpAndSettle();

    expect(fakeRepo.lastUpdatedUid, equals('user_123'));
    expect(fakeRepo.lastUpdatedDisplayName, equals('Jane Smith'));
    expect(fakeRepo.lastUpdatedPhone, equals('+201098765432'));
  });
}

Widget _editScreen(UserProfileModel profile, [FakeProfileRepository? repo]) {
  return BlocProvider<EditProfileCubit>(
    create: (_) => EditProfileCubit(
      repository: repo ?? FakeProfileRepository(),
      authRepository: FakeAuthRepository(
        currentUser: FakeUser(uid: 'user_123'),
      ),
    ),
    child: EditProfileScreen(profile: profile),
  );
}
