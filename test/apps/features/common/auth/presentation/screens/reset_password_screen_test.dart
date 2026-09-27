import 'package:doctor_hunt/apps/core/constants/app_route_paths.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_state.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/screens/reset_password_screen.dart';
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
    when(() => cubit.resetPassword(email: testEmail)).thenAnswer((_) async {});
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      buildAuthTestApp(cubit: cubit, screen: const ResetPasswordScreen()),
    );
    await tester.pump();
  }

  Future<void> fillForm(WidgetTester tester, String email) async {
    await tester.enterText(
      find.widgetWithText(TextFormField, tr.emailHint),
      email,
    );
  }

  Future<void> tapSubmit(WidgetTester tester) async {
    await tester.ensureVisible(find.text(tr.sendResetLink));
    await tester.tap(find.text(tr.sendResetLink));
    await tester.pump();
  }

  group('initial state', () {
    testWidgets('shows the empty email form', (tester) async {
      // act
      await pumpScreen(tester);

      // assert
      expect(find.text(tr.resetYourPassword), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text(tr.sendResetLink), findsOneWidget);
    });
  });

  group('submit', () {
    testWidgets('shows an error and does not send when email is empty', (
      tester,
    ) async {
      // arrange
      await pumpScreen(tester);

      // act
      await tapSubmit(tester);

      // assert
      expect(find.text(tr.enterEmailAddress), findsOneWidget);
      verifyNever(() => cubit.resetPassword(email: any(named: 'email')));
    });

    testWidgets('calls resetPassword with the trimmed email', (tester) async {
      // arrange
      await pumpScreen(tester);
      await fillForm(tester, ' $testEmail ');

      // act
      await tapSubmit(tester);

      // assert
      verify(() => cubit.resetPassword(email: testEmail)).called(1);
    });
  });

  group('loading state', () {
    testWidgets('shows a spinner', (tester) async {
      // arrange
      startWithState(
        cubit,
        const AuthLoading(action: AuthAction.resetPassword),
      );

      // act
      await pumpScreen(tester);

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('success state', () {
    testWidgets('shows the reset link sent message', (tester) async {
      // arrange
      emitState(cubit, const AuthSuccess(action: AuthAction.resetPassword));

      // act
      await pumpScreen(tester);
      await tester.pump();

      // assert
      expect(find.text(tr.passwordResetSuccess), findsOneWidget);
    });

    testWidgets('returns to login', (tester) async {
      // arrange
      emitState(cubit, const AuthSuccess(action: AuthAction.resetPassword));

      // act
      await pumpScreen(tester);
      await tester.pumpAndSettle();

      // assert
      expect(find.text(AppRoutePaths.login), findsOneWidget);
    });
  });

  group('failure state', () {
    testWidgets('shows the error message', (tester) async {
      // arrange
      const errorMessage = 'No user found';
      emitState(cubit, const AuthFailure.withMessage(errorMessage));

      // act
      await pumpScreen(tester);
      await tester.pump();

      // assert
      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}
