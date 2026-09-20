import 'package:doctor_hunt/apps/features/common/auth_clean_code/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<UserEntity?> signInWithGoogle();

  Future<void> resetPassword({required String email});

  Future<bool> isCurrentUserAdmin();

  Future<void> signOut();

  Future<UserEntity?> getCurrentUser();
}
