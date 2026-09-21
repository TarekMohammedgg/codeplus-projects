import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/entities/user_entity.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/repositories/auth_repository.dart';

class AdminPermissionDeniedException implements Exception {
  const AdminPermissionDeniedException();
}

class SignInAsAdminUseCase {
  const SignInAsAdminUseCase(this._repository);

  final AuthRepository _repository;

  /// Signs in and rejects (and signs out) any account that is not an admin.
  Future<UserEntity> call({
    required String email,
    required String password,
  }) async {
    final user = await _repository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (!user.isAdmin) {
      await _repository.signOut();
      throw const AdminPermissionDeniedException();
    }
    return user;
  }
}
