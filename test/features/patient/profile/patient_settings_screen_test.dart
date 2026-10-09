import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/profile_cubit.dart';

import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/screens/patient_settings_screen.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/test_fakes.dart';

class _FakeUserInfo implements UserInfo {
  _FakeUserInfo(this.providerId);

  @override
  final String providerId;

  @override
  String? get displayName => null;

  @override
  String? get email => 'test@example.com';

  @override
  String? get phoneNumber => null;

  @override
  String? get photoURL => null;

  @override
  String get uid => 'user_123';
}

class _FakePasswordUser extends FakeUser {
  _FakePasswordUser({required super.uid, required super.email});

  @override
  List<UserInfo> get providerData => [_FakeUserInfo('password')];
}

class _FakeGoogleUser extends FakeUser {
  _FakeGoogleUser({required super.uid, required super.email});

  @override
  List<UserInfo> get providerData => [_FakeUserInfo('google.com')];
}

void main() {
  setUp(() {
    ensureTestServiceLocator();
  });

  testWidgets(
    'PatientSettingsScreen renders change password row when user has password provider',
    (WidgetTester tester) async {
      final user = _FakePasswordUser(
        uid: 'user_123',
        email: 'test@example.com',
      );
      final fakeAuth = FakeFirebaseAuth(user: user);
      final fakeRepo = FakeProfileRepository(
        profile: const UserProfileModel(uid: 'user_123', name: 'Test User'),
      );

      await tester.pumpWidget(
        buildTestApp(
          _settingsScreen(profileRepository: fakeRepo, auth: fakeAuth),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(tr.settings), findsOneWidget);
      expect(find.text(tr.accountSettings), findsOneWidget);
      expect(find.text(tr.changePassword), findsOneWidget);
      expect(find.text(tr.notifications), findsOneWidget);
      expect(find.text(tr.moreOptions), findsOneWidget);
      expect(find.text(tr.language), findsOneWidget);
      expect(find.text(tr.logOut), findsOneWidget);
    },
  );

  testWidgets(
    'PatientSettingsScreen hides change password row when user is Google-only',
    (WidgetTester tester) async {
      final user = _FakeGoogleUser(uid: 'user_123', email: 'test@example.com');
      final fakeAuth = FakeFirebaseAuth(user: user);
      final fakeRepo = FakeProfileRepository(
        profile: const UserProfileModel(uid: 'user_123', name: 'Test User'),
      );

      await tester.pumpWidget(
        buildTestApp(
          _settingsScreen(profileRepository: fakeRepo, auth: fakeAuth),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(tr.changePassword), findsNothing);
      expect(find.text(tr.notifications), findsOneWidget);
    },
  );

  testWidgets('Toggling notifications updates profile repository', (
    WidgetTester tester,
  ) async {
    final user = _FakePasswordUser(uid: 'user_123', email: 'test@example.com');
    final fakeAuth = FakeFirebaseAuth(user: user);
    final fakeRepo = FakeProfileRepository(
      profile: const UserProfileModel(
        uid: 'user_123',
        name: 'Test User',
        notificationsEnabled: true,
      ),
    );

    await tester.pumpWidget(
      buildTestApp(
        _settingsScreen(profileRepository: fakeRepo, auth: fakeAuth),
      ),
    );
    await tester.pumpAndSettle();

    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);

    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    expect(fakeRepo.lastUpdatedUid, equals('user_123'));
  });

  testWidgets('Tapping Language toggles locale', (WidgetTester tester) async {
    final user = _FakePasswordUser(uid: 'user_123', email: 'test@example.com');
    final fakeAuth = FakeFirebaseAuth(user: user);
    final fakeRepo = FakeProfileRepository(
      profile: const UserProfileModel(uid: 'user_123', name: 'Test User'),
    );

    await tester.pumpWidget(
      buildTestApp(
        _settingsScreen(profileRepository: fakeRepo, auth: fakeAuth),
      ),
    );
    await tester.pumpAndSettle();

    final initialLocale = LocaleSettings.currentLocale;
    await tester.tap(find.byKey(const Key('settings_language_tile')));
    await tester.pumpAndSettle();

    expect(LocaleSettings.currentLocale, isNot(equals(initialLocale)));
    // Restore
    await LocaleSettings.setLocale(AppLocale.en);
  });

  testWidgets('Logout confirmation dialog signs user out', (
    WidgetTester tester,
  ) async {
    final fakeAuthRepo = FakeAuthRepository();

    await tester.pumpWidget(
      buildTestApp(_settingsScreen(authRepository: fakeAuthRepo)),
    );
    await tester.pumpAndSettle();

    // Tap Log Out
    await tester.tap(find.byKey(const Key('settings_logout_button')));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text(tr.logOutConfirmTitle),
      ),
      findsOneWidget,
    );
    expect(find.text(tr.logOutConfirmMessage), findsOneWidget);

    // Tap confirm in dialog
    await tester.tap(find.widgetWithText(TextButton, tr.ok));
    await tester.pumpAndSettle();
  });
}

/// The screen with the cubits its route provides, backed by fakes.
Widget _settingsScreen({
  FakeProfileRepository? profileRepository,
  FirebaseAuth? auth,
  FakeAuthRepository? authRepository,
}) {
  final authRepo = authRepository ?? FakeAuthRepository(auth: auth);
  return MultiBlocProvider(
    providers: [
      BlocProvider<AuthCubit>(create: (_) => AuthCubit(repository: authRepo)),
      BlocProvider<ProfileCubit>(
        create: (_) => ProfileCubit(
          repository: profileRepository ?? FakeProfileRepository(),
          authRepository: authRepo,
        )..init(),
      ),
    ],
    child: const PatientSettingsScreen(),
  );
}
