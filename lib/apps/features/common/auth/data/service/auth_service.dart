import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class AuthService {
  static String get serverClientId =>
      (dotenv.isInitialized ? dotenv.maybeGet('SERVER_CLIENT_ID') : null) ?? '';

  final FirebaseAuth? _auth;

  AuthService({FirebaseAuth? auth}) : _auth = auth ?? _safeAuth();

  static FirebaseAuth? _safeAuth() {
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  static Future<void> initialize() async {
    final clientId = serverClientId;
    await GoogleSignIn.instance.initialize(
      serverClientId: clientId.isNotEmpty ? clientId : null,
    );
  }

  User? get currentUser {
    try {
      return _auth?.currentUser;
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

    final user = userCredential.user;
    if (user != null) await ensureUserProfile(user);

    return userCredential;
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth!.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user != null) await ensureUserProfile(user);
    return credential;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final credential = GoogleAuthProvider.credential(
        idToken: googleUser.authentication.idToken,
      );

      final result = await _auth!.signInWithCredential(credential);
      final user = result.user;
      if (user != null) await ensureUserProfile(user);
      return result;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      throw AppException.fromGoogleSignIn(e);
    }
  }

  Future<void> ensureUserProfile(User user) async {
    final reference = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    final snapshot = await reference.get();
    final profile = {
      'displayName': user.displayName?.trim() ?? '',
      'email': user.email?.trim() ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (snapshot.exists) {
      await reference.set({
        ...profile,
        'permissions': FieldValue.delete(),
      }, SetOptions(merge: true));
      return;
    }

    await reference.set({
      ...profile,
      'role': 'patient',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> isCurrentUserAdmin() async {
    final user = currentUser;
    if (user == null) return false;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return snapshot.data()?['role'] == 'admin';
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
