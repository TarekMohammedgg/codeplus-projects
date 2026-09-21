import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/repositories/auth_repository.dart';

class CheckAdminStatusUseCase {
  const CheckAdminStatusUseCase(this._repository);

  final AuthRepository _repository;

  Future<bool> call() {
    return _repository.isCurrentUserAdmin();
  }
}
