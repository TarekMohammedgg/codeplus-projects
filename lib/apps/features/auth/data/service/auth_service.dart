import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:doctor_hunt/apps/core/errors/app_exception.dart';

class AuthService {
  static const String serverClientId =
      '618475193124-juj451gbe5ms155fpgalq5qj8r1v8a1g.apps.googleusercontent.com';

  final FirebaseAuth? _customAuth;

  AuthService({FirebaseAuth? auth}) : _customAuth = auth;

  FirebaseAuth get _auth => _customAuth ?? FirebaseAuth.instance;

  User? get currentUser {
    try {
      return _auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  Stream<User?> get authStateChanges {
    try {
      return _auth.authStateChanges();
    } catch (_) {
      return const Stream.empty();
    }
  }

  static Future<void> initialize() async {
    await GoogleSignIn.instance.initialize(serverClientId: serverClientId);
  }

  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), GoogleSignIn.instance.signOut()]);
  }

  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
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
    return _auth.signInWithEmailAndPassword(
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

      return await _auth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      throw AppException.fromGoogleSignIn(e);
    }
  }
}
