import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/repositories/admin_doctors_repository.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_state.dart';

class AdminDoctorsCubit extends Cubit<AdminDoctorsState> {
  AdminDoctorsCubit({required this.repository})
    : super(const AdminDoctorsInitial());

  final AdminDoctorsRepository repository;
  StreamSubscription<List<AdminDoctorModel>>? _doctorsSubscription;
  // remember me to talk about this
  void load() {
    _doctorsSubscription?.cancel();
    emit(const AdminDoctorsLoading());
    _doctorsSubscription = repository.streamDoctors().listen(
      (doctors) => emit(AdminDoctorsSuccess(doctors: doctors)),
      onError: (Object error, StackTrace stackTrace) {
        addError(error, stackTrace);
        emit(AdminDoctorsFailure(errorMessage: error.toString()));
      },
    );
  }

  Future<void> deleteDoctor(String id) {
    return repository.deleteDoctor(id);
  }

  @override
  Future<void> close() async {
    await _doctorsSubscription?.cancel();
    return super.close();
  }
}
