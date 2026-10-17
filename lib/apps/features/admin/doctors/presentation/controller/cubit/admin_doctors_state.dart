import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';

sealed class AdminDoctorsState {
  const AdminDoctorsState();
}

final class AdminDoctorsInitial extends AdminDoctorsState {
  const AdminDoctorsInitial();
}

final class AdminDoctorsLoading extends AdminDoctorsState {
  const AdminDoctorsLoading();
}

final class AdminDoctorsSuccess extends AdminDoctorsState {
  AdminDoctorsSuccess({
    required List<DoctorModel> doctors,
    required List<SpecialtyModel> specialties,
  }) : doctors = List.unmodifiable(doctors),
       specialties = List.unmodifiable(specialties);

  final List<DoctorModel> doctors;
  final List<SpecialtyModel> specialties;
}

final class AdminDoctorsFailure extends AdminDoctorsState {
  const AdminDoctorsFailure({required this.errorMessage});

  final String errorMessage;
}
