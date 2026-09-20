import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/repositories/doctor_repository.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/cubit/find_doctors_state.dart';

class FindDoctorsCubit extends Cubit<FindDoctorsState> {
  FindDoctorsCubit({required this.repository})
    : super(const FindDoctorsInitial());

  final DoctorRepository repository;

  Future<void> load({List<DoctorModel>? initialDoctors}) async {
    if (state is FindDoctorsLoading) return;

    emit(const FindDoctorsLoading());
    try {
      final doctors = initialDoctors ?? await repository.fetchDoctors();
      emit(FindDoctorsSuccess(doctors: doctors));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(FindDoctorsFailure(errorMessage: error.toString()));
    }
  }
}
