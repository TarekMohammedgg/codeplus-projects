import 'package:doctor_hunt/apps/features/common/auth_clean_code/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  const ResetPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call({required String email}) {
    return _repository.resetPassword(email: email);
  }
}
