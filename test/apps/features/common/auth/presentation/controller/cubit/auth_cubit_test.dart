import 'package:bloc_test/bloc_test.dart';
import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_state.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../../helpers/auth_mocks.dart';

Matcher isLoading(AuthAction action) =>
    isA<AuthLoading>().having((s) => s.action, 'action', action);

Matcher isSuccess(AuthAction action) =>
    isA<AuthSuccess>().having((s) => s.action, 'action', action);

Matcher isFailure(String message) =>
    isA<AuthFailure>().having((s) => s.errorMessage, 'errorMessage', message);

void main() {
  setUpAll(() => LocaleSettings.setLocaleSync(AppLocale.en));

  late MockAuthRepository repository;

  const error = AppException(message: 'Something failed');

  setUp(() => repository = MockAuthRepository());

  AuthCubit buildCubit() => AuthCubit(repository: repository);

  test('initial state is AuthInitial', () {
    // arrange
    final cubit = buildCubit();

    // act
    final state = cubit.state;

    // assert
    expect(state, isA<AuthInitial>());
  });

  group('signIn', () {
    blocTest<AuthCubit, AuthState>(
      'emits [loading, success] when sign in succeeds',
      // arrange
      setUp: () => when(
        () => repository.signInWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        ),
      ).thenAnswer((_) async => MockUserCredential()),
      build: buildCubit,
      // act
      act: (cubit) => cubit.signIn(email: testEmail, password: testPassword),
      // assert
      expect: () => [
        isLoading(AuthAction.signIn),
        isSuccess(AuthAction.signIn),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [loading, failure] when sign in fails',
      // arrange
      setUp: () => when(
        () => repository.signInWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        ),
      ).thenAnswer((_) async => throw error),
      build: buildCubit,
      // act
      act: (cubit) => cubit.signIn(email: testEmail, password: testPassword),
      // assert
      expect: () => [isLoading(AuthAction.signIn), isFailure(error.message)],
      errors: () => [error],
    );
  });

  group('signUp', () {
    blocTest<AuthCubit, AuthState>(
      'emits [loading, success] when sign up succeeds',
      // arrange
      setUp: () => when(
        () => repository.signUpWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
          name: testName,
        ),
      ).thenAnswer((_) async => MockUserCredential()),
      build: buildCubit,
      // act
      act: (cubit) => cubit.signUp(
        email: testEmail,
        password: testPassword,
        name: testName,
      ),
      // assert
      expect: () => [
        isLoading(AuthAction.signUp),
        isSuccess(AuthAction.signUp),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [loading, failure] when sign up fails',
      // arrange
      setUp: () => when(
        () => repository.signUpWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
          name: testName,
        ),
      ).thenAnswer((_) async => throw error),
      build: buildCubit,
      // act
      act: (cubit) => cubit.signUp(
        email: testEmail,
        password: testPassword,
        name: testName,
      ),
      // assert
      expect: () => [isLoading(AuthAction.signUp), isFailure(error.message)],
      errors: () => [error],
    );
  });

  group('signInWithGoogle', () {
    blocTest<AuthCubit, AuthState>(
      'emits [loading, success] when Google returns a credential',
      // arrange
      setUp: () => when(
        () => repository.signInWithGoogle(),
      ).thenAnswer((_) async => MockUserCredential()),
      build: buildCubit,
      // act
      act: (cubit) => cubit.signInWithGoogle(),
      // assert
      expect: () => [
        isLoading(AuthAction.googleSignIn),
        isSuccess(AuthAction.googleSignIn),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'goes back to initial when the user cancels Google sign in',
      // arrange
      setUp: () => when(
        () => repository.signInWithGoogle(),
      ).thenAnswer((_) async => null),
      build: buildCubit,
      // act
      act: (cubit) => cubit.signInWithGoogle(),
      // assert
      expect: () => [isLoading(AuthAction.googleSignIn), isA<AuthInitial>()],
    );
  });

  group('signInAsAdmin', () {
    blocTest<AuthCubit, AuthState>(
      'emits [loading, success] for an admin account',
      // arrange
      setUp: () {
        when(
          () => repository.signInWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          ),
        ).thenAnswer((_) async => MockUserCredential());
        when(
          () => repository.isCurrentUserAdmin(),
        ).thenAnswer((_) async => true);
      },
      build: buildCubit,
      // act
      act: (cubit) =>
          cubit.signInAsAdmin(email: testEmail, password: testPassword),
      // assert
      expect: () => [
        isLoading(AuthAction.adminSignIn),
        isSuccess(AuthAction.adminSignIn),
      ],
      verify: (_) => verifyNever(() => repository.signOut()),
    );

    blocTest<AuthCubit, AuthState>(
      'signs out and emits permission failure for a non-admin account',
      // arrange
      setUp: () {
        when(
          () => repository.signInWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          ),
        ).thenAnswer((_) async => MockUserCredential());
        when(
          () => repository.isCurrentUserAdmin(),
        ).thenAnswer((_) async => false);
        when(() => repository.signOut()).thenAnswer((_) async {});
      },
      build: buildCubit,
      // act
      act: (cubit) =>
          cubit.signInAsAdmin(email: testEmail, password: testPassword),
      // assert
      expect: () => [
        isLoading(AuthAction.adminSignIn),
        isFailure(tr.adminPermissionDenied),
      ],
      verify: (_) => verify(() => repository.signOut()).called(1),
    );
  });

  group('resetPassword', () {
    blocTest<AuthCubit, AuthState>(
      'emits [loading, success] when the reset email is sent',
      // arrange
      setUp: () => when(
        () => repository.resetPassword(email: testEmail),
      ).thenAnswer((_) async {}),
      build: buildCubit,
      // act
      act: (cubit) => cubit.resetPassword(email: testEmail),
      // assert
      expect: () => [
        isLoading(AuthAction.resetPassword),
        isSuccess(AuthAction.resetPassword),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [loading, failure] when sending fails',
      // arrange
      setUp: () => when(
        () => repository.resetPassword(email: testEmail),
      ).thenAnswer((_) async => throw error),
      build: buildCubit,
      // act
      act: (cubit) => cubit.resetPassword(email: testEmail),
      // assert
      expect: () => [
        isLoading(AuthAction.resetPassword),
        isFailure(error.message),
      ],
      errors: () => [error],
    );
  });

  group('signOut', () {
    blocTest<AuthCubit, AuthState>(
      'emits [loading, success] when sign out succeeds',
      // arrange
      setUp: () => when(() => repository.signOut()).thenAnswer((_) async {}),
      build: buildCubit,
      // act
      act: (cubit) => cubit.signOut(),
      // assert
      expect: () => [
        isLoading(AuthAction.signOut),
        isSuccess(AuthAction.signOut),
      ],
    );
  });
}
