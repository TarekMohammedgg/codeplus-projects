import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/utils/doctor_sort.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/repositories/doctor_repository.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_state.dart';

class FindDoctorsCubit extends Cubit<FindDoctorsState> {
  FindDoctorsCubit({required this.repository})
    : super(const FindDoctorsInitial());

  final DoctorRepository repository;

  Future<void> load({
    String? query,
    String? specialtyId,
    DoctorSort? sort,
    bool favoritesOnly = false,
  }) async {
    if (state is FindDoctorsLoading) return;

    emit(const FindDoctorsLoading());
    try {
      final (doctors, specialties) = await (
        repository.fetchDoctors(),
        repository.fetchSpecialties(),
      ).wait;
      if (isClosed) return;
      emit(
        FindDoctorsSuccess(
          doctors: doctors,
          specialties: specialties,
          query: query ?? '',
          specialtyId: specialtyId,
          favoritesOnly: favoritesOnly,
          sort: sort ?? DoctorSort.popular,
        ),
      );
    } catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      emit(FindDoctorsFailure(errorMessage: error.toString()));
    }
  }

  /// Pull-to-refresh: reloads the doctors and keeps the current filters.
  Future<void> refresh() async {
    final current = state;
    if (current is! FindDoctorsSuccess) return load();
    try {
      final (doctors, specialties) = await (
        repository.fetchDoctors(),
        repository.fetchSpecialties(),
      ).wait;
      if (isClosed) return;
      emit(
        FindDoctorsSuccess(
          doctors: doctors,
          specialties: specialties,
          query: current.query,
          specialtyId: current.specialtyId,
          favoritesOnly: current.favoritesOnly,
          sort: current.sort,
        ),
      );
    } catch (error, stackTrace) {
      if (!isClosed) addError(error, stackTrace);
    }
  }

  void applyRouteFilters({
    String? query,
    String? specialtyId,
    DoctorSort? sort,
  }) {
    _update(
      (state) => state.copyWith(
        query: query ?? '',
        specialtyId: () => specialtyId,
        favoritesOnly: false,
        sort: sort ?? DoctorSort.popular,
      ),
    );
  }

  void search(String query) => _update((state) => state.copyWith(query: query));

  void toggleFavoritesOnly() =>
      _update((state) => state.copyWith(favoritesOnly: !state.favoritesOnly));

  void selectSpecialty(String? specialtyId) =>
      _update((state) => state.copyWith(specialtyId: () => specialtyId));

  void sortBy(DoctorSort sort) =>
      _update((state) => state.copyWith(sort: sort));

  void _update(FindDoctorsSuccess Function(FindDoctorsSuccess) change) {
    final current = state;
    if (current is FindDoctorsSuccess) emit(change(current));
  }
}

List<DoctorModel> visibleDoctors(
  FindDoctorsSuccess state,
  Set<String> favoriteIds,
) {
  final filtered = state.doctors.where((doctor) {
    if (state.specialtyId != null && doctor.specialtyId != state.specialtyId) {
      return false;
    }
    if (state.favoritesOnly && !favoriteIds.contains(doctor.id)) return false;
    return doctor.nameContains(state.query);
  }).toList();
  return sortDoctors(filtered, state.sort);
}
