import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorite_doctors_state.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/repositories/doctor_repository.dart';

class FavoriteDoctorsCubit extends Cubit<FavoriteDoctorsState> {
  FavoriteDoctorsCubit({required this.doctorRepository})
    : super(const FavoriteDoctorsInitial());

  final DoctorRepository doctorRepository;

  Future<void> load() async {
    if (state is FavoriteDoctorsLoading) return;

    emit(const FavoriteDoctorsLoading());
    try {
      final doctors = await doctorRepository.fetchDoctors();
      if (isClosed) return;
      emit(FavoriteDoctorsSuccess(doctors: doctors));
    } catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      emit(FavoriteDoctorsFailure(errorMessage: error.toString()));
    }
  }

  void search(String query) {
    final current = state;
    if (current is FavoriteDoctorsSuccess) {
      emit(current.copyWith(searchQuery: query));
    }
  }
}

List<DoctorModel> visibleFavoriteDoctors(
  FavoriteDoctorsSuccess state,
  Set<String> favoriteIds,
) {
  final query = state.searchQuery.trim().toLowerCase();
  return state.doctors.where((doctor) {
    if (!favoriteIds.contains(doctor.id)) return false;
    if (query.isEmpty) return true;
    return [
      doctor.name,
      doctor.nameAr,
      doctor.nameEn,
    ].any((name) => name?.toLowerCase().contains(query) ?? false);
  }).toList();
}
