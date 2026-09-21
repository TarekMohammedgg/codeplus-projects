import 'package:doctor_hunt/generated/i18n/translations.g.dart';

enum AuthAction {
  signIn,
  signUp,
  googleSignIn,
  resetPassword,
  adminSignIn,
  signOut,
}

enum AuthFailureCode { adminPermissionDenied }

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
  const AuthFailure({this.code}) : _errorMessage = null;

  const AuthFailure.withMessage(String message)
    : _errorMessage = message,
      code = null;

  final String? _errorMessage;
  final AuthFailureCode? code;

  String get errorMessage =>
      _errorMessage ??
      switch (code) {
        AuthFailureCode.adminPermissionDenied => tr.adminPermissionDenied,
        null => tr.unexpectedError,
      };
}
