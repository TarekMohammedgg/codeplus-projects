import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/router/app_router.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/test_fakes.dart';

import 'package:doctor_hunt/apps/core/services/app_preferences_service.dart';

void main() {
  Future<String> landAt(
    WidgetTester tester,
    String location, {
    bool signedIn = false,
    bool isAdmin = false,
    bool hasSeenOnboarding = false,
  }) async {
    final auth = FakeFirebaseAuth(mockUser: signedIn ? FakeUser() : null);
    final prefs = FakeSharedPreferences({
      'has_seen_onboarding': hasSeenOnboarding,
    });
    final router = AppRouter.createRouter(
      authRepository: FakeAuthRepository(auth: auth, isAdmin: isAdmin),
      firebaseAuth: auth,
      preferencesService: AppPreferencesService(preferences: prefs),
      initialLocation: location,
      routes: [
        for (final path in [
          '/',
          '/role-selection',
          '/login',
          '/signup',
          '/home',
          '/admin/doctors',
        ])
          GoRoute(
            path: path,
            builder: (_, _) => Scaffold(body: Text(path)),
          ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(buildTestRouterApp(router));
    await tester.pumpAndSettle();
    return router.state.matchedLocation;
  }

  testWidgets(
    'signed out with seen onboarding: onboarding route redirects to Choose Role',
    (tester) async {
      final location = await landAt(tester, '/', hasSeenOnboarding: true);

      expect(location, '/role-selection');
    },
  );

  testWidgets('signed out: onboarding and auth screens are reachable', (
    tester,
  ) async {
    final onboarding = await landAt(tester, '/');
    final login = await landAt(tester, '/login');

    expect(onboarding, '/');
    expect(login, '/login');
  });

  testWidgets('signed out: a protected page goes to Choose Role', (
    tester,
  ) async {
    final location = await landAt(tester, '/home');

    expect(location, '/role-selection');
  });

  testWidgets('signed-in patient skips onboarding to Home', (tester) async {
    final location = await landAt(tester, '/', signedIn: true);

    expect(location, '/home');
  });

  testWidgets('signed-in admin skips Choose Role to the admin doctors list', (
    tester,
  ) async {
    final location = await landAt(
      tester,
      '/role-selection',
      signedIn: true,
      isAdmin: true,
    );

    expect(location, '/admin/doctors');
  });

  testWidgets('signed-in admin reopening the app lands on admin pages', (
    tester,
  ) async {
    final location = await landAt(
      tester,
      '/home',
      signedIn: true,
      isAdmin: true,
    );

    expect(location, '/admin/doctors');
  });

  testWidgets('a patient cannot open admin pages', (tester) async {
    final location = await landAt(tester, '/admin/doctors', signedIn: true);

    expect(location, '/home');
  });
}
