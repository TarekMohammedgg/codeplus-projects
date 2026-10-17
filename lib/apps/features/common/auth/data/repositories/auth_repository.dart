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

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  User? get currentUser;

  bool get hasPasswordProvider;

  Future<void> updateDisplayNameAndPhoto(String name, String? photoUrl);
}

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({required this.authService});

  final AuthService authService;

  @override
  bool get hasPasswordProvider => authService.hasPasswordProvider;

  @override
  Future<void> updateDisplayNameAndPhoto(String name, String? photoUrl) {
    return authService.updateDisplayNameAndPhoto(name, photoUrl);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return authService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

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
    return authService.resetPassword(email: email);
  }

  @override
  Future<bool> isCurrentUserAdmin() {
    return authService.isCurrentUserAdmin();
  }

  @override
  Future<void> signOut() {
    return authService.signOut();
  }

  @override
  User? get currentUser => authService.currentUser;
}
