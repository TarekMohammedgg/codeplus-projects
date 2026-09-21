import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call() {
    return _repository.signOut();
  }
}
