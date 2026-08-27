import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
        message: error.message ?? 'حدث خطأ في الخدمة، يرجى المحاولة لاحقاً.',
        code: error.code,
      );
    }
    return const AppException(
      message: 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى.',
    );
  }

  static String _mapFirebaseAuthError(String code, [String? defaultMessage]) {
    switch (code) {
      case 'user-not-found':
        return 'الحساب غير موجود، يرجى التأكد من البريد الإلكتروني.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'بيانات تسجيل الدخول غير صحيحة، يرجى المحاولة مرة أخرى.';
      case 'email-already-in-use':
        return 'هذا البريد الإلكتروني مستخدم بالفعل بحساب آخر.';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح.';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جدًا، يرجى اختيار كلمة مرور أقوى.';
      case 'user-disabled':
        return 'تم تعطيل هذا الحساب، يرجى التواصل مع الدعم.';
      case 'too-many-requests':
        return 'تم حظر المحاولات مؤقتًا لكثرة الطلبات، يرجى المحاولة لاحقًا.';
      case 'network-request-failed':
        return 'تعذر الاتصال بالشبكة، يرجى التحقق من اتصالك بالإنترنت.';
      case 'account-exists-with-different-credential':
        return 'يوجد حساب مسجل بالفعل ببيانات اعتماد مختلفة.';
      case 'operation-not-allowed':
        return 'طريقة تسجيل الدخول هذه غير مفعلة حاليًا.';
      default:
        return defaultMessage ?? 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى.';
    }
  }

  static String _mapGoogleSignInError(
    GoogleSignInExceptionCode code, [
    String? description,
  ]) {
    switch (code) {
      case GoogleSignInExceptionCode.clientConfigurationError:
        return 'خطأ في إعدادات Google Sign-In، يرجى التأكد من الـ SHA-1 و serverClientId.';
      case GoogleSignInExceptionCode.interrupted:
        return 'تمت مقاطعة عملية تسجيل الدخول، يرجى المحاولة ثانية.';
      default:
        return description ?? 'فشل تسجيل الدخول عبر Google.';
    }
  }

  @override
  String toString() => message;
}
