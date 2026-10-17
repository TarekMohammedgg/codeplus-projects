import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Semantic failure reasons. Data and Cubits pass these codes along; only the
/// UI turns them into localized text (see `AppErrorCodeText`).
enum AppErrorCode {
  userNotFound,
  wrongPassword,
  wrongCurrentPassword,
  emailAlreadyInUse,
  invalidEmail,
  weakPassword,
  userDisabled,
  tooManyRequests,
  networkRequestFailed,
  accountExistsWithDifferentCredential,
  operationNotAllowed,
  requiresRecentLogin,
  googleSignInConfig,
  googleSignInInterrupted,
  googleSignInFailed,
  adminPermissionDenied,
  uploadImage,
  alreadyReviewed,
  appointmentNotCompleted,
  ratingRequired,
  service,
  unexpected,
}

class AppException implements Exception {
  const AppException(this.code);

  final AppErrorCode code;

  factory AppException.from(Object error) {
    return switch (error) {
      AppException() => error,
      FirebaseAuthException(:final code) => AppException(_authCode(code)),
      GoogleSignInException(:final code) => AppException(switch (code) {
        GoogleSignInExceptionCode.clientConfigurationError =>
          AppErrorCode.googleSignInConfig,
        GoogleSignInExceptionCode.interrupted =>
          AppErrorCode.googleSignInInterrupted,
        _ => AppErrorCode.googleSignInFailed,
      }),
      FirebaseException() => const AppException(AppErrorCode.service),
      _ => const AppException(AppErrorCode.unexpected),
    };
  }

  static AppErrorCode _authCode(String code) => switch (code) {
    'user-not-found' => AppErrorCode.userNotFound,
    'wrong-password' || 'invalid-credential' => AppErrorCode.wrongPassword,
    'email-already-in-use' => AppErrorCode.emailAlreadyInUse,
    'invalid-email' => AppErrorCode.invalidEmail,
    'weak-password' => AppErrorCode.weakPassword,
    'user-disabled' => AppErrorCode.userDisabled,
    'too-many-requests' => AppErrorCode.tooManyRequests,
    'network-request-failed' => AppErrorCode.networkRequestFailed,
    'account-exists-with-different-credential' =>
      AppErrorCode.accountExistsWithDifferentCredential,
    'operation-not-allowed' => AppErrorCode.operationNotAllowed,
    'requires-recent-login' => AppErrorCode.requiresRecentLogin,
    _ => AppErrorCode.unexpected,
  };

  @override
  String toString() => 'AppException(${code.name})';
}

class SlotAlreadyBookedException implements Exception {
  const SlotAlreadyBookedException();
}

class DoctorUnavailableException implements Exception {
  const DoctorUnavailableException();
}

class ReviewNotAllowedException implements Exception {
  const ReviewNotAllowedException();
}
