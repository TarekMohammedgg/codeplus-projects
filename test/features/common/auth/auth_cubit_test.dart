import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_state.dart';

void main() {
  test('AuthCubit exposes loading and failure for a failed sign-in', () async {
    final cubit = AuthCubit(repository: _FakeAuthRepository(shouldFail: true));
    final states = expectLater(
      cubit.stream,
      emitsInOrder([isA<AuthLoading>(), isA<AuthFailure>()]),
    );

    await cubit.signIn(email: 'user@example.com', password: 'password');
    await states;

    expect((cubit.state as AuthFailure).errorMessage, isNotEmpty);
    await cubit.close();
  });

  test('AuthCubit emits success for sign-out', () async {
    final cubit = AuthCubit(repository: _FakeAuthRepository());
    final states = expectLater(
      cubit.stream,
      emitsInOrder([isA<AuthLoading>(), isA<AuthSuccess>()]),
    );

    await cubit.signOut();
    await states;

    expect((cubit.state as AuthSuccess).action, AuthAction.signOut);
    await cubit.close();
  });

  test('patient sign-in succeeds with the signIn action', () async {
    // arrange
    final cubit = AuthCubit(repository: _FakeAuthRepository());

    // act
    await cubit.signIn(email: 'user@example.com', password: 'password');

    // assert
    expect((cubit.state as AuthSuccess).action, AuthAction.signIn);
    await cubit.close();
  });

  test('admin login by a non-admin signs out and reports the code', () async {
    // arrange
    final repository = _FakeAuthRepository();
    final cubit = AuthCubit(repository: repository);

    // act
    await cubit.signInAsAdmin(email: 'user@example.com', password: 'password');

    // assert
    expect(repository.signedOut, isTrue);
    expect(
      (cubit.state as AuthFailure).code,
      AuthFailureCode.adminPermissionDenied,
    );
    await cubit.close();
  });

  test('admin login by an admin succeeds and stays signed in', () async {
    // arrange
    final repository = _FakeAuthRepository(isAdmin: true);
    final cubit = AuthCubit(repository: repository);

    // act
    await cubit.signInAsAdmin(email: 'admin@example.com', password: 'password');

    // assert
    expect((cubit.state as AuthSuccess).action, AuthAction.adminSignIn);
    expect(repository.signedOut, isFalse);
    await cubit.close();
  });

  test('cancelled Google sign-in returns to the initial state', () async {
    // arrange
    final cubit = AuthCubit(repository: _FakeAuthRepository());

    // act
    await cubit.signInWithGoogle();

    // assert
    expect(cubit.state, isA<AuthInitial>());
    await cubit.close();
  });
}

class _FakeUserCredential extends Fake implements UserCredential {}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.shouldFail = false, this.isAdmin = false});

  final bool shouldFail;
  final bool isAdmin;
  bool signedOut = false;

  void _throwIfNeeded() {
    if (shouldFail) throw StateError('sign-in failed');
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _throwIfNeeded();
    return _FakeUserCredential();
  }

  @override
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    throw StateError('not used in this test');
  }

  /// Null = the user cancelled the Google picker.
  @override
  Future<UserCredential?> signInWithGoogle() async => null;

  @override
  Future<void> resetPassword({required String email}) async {}

  @override
  Future<bool> isCurrentUserAdmin() async => isAdmin;

  @override
  Future<void> signOut() async => signedOut = true;

  @override
  User? get currentUser => null;
}
