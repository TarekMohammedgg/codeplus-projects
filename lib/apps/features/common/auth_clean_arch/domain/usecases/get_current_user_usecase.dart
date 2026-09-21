import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/entities/user_entity.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  Future<UserEntity?> call() {
    return _repository.getCurrentUser();
  }
}
