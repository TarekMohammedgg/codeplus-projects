import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/utils/doctor_sort.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/repositories/doctor_repository.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_state.dart';

class FindDoctorsCubit extends Cubit<FindDoctorsState> {
  FindDoctorsCubit({required this.repository})
    : super(const FindDoctorsInitial());

  final DoctorRepository repository;

  /// [query], [specialtyId] and [sort] come from the route (e.g. Home).
  Future<void> load({
    String? query,
    String? specialtyId,
    DoctorSort? sort,
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
          sort: sort ?? DoctorSort.popular,
        ),
      );
    } catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      emit(FindDoctorsFailure(errorMessage: error.toString()));
    }
  }

  /// Re-applies filters when the tab is opened again with new route params.
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

  /// Null selects "All".
  void selectSpecialty(String? specialtyId) =>
      _update((state) => state.copyWith(specialtyId: () => specialtyId));

  void toggleFavoritesOnly() =>
      _update((state) => state.copyWith(favoritesOnly: !state.favoritesOnly));

  void sortBy(DoctorSort sort) =>
      _update((state) => state.copyWith(sort: sort));

  void _update(FindDoctorsSuccess Function(FindDoctorsSuccess) change) {
    final current = state;
    if (current is FindDoctorsSuccess) emit(change(current));
  }
}

/// The doctors shown for [state]'s filters. [favoriteIds] comes from the
/// app-wide FavoritesCubit.
List<DoctorModel> visibleDoctors(
  FindDoctorsSuccess state,
  Set<String> favoriteIds,
) {
  final query = state.query.trim().toLowerCase();
  final filtered = state.doctors.where((doctor) {
    if (state.specialtyId != null && doctor.specialtyId != state.specialtyId) {
      return false;
    }
    if (state.favoritesOnly && !favoriteIds.contains(doctor.id)) return false;
    if (query.isEmpty) return true;
    return [
      doctor.name,
      doctor.nameAr,
      doctor.nameEn,
    ].any((name) => name?.toLowerCase().contains(query) ?? false);
  }).toList();
  return sortDoctors(filtered, state.sort);
}
