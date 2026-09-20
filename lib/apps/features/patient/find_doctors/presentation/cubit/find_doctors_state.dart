import 'package:doctor_hunt/apps/core/models/doctor_model.dart';

sealed class FindDoctorsState {
  const FindDoctorsState();
}

final class FindDoctorsInitial extends FindDoctorsState {
  const FindDoctorsInitial();
}

final class FindDoctorsLoading extends FindDoctorsState {
  const FindDoctorsLoading();
}

final class FindDoctorsSuccess extends FindDoctorsState {
  FindDoctorsSuccess({required List<DoctorModel> doctors})
    : doctors = List.unmodifiable(doctors);

  final List<DoctorModel> doctors;
}

final class FindDoctorsFailure extends FindDoctorsState {
  const FindDoctorsFailure({required this.errorMessage});

  final String errorMessage;
}
