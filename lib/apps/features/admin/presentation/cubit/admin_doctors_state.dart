import 'package:doctor_hunt/apps/features/admin/data/models/admin_doctor_model.dart';

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
  AdminDoctorsSuccess({required List<AdminDoctorModel> doctors})
    : doctors = List.unmodifiable(doctors);

  final List<AdminDoctorModel> doctors;
}

final class AdminDoctorsFailure extends AdminDoctorsState {
  const AdminDoctorsFailure({required this.errorMessage});

  final String errorMessage;
}
