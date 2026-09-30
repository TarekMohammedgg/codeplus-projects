import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/utils/doctor_sort.dart';

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
  FindDoctorsSuccess({
    required List<DoctorModel> doctors,
    required List<SpecialtyModel> specialties,
    this.query = '',
    this.specialtyId,
    this.favoritesOnly = false,
    this.sort = DoctorSort.popular,
  }) : doctors = List.unmodifiable(doctors),
       specialties = List.unmodifiable(specialties);

  /// Every loaded active doctor; filters never refetch.
  final List<DoctorModel> doctors;
  final List<SpecialtyModel> specialties;
  final String query;

  /// Null = "All".
  final String? specialtyId;
  final bool favoritesOnly;
  final DoctorSort sort;

  FindDoctorsSuccess copyWith({
    String? query,
    String? Function()? specialtyId,
    bool? favoritesOnly,
    DoctorSort? sort,
  }) {
    return FindDoctorsSuccess(
      doctors: doctors,
      specialties: specialties,
      query: query ?? this.query,
      specialtyId: specialtyId != null ? specialtyId() : this.specialtyId,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      sort: sort ?? this.sort,
    );
  }
}

final class FindDoctorsFailure extends FindDoctorsState {
  const FindDoctorsFailure({required this.errorMessage});

  final String errorMessage;
}
