import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/repositories/admin_doctors_repository.dart';

class AdminDoctorDetailsState {
  const AdminDoctorDetailsState({
    required this.doctor,
    this.isTogglingActive = false,
    this.error,
  });

  final DoctorModel doctor;
  final bool isTogglingActive;
  final AppErrorCode? error;
}

class AdminDoctorDetailsCubit extends Cubit<AdminDoctorDetailsState> {
  AdminDoctorDetailsCubit({
    required DoctorModel initialDoctor,
    required this.repository,
  }) : super(AdminDoctorDetailsState(doctor: initialDoctor)) {
    _subscription = repository.streamDoctor(initialDoctor.id).listen(
      (doctor) {
        if (doctor != null) emit(AdminDoctorDetailsState(doctor: doctor));
      },
      onError: (Object error) => emit(
        AdminDoctorDetailsState(
          doctor: state.doctor,
          error: AppException.from(error).code,
        ),
      ),
    );
  }

  final AdminDoctorsRepository repository;
  late final StreamSubscription<DoctorModel?> _subscription;

  Future<bool> toggleActive(bool isActive) async {
    emit(AdminDoctorDetailsState(doctor: state.doctor, isTogglingActive: true));
    try {
      await repository.setActive(state.doctor.id, isActive);
      if (isClosed) return true;
      emit(AdminDoctorDetailsState(doctor: state.doctor));
      return true;
    } catch (error) {
      if (isClosed) return false;
      emit(
        AdminDoctorDetailsState(
          doctor: state.doctor,
          error: AppException.from(error).code,
        ),
      );
      return false;
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
