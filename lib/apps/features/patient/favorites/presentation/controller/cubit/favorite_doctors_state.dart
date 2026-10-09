import 'package:doctor_hunt/apps/core/models/doctor_model.dart';

sealed class FavoriteDoctorsState {
  const FavoriteDoctorsState();
}

final class FavoriteDoctorsInitial extends FavoriteDoctorsState {
  const FavoriteDoctorsInitial();
}

final class FavoriteDoctorsLoading extends FavoriteDoctorsState {
  const FavoriteDoctorsLoading();
}

final class FavoriteDoctorsSuccess extends FavoriteDoctorsState {
  const FavoriteDoctorsSuccess({required this.doctors, this.searchQuery = ''});

  final List<DoctorModel> doctors;
  final String searchQuery;

  FavoriteDoctorsSuccess copyWith({
    List<DoctorModel>? doctors,
    String? searchQuery,
  }) {
    return FavoriteDoctorsSuccess(
      doctors: doctors ?? this.doctors,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

final class FavoriteDoctorsFailure extends FavoriteDoctorsState {
  const FavoriteDoctorsFailure({required this.errorMessage});

  final String errorMessage;
}
