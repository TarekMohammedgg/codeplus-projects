import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/change_password_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/screens/change_password_screen.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/test_fakes.dart';

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
    ensureTestServiceLocator();
  });

  group('ChangePasswordCubit', () {
    test('emits submitting then success on successful change', () async {
      final fakeRepo = FakeAuthRepository();
      final cubit = ChangePasswordCubit(repository: fakeRepo);

      expectLater(
        cubit.stream,
        emitsInOrder([
          const ChangePasswordSubmitting(),
          const ChangePasswordSuccess(),
        ]),
      );

      await cubit.changePassword(
        currentPassword: 'oldPassword123',
        newPassword: 'newPassword123',
      );

      expect(fakeRepo.changePasswordCalled, isTrue);
      expect(fakeRepo.lastCurrentPassword, 'oldPassword123');
      expect(fakeRepo.lastNewPassword, 'newPassword123');
      await cubit.close();
    });

    test('emits submitting then failure when error occurs', () async {
      final fakeRepo = FakeAuthRepository(
        changePasswordError: 'Wrong current password. Please try again.',
      );
      final cubit = ChangePasswordCubit(repository: fakeRepo);

      expectLater(
        cubit.stream,
        emitsInOrder([
          const ChangePasswordSubmitting(),
          const ChangePasswordFailure(
            'Wrong current password. Please try again.',
          ),
        ]),
      );

      await cubit.changePassword(
        currentPassword: 'wrongPassword',
        newPassword: 'newPassword123',
      );
      await cubit.close();
    });
  });

  group('ChangePasswordScreen', () {
    testWidgets('renders all fields and submit button', (
      WidgetTester tester,
    ) async {
      final fakeRepo = FakeAuthRepository();
      final cubit = ChangePasswordCubit(repository: fakeRepo);

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<ChangePasswordCubit>.value(
            value: cubit,
            child: const ChangePasswordScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('current_password_input')), findsOneWidget);
      expect(find.byKey(const Key('new_password_input')), findsOneWidget);
      expect(
        find.byKey(const Key('confirm_new_password_input')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('change_password_submit_button')),
        findsOneWidget,
      );
      await cubit.close();
    });

    testWidgets('shows validation errors for empty fields', (
      WidgetTester tester,
    ) async {
      final fakeRepo = FakeAuthRepository();
      final cubit = ChangePasswordCubit(repository: fakeRepo);

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<ChangePasswordCubit>.value(
            value: cubit,
            child: const ChangePasswordScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('change_password_submit_button')));
      await tester.pumpAndSettle();

      expect(find.text(tr.enterPassword), findsNWidgets(2));
      expect(find.text(tr.useAtLeast8Characters), findsOneWidget);
      expect(fakeRepo.changePasswordCalled, isFalse);
      await cubit.close();
    });

    testWidgets('validates password min length and mismatch', (
      WidgetTester tester,
    ) async {
      final fakeRepo = FakeAuthRepository();
      final cubit = ChangePasswordCubit(repository: fakeRepo);

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<ChangePasswordCubit>.value(
            value: cubit,
            child: const ChangePasswordScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('current_password_input')),
        'validCurrent123',
      );
      await tester.enterText(
        find.byKey(const Key('new_password_input')),
        '123',
      );
      await tester.enterText(
        find.byKey(const Key('confirm_new_password_input')),
        '123456',
      );

      await tester.tap(find.byKey(const Key('change_password_submit_button')));
      await tester.pumpAndSettle();

      expect(find.text(tr.useAtLeast8Characters), findsOneWidget);
      expect(find.text(tr.passwordsDoNotMatch), findsOneWidget);
      expect(fakeRepo.changePasswordCalled, isFalse);
      await cubit.close();
    });

    testWidgets('submits valid form successfully', (WidgetTester tester) async {
      final fakeRepo = FakeAuthRepository();
      final cubit = ChangePasswordCubit(repository: fakeRepo);

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<ChangePasswordCubit>.value(
            value: cubit,
            child: const ChangePasswordScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('current_password_input')),
        'oldPassword123',
      );
      await tester.enterText(
        find.byKey(const Key('new_password_input')),
        'newPassword123',
      );
      await tester.enterText(
        find.byKey(const Key('confirm_new_password_input')),
        'newPassword123',
      );

      await tester.tap(find.byKey(const Key('change_password_submit_button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(fakeRepo.changePasswordCalled, isTrue);
      expect(find.text(tr.passwordChangedSuccess), findsOneWidget);
      await cubit.close();
    });
  });
}
