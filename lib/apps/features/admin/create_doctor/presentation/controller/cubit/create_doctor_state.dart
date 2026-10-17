import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';

enum CreateDoctorSubmit { idle, uploadingImage, saving, saved, failed }

sealed class CreateDoctorState {
  const CreateDoctorState();
}

final class CreateDoctorInitial extends CreateDoctorState {
  const CreateDoctorInitial();
}

final class CreateDoctorLoading extends CreateDoctorState {
  const CreateDoctorLoading();
}

final class CreateDoctorSuccess extends CreateDoctorState {
  CreateDoctorSuccess({
    required List<SpecialtyModel> specialties,
    this.submit = CreateDoctorSubmit.idle,
    this.submitError,
  }) : specialties = List.unmodifiable(specialties);

  final List<SpecialtyModel> specialties;
  final CreateDoctorSubmit submit;
  final AppErrorCode? submitError;

  bool get isSubmitting =>
      submit == CreateDoctorSubmit.uploadingImage ||
      submit == CreateDoctorSubmit.saving;

  CreateDoctorSuccess copyWith({
    required CreateDoctorSubmit submit,
    AppErrorCode? submitError,
  }) {
    return CreateDoctorSuccess(
      specialties: specialties,
      submit: submit,
      submitError: submitError,
    );
  }
}

final class CreateDoctorFailure extends CreateDoctorState {
  const CreateDoctorFailure({required this.error});

  final AppErrorCode error;
}
