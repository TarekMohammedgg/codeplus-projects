import 'package:doctor_hunt/apps/features/common/auth_clean_code/domain/entities/user_entity.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_code/domain/repositories/auth_repository.dart';

class SignInWithEmailUseCase {
  const SignInWithEmailUseCase(this._repository);

  final AuthRepository _repository;

  Future<UserEntity> call({required String email, required String password}) {
    return _repository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
