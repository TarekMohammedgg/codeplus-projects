import 'package:firebase_auth/firebase_auth.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';

abstract interface class AuthRepository {
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<UserCredential?> signInWithGoogle();

  Future<void> resetPassword({required String email});

  Future<bool> isCurrentUserAdmin();

  Future<void> signOut();
}

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({required this.authService});

  final AuthService authService;

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) {
    return authService.signUpWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );
  }

  @override
  Future<UserCredential?> signInWithGoogle() {
    return authService.signInWithGoogle();
  }

  @override
  Future<void> resetPassword({required String email}) {
    return authService.forgetpassword(email: email);
  }

  @override
  Future<bool> isCurrentUserAdmin() {
    return authService.isCurrentUserAdmin();
  }

  @override
  Future<void> signOut() {
    return authService.signOut();
  }
}
