import 'package:doctor_hunt/apps/core/constants/app_route_paths.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_state.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/screens/login_screen.dart';
import 'package:doctor_hunt/apps/features/common/role_selection/data/models/user_role.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../helpers/auth_mocks.dart';
import '../../../../../../helpers/test_app.dart';

void main() {
  setUpAll(() => LocaleSettings.setLocaleSync(AppLocale.en));

  late MockAuthCubit cubit;

  setUp(() {
    cubit = MockAuthCubit();
    startWithState(cubit, const AuthInitial());
    when(
      () => cubit.signIn(email: testEmail, password: testPassword),
    ).thenAnswer((_) async {});
    when(
      () => cubit.signInAsAdmin(email: testEmail, password: testPassword),
    ).thenAnswer((_) async {});
  });

  Future<void> pumpScreen(WidgetTester tester, {UserRole? role}) async {
    await tester.pumpWidget(
      buildAuthTestApp(
        cubit: cubit,
        screen: LoginScreen(role: role),
      ),
    );
    await tester.pump();
  }

  Future<void> fillForm(WidgetTester tester, {String? emailHint}) async {
    await tester.enterText(
      find.widgetWithText(TextFormField, emailHint ?? tr.emailHint),
      testEmail,
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, tr.enterPasswordHint),
      testPassword,
    );
  }

  Future<void> tapSubmit(WidgetTester tester) async {
    await tester.ensureVisible(find.text(tr.logIn));
    await tester.tap(find.text(tr.logIn));
    await tester.pump();
  }

  group('initial state', () {
    testWidgets('shows the empty patient login form', (tester) async {
      // act
      await pumpScreen(tester);

      // assert
      expect(find.text(tr.welcomeBack), findsOneWidget);
      expect(find.text(tr.google), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text(tr.forgotPassword), findsOneWidget);
      expect(find.text(tr.joinUs), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows the admin form without Google or sign up', (
      tester,
    ) async {
      // act
      await pumpScreen(tester, role: UserRole.admin);

      // assert
      expect(find.text(tr.adminLoginTitle), findsOneWidget);
      expect(find.text(tr.secureAdminAccessOnly), findsOneWidget);
      expect(find.text(tr.google), findsNothing);
      expect(find.text(tr.joinUs), findsNothing);
    });
  });

  group('submit', () {
    testWidgets('shows field errors and does not sign in when empty', (
      tester,
    ) async {
      // arrange
      await pumpScreen(tester);

      // act
      await tapSubmit(tester);

      // assert
      expect(find.text(tr.enterEmailAddress), findsOneWidget);
      expect(find.text(tr.enterPassword), findsOneWidget);
      verifyNever(
        () => cubit.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    });

    testWidgets('calls signIn with the entered values', (tester) async {
      // arrange
      await pumpScreen(tester);
      await fillForm(tester);

      // act
      await tapSubmit(tester);

      // assert
      verify(
        () => cubit.signIn(email: testEmail, password: testPassword),
      ).called(1);
    });

    testWidgets('calls signInAsAdmin for the admin role', (tester) async {
      // arrange
      await pumpScreen(tester, role: UserRole.admin);
      await fillForm(tester, emailHint: tr.adminEmailHint);

      // act
      await tapSubmit(tester);

      // assert
      verify(
        () => cubit.signInAsAdmin(email: testEmail, password: testPassword),
      ).called(1);
    });
  });

  group('loading state', () {
    testWidgets('shows a spinner and disables login', (tester) async {
      // arrange
      startWithState(cubit, const AuthLoading(action: AuthAction.signIn));

      // act
      await pumpScreen(tester);

      // assert
      final loginButton = tester.widget<ElevatedButton>(
        find.descendant(
          of: find.byType(AppPrimaryButton),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(loginButton.onPressed, isNull);
    });
  });

  group('success state', () {
    testWidgets('navigates a patient to home', (tester) async {
      // arrange
      emitState(cubit, const AuthSuccess(action: AuthAction.signIn));

      // act
      await pumpScreen(tester);
      await tester.pumpAndSettle();

      // assert
      expect(find.text(AppRoutePaths.home), findsOneWidget);
    });

    testWidgets('navigates to home after Google sign in', (tester) async {
      // arrange
      emitState(cubit, const AuthSuccess(action: AuthAction.googleSignIn));

      // act
      await pumpScreen(tester);
      await tester.pumpAndSettle();

      // assert
      expect(find.text(AppRoutePaths.home), findsOneWidget);
    });

    testWidgets('navigates an admin to the admin doctors screen', (
      tester,
    ) async {
      // arrange
      emitState(cubit, const AuthSuccess(action: AuthAction.adminSignIn));

      // act
      await pumpScreen(tester, role: UserRole.admin);
      await tester.pumpAndSettle();

      // assert
      expect(find.text(AppRoutePaths.adminDoctors), findsOneWidget);
    });
  });

  group('failure state', () {
    testWidgets('shows the error and keeps the form', (tester) async {
      // arrange
      const errorMessage = 'Wrong password';
      emitState(cubit, const AuthFailure.withMessage(errorMessage));

      // act
      await pumpScreen(tester);
      await tester.pump();

      // assert
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.text(tr.welcomeBack), findsOneWidget);
    });
  });
}
