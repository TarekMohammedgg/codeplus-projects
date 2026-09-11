import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/cubit/auth_state.dart';

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
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.shouldFail = false});

  final bool shouldFail;

  void _throwIfNeeded() {
    if (shouldFail) throw StateError('sign-in failed');
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _throwIfNeeded();
    throw StateError('not used in this test');
  }

  @override
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    throw StateError('not used in this test');
  }

  @override
  Future<UserCredential?> signInWithGoogle() async => null;

  @override
  Future<void> resetPassword({required String email}) async {}

  @override
  Future<bool> isCurrentUserAdmin() async => false;

  @override
  Future<void> signOut() async {}
}
