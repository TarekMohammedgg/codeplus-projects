import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'change_password_state.dart';

export 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit({required this.repository})
    : super(const ChangePasswordInitial());

  final AuthRepository repository;

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(const ChangePasswordSubmitting());
    try {
      await repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      emit(const ChangePasswordSuccess());
    } catch (e) {
      final appEx = AppException.from(e);
      emit(ChangePasswordFailure(appEx.message));
    }
  }
}
