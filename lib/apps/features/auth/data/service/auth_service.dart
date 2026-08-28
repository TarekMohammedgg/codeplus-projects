import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class AuthService {
  static const String serverClientId =
      '618475193124-juj451gbe5ms155fpgalq5qj8r1v8a1g.apps.googleusercontent.com';

  final FirebaseAuth? _auth;

  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;
  static Future<void> initialize() async {
    await GoogleSignIn.instance.initialize(serverClientId: serverClientId);
  }

  User? get currentUser {
    try {
      return _auth!.currentUser;
    } catch (_) {
      return null;
    }
  }

  String getUserGreeting(BuildContext context) {
    final user = currentUser;
    final rawName = user?.displayName?.trim();
    final name = (rawName != null && rawName.isNotEmpty)
        ? rawName.split(' ').first
        : user?.email?.split('@').firstOrNull;

    final isArabic = TranslationProvider.of(context).locale == AppLocale.ar;
    if (name != null && name.isNotEmpty) {
      return isArabic ? 'مرحبًا $name 👋' : 'Hi $name 👋';
    }
    return tr.hiSteven;
  }

  Future<void> signOut() async {
    await Future.wait([_auth!.signOut(), GoogleSignIn.instance.signOut()]);
  }

  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    final userCredential = await _auth!.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (name != null && name.trim().isNotEmpty) {
      await userCredential.user?.updateDisplayName(name.trim());
      await userCredential.user?.reload();
    }

    return userCredential;
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _auth!.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final credential = GoogleAuthProvider.credential(
        idToken: googleUser.authentication.idToken,
      );

      return await _auth!.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      throw AppException.fromGoogleSignIn(e);
    }
  }

  Future<void> forgetpassword({required String email}) async {
    try {
      await _auth!.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuth(e);
    } catch (e) {
      throw AppException.from(e);
    }
  }
}
