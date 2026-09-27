import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../helpers/auth_mocks.dart';

void main() {
  late MockAuthService service;
  late FirebaseAuthRepository repository;
  late MockUserCredential credential;

  setUp(() {
    service = MockAuthService();
    repository = FirebaseAuthRepository(authService: service);
    credential = MockUserCredential();
  });

  group('signInWithEmailAndPassword', () {
    test('returns the credential from the service', () async {
      // arrange
      when(
        () => service.signInWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        ),
      ).thenAnswer((_) async => credential);

      // act
      final result = await repository.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );

      // assert
      expect(result, same(credential));
    });

    test('passes service errors to the caller', () async {
      // arrange
      when(
        () => service.signInWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        ),
      ).thenAnswer((_) async => throw const AppException(message: 'failed'));

      // act
      final call = repository.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );

      // assert
      await expectLater(call, throwsA(isA<AppException>()));
    });
  });

  test('signUpWithEmailAndPassword returns the credential', () async {
    // arrange
    when(
      () => service.signUpWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
        name: testName,
      ),
    ).thenAnswer((_) async => credential);

    // act
    final result = await repository.signUpWithEmailAndPassword(
      email: testEmail,
      password: testPassword,
      name: testName,
    );

    // assert
    expect(result, same(credential));
  });

  group('signInWithGoogle', () {
    test('returns the credential on success', () async {
      // arrange
      when(
        () => service.signInWithGoogle(),
      ).thenAnswer((_) async => credential);

      // act
      final result = await repository.signInWithGoogle();

      // assert
      expect(result, same(credential));
    });

    test('returns null when the user cancels', () async {
      // arrange
      when(() => service.signInWithGoogle()).thenAnswer((_) async => null);

      // act
      final result = await repository.signInWithGoogle();

      // assert
      expect(result, isNull);
    });
  });

  test('resetPassword sends the email to the service', () async {
    // arrange
    when(
      () => service.forgetpassword(email: testEmail),
    ).thenAnswer((_) async {});

    // act
    await repository.resetPassword(email: testEmail);

    // assert
    verify(() => service.forgetpassword(email: testEmail)).called(1);
  });

  test('isCurrentUserAdmin returns the service result', () async {
    // arrange
    when(() => service.isCurrentUserAdmin()).thenAnswer((_) async => true);

    // act
    final result = await repository.isCurrentUserAdmin();

    // assert
    expect(result, isTrue);
  });

  test('signOut calls the service', () async {
    // arrange
    when(() => service.signOut()).thenAnswer((_) async {});

    // act
    await repository.signOut();

    // assert
    verify(() => service.signOut()).called(1);
  });

  group('currentUser', () {
    test('returns the signed-in user', () {
      // arrange
      final user = MockUser();
      when(() => service.currentUser).thenReturn(user);

      // act
      final result = repository.currentUser;

      // assert
      expect(result, same(user));
    });

    test('returns null when nobody is signed in', () {
      // arrange
      when(() => service.currentUser).thenReturn(null);

      // act
      final result = repository.currentUser;

      // assert
      expect(result, isNull);
    });
  });
}
