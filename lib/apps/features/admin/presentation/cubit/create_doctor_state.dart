import 'package:doctor_hunt/apps/features/specialty/data/models/specialty_model.dart';

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
  CreateDoctorSuccess({required List<SpecialtyModel> specialties})
    : specialties = List.unmodifiable(specialties);

  final List<SpecialtyModel> specialties;
}

final class CreateDoctorFailure extends CreateDoctorState {
  const CreateDoctorFailure({required this.errorMessage});

  final String errorMessage;
}
