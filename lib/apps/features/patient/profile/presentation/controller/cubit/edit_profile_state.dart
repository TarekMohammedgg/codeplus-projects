import 'package:doctor_hunt/apps/core/errors/app_exception.dart';

sealed class EditProfileState {
  const EditProfileState();
}

final class EditProfileInitial extends EditProfileState {
  const EditProfileInitial();
}

final class EditProfileSaving extends EditProfileState {
  const EditProfileSaving();
}

final class EditProfileSuccess extends EditProfileState {
  const EditProfileSuccess();
}

final class EditProfileFailure extends EditProfileState {
  const EditProfileFailure(this.error);

  final AppErrorCode error;
}
