import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/repositories/admin_doctors_repository.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_state.dart';

class AdminDoctorsCubit extends Cubit<AdminDoctorsState> {
  AdminDoctorsCubit({required this.repository})
    : super(const AdminDoctorsInitial());

  final AdminDoctorsRepository repository;
  StreamSubscription<List<DoctorModel>>? _doctorsSubscription;

  Future<void> load() async {
    await _doctorsSubscription?.cancel();
    emit(const AdminDoctorsLoading());
    final List<SpecialtyModel> specialties;
    try {
      specialties = await repository.fetchSpecialties();
    } catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      emit(const AdminDoctorsFailure());
      return;
    }
    if (isClosed) return;
    _doctorsSubscription = repository.streamDoctors().listen(
      (doctors) =>
          emit(AdminDoctorsSuccess(doctors: doctors, specialties: specialties)),
      onError: (Object error, StackTrace stackTrace) {
        addError(error, stackTrace);
        emit(const AdminDoctorsFailure());
      },
    );
  }

  Future<void> setActive(String id, bool isActive) {
    return repository.setActive(id, isActive);
  }

  @override
  Future<void> close() async {
    await _doctorsSubscription?.cancel();
    return super.close();
  }
}
