import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/entities/user_entity.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/repositories/auth_repository.dart';

class SignUpWithEmailUseCase {
  const SignUpWithEmailUseCase(this._repository);

  final AuthRepository _repository;

  Future<UserEntity> call({
    required String email,
    required String password,
    required String name,
  }) {
    return _repository.signUpWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );
  }
}
