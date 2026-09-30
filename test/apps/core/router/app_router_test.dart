import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/router/app_router.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/test_fakes.dart';

void main() {
  /// Pumps the real redirect over stub pages and returns where it landed.
  Future<String> landAt(
    WidgetTester tester,
    String location, {
    bool signedIn = false,
    bool isAdmin = false,
  }) async {
    final auth = FakeFirebaseAuth(mockUser: signedIn ? FakeUser() : null);
    final router = AppRouter.createRouter(
      authRepository: FakeAuthRepository(auth: auth, isAdmin: isAdmin),
      firebaseAuth: auth,
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

  testWidgets('signed out: onboarding and auth screens are reachable', (
    tester,
  ) async {
    // act
    final onboarding = await landAt(tester, '/');
    final login = await landAt(tester, '/login');

    // assert
    expect(onboarding, '/');
    expect(login, '/login');
  });

  testWidgets('signed out: a protected page goes to Choose Role', (
    tester,
  ) async {
    // act
    final location = await landAt(tester, '/home');

    // assert
    expect(location, '/role-selection');
  });

  testWidgets('signed-in patient skips onboarding to Home', (tester) async {
    // act
    final location = await landAt(tester, '/', signedIn: true);

    // assert
    expect(location, '/home');
  });

  testWidgets('signed-in admin skips Choose Role to the admin doctors list', (
    tester,
  ) async {
    // act
    final location = await landAt(
      tester,
      '/role-selection',
      signedIn: true,
      isAdmin: true,
    );

    // assert
    expect(location, '/admin/doctors');
  });

  testWidgets('a patient cannot open admin pages', (tester) async {
    // act
    final location = await landAt(tester, '/admin/doctors', signedIn: true);

    // assert
    expect(location, '/home');
  });
}
