import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class AppException implements Exception {
  final String message;
  final String? code;

  const AppException({required this.message, this.code});

  factory AppException.fromFirebaseAuth(FirebaseAuthException e) {
    return AppException(
      message: _mapFirebaseAuthError(e.code, e.message),
      code: e.code,
    );
  }

  factory AppException.fromGoogleSignIn(GoogleSignInException e) {
    return AppException(
      message: _mapGoogleSignInError(e.code, e.description),
      code: e.code.name,
    );
  }

  factory AppException.from(Object error) {
    if (error is AppException) return error;
    if (error is FirebaseAuthException) {
      return AppException.fromFirebaseAuth(error);
    }
    if (error is GoogleSignInException) {
      return AppException.fromGoogleSignIn(error);
    }
    if (error is FirebaseException) {
      return AppException(
        message: error.message ?? tr.serviceError,
        code: error.code,
      );
    }
    return AppException(message: tr.unexpectedError);
  }

  static String _mapFirebaseAuthError(String code, [String? defaultMessage]) {
    switch (code) {
      case 'user-not-found':
        return tr.userNotFoundError;
      case 'wrong-password':
      case 'invalid-credential':
        return tr.wrongPasswordError;
      case 'email-already-in-use':
        return tr.emailAlreadyInUseError;
      case 'invalid-email':
        return tr.invalidEmailError;
      case 'weak-password':
        return tr.weakPasswordError;
      case 'user-disabled':
        return tr.userDisabledError;
      case 'too-many-requests':
        return tr.tooManyRequestsError;
      case 'network-request-failed':
        return tr.networkRequestFailedError;
      case 'account-exists-with-different-credential':
        return tr.accountExistsWithDifferentCredentialError;
      case 'operation-not-allowed':
        return tr.operationNotAllowedError;
      case 'invalid-verification-code':
        return tr.invalidVerificationCodeError;
      case 'invalid-verification-id':
        return tr.invalidVerificationIdError;
      case 'session-expired':
        return tr.sessionExpiredError;
      case 'invalid-phone-number':
        return tr.invalidPhoneNumberError;
      case 'quota-exceeded':
        return tr.quotaExceededError;
      case 'captcha-check-failed':
        return tr.captchaCheckFailedError;
      default:
        return defaultMessage ?? tr.unexpectedError;
    }
  }

  static String _mapGoogleSignInError(
    GoogleSignInExceptionCode code, [
    String? description,
  ]) {
    switch (code) {
      case GoogleSignInExceptionCode.clientConfigurationError:
        return tr.googleSignInConfigError;
      case GoogleSignInExceptionCode.interrupted:
        return tr.googleSignInInterruptedError;
      default:
        return description ?? tr.googleSignInFailedError;
    }
  }

  @override
  String toString() => message;
}
