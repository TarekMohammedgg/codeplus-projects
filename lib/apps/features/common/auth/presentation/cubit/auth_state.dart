enum AuthAction {
  signIn,
  signUp,
  googleSignIn,
  resetPassword,
  adminSignIn,
  signOut,
}

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading({required this.action});

  final AuthAction action;
}

final class AuthSuccess extends AuthState {
  const AuthSuccess({required this.action});

  final AuthAction action;
}

final class AuthFailure extends AuthState {
  const AuthFailure({required this.errorMessage});

  final String errorMessage;
}
