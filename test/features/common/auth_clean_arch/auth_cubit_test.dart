import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/auth_clean_arch.dart';

void main() {
  late _FakeAuthRepository repository;
  late AuthCubit cubit;

  setUp(() {
    repository = _FakeAuthRepository();
    cubit = AuthCubit(
      signInWithEmailUseCase: SignInWithEmailUseCase(repository),
      signUpWithEmailUseCase: SignUpWithEmailUseCase(repository),
      signInWithGoogleUseCase: SignInWithGoogleUseCase(repository),
      resetPasswordUseCase: ResetPasswordUseCase(repository),
      checkAdminStatusUseCase: CheckAdminStatusUseCase(repository),
      signOutUseCase: SignOutUseCase(repository),
      getCurrentUserUseCase: GetCurrentUserUseCase(repository),
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  test('AuthCubit emits [AuthLoading, AuthFailure] when signIn fails', () async {
    repository.shouldFail = true;

    final states = expectLater(
      cubit.stream,
      emitsInOrder([isA<AuthLoading>(), isA<AuthFailure>()]),
    );

    await cubit.signIn(email: 'user@example.com', password: 'password');
    await states;

    expect((cubit.state as AuthFailure).errorMessage, isNotEmpty);
  });

  test('AuthCubit emits [AuthLoading, AuthSuccess] on successful signIn', () async {
    final states = expectLater(
      cubit.stream,
      emitsInOrder([isA<AuthLoading>(), isA<AuthSuccess>()]),
    );

    await cubit.signIn(email: 'user@example.com', password: 'password');
    await states;

    final success = cubit.state as AuthSuccess;
    expect(success.action, AuthAction.signIn);
    expect(success.user?.email, 'user@example.com');
  });

  test('AuthCubit emits [AuthLoading, AuthSuccess] on successful signUp', () async {
    final states = expectLater(
      cubit.stream,
      emitsInOrder([isA<AuthLoading>(), isA<AuthSuccess>()]),
    );

    await cubit.signUp(
      email: 'newuser@example.com',
      password: 'password',
      name: 'Dr. Test',
    );
    await states;

    final success = cubit.state as AuthSuccess;
    expect(success.action, AuthAction.signUp);
    expect(success.user?.displayName, 'Dr. Test');
  });

  test('AuthCubit emits adminPermissionDenied when signInAsAdmin user is not admin', () async {
    repository.isAdmin = false;

    final states = expectLater(
      cubit.stream,
      emitsInOrder([isA<AuthLoading>(), isA<AuthFailure>()]),
    );

    await cubit.signInAsAdmin(email: 'notadmin@example.com', password: 'password');
    await states;

    final failure = cubit.state as AuthFailure;
    expect(failure.code, AuthFailureCode.adminPermissionDenied);
  });

  test('AuthCubit emits [AuthLoading, AuthSuccess] on successful signOut', () async {
    final states = expectLater(
      cubit.stream,
      emitsInOrder([isA<AuthLoading>(), isA<AuthSuccess>()]),
    );

    await cubit.signOut();
    await states;

    final success = cubit.state as AuthSuccess;
    expect(success.action, AuthAction.signOut);
  });
}

class _FakeAuthRepository implements AuthRepository {
  bool shouldFail = false;
  bool isAdmin = true;

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (shouldFail) throw Exception('Invalid credentials');
    return UserEntity(
      id: 'uid_1',
      email: email,
      displayName: 'Test User',
      role: isAdmin ? 'admin' : 'patient',
    );
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    if (shouldFail) throw Exception('Registration failed');
    return UserEntity(
      id: 'uid_2',
      email: email,
      displayName: name,
      role: 'patient',
    );
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    if (shouldFail) throw Exception('Google sign in failed');
    return const UserEntity(
      id: 'uid_google',
      email: 'google@example.com',
      displayName: 'Google User',
    );
  }

  @override
  Future<void> resetPassword({required String email}) async {
    if (shouldFail) throw Exception('Reset failed');
  }

  @override
  Future<bool> isCurrentUserAdmin() async => isAdmin;

  @override
  Future<void> signOut() async {}

  @override
  Future<UserEntity?> getCurrentUser() async {
    return const UserEntity(
      id: 'uid_1',
      email: 'user@example.com',
      displayName: 'Test User',
    );
  }
}
