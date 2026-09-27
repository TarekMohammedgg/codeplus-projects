import 'package:doctor_hunt/apps/core/constants/app_route_paths.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_state.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/screens/signup_screen.dart';
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
      () => cubit.signUp(
        email: testEmail,
        password: testPassword,
        name: testName,
      ),
    ).thenAnswer((_) async {});
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      buildAuthTestApp(cubit: cubit, screen: const SignupScreen()),
    );
    await tester.pump();
  }

  Future<void> fillForm(WidgetTester tester) async {
    await tester.enterText(
      find.widgetWithText(TextFormField, tr.fullNameHint),
      testName,
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, tr.emailAddress),
      testEmail,
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, tr.passwordHint),
      testPassword,
    );
  }

  Future<void> tapTermsCheckbox(WidgetTester tester) async {
    await tester.ensureVisible(find.byType(Checkbox));
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
  }

  Future<void> tapSubmit(WidgetTester tester) async {
    await tester.ensureVisible(find.text(tr.createAccount));
    await tester.tap(find.text(tr.createAccount));
    await tester.pump();
  }

  group('initial state', () {
    testWidgets('shows the empty form with terms unticked', (tester) async {
      // act
      await pumpScreen(tester);

      // assert
      expect(find.text(tr.createYourAccount), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  group('submit', () {
    testWidgets('shows field errors when the form is empty', (tester) async {
      // arrange
      await pumpScreen(tester);

      // act
      await tapSubmit(tester);

      // assert
      expect(find.text(tr.enterFullName), findsOneWidget);
      expect(find.text(tr.enterEmailAddress), findsOneWidget);
      expect(find.text(tr.useAtLeast8Characters), findsOneWidget);
    });

    testWidgets('warns and does not sign up when terms are not accepted', (
      tester,
    ) async {
      // arrange
      await pumpScreen(tester);
      await fillForm(tester);

      // act
      await tapSubmit(tester);

      // assert
      expect(find.text(tr.acceptTermsAndPrivacyWarning), findsOneWidget);
      verifyNever(
        () => cubit.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      );
    });

    testWidgets('calls signUp with the entered values', (tester) async {
      // arrange
      await pumpScreen(tester);
      await fillForm(tester);
      await tapTermsCheckbox(tester);

      // act
      await tapSubmit(tester);

      // assert
      verify(
        () => cubit.signUp(
          email: testEmail,
          password: testPassword,
          name: testName,
        ),
      ).called(1);
    });
  });

  group('loading state', () {
    testWidgets('shows a spinner', (tester) async {
      // arrange
      startWithState(cubit, const AuthLoading(action: AuthAction.signUp));

      // act
      await pumpScreen(tester);

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('success state', () {
    testWidgets('shows the account created message', (tester) async {
      // arrange
      emitState(cubit, const AuthSuccess(action: AuthAction.signUp));

      // act
      await pumpScreen(tester);
      await tester.pump();

      // assert
      expect(find.text(tr.accountCreatedSuccess), findsOneWidget);
    });

    testWidgets('navigates to home', (tester) async {
      // arrange
      emitState(cubit, const AuthSuccess(action: AuthAction.signUp));

      // act
      await pumpScreen(tester);
      await tester.pumpAndSettle();

      // assert
      expect(find.text(AppRoutePaths.home), findsOneWidget);
    });
  });

  group('failure state', () {
    testWidgets('shows the error and keeps the form', (tester) async {
      // arrange
      const errorMessage = 'Email already in use';
      emitState(cubit, const AuthFailure.withMessage(errorMessage));

      // act
      await pumpScreen(tester);
      await tester.pump();

      // assert
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.text(tr.createYourAccount), findsOneWidget);
    });
  });
}
