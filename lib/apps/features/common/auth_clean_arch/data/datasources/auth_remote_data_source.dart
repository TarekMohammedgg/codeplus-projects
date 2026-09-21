import 'package:doctor_hunt/apps/features/common/auth_clean_arch/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<UserModel?> signInWithGoogle();

  Future<void> sendPasswordResetEmail({required String email});

  Future<bool> isUserAdmin(String uid);

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();
}
