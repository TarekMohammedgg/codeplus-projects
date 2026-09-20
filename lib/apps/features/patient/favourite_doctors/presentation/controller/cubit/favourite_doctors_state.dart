import 'package:doctor_hunt/apps/core/models/doctor_model.dart';

sealed class FavouriteDoctorsState {
  const FavouriteDoctorsState();
}

final class FavouriteDoctorsInitial extends FavouriteDoctorsState {
  const FavouriteDoctorsInitial();
}

final class FavouriteDoctorsLoading extends FavouriteDoctorsState {
  const FavouriteDoctorsLoading();
}

final class FavouriteDoctorsSuccess extends FavouriteDoctorsState {
  FavouriteDoctorsSuccess({
    required List<DoctorModel> favouriteDoctors,
    required List<DoctorModel> featuredDoctors,
  }) : favouriteDoctors = List.unmodifiable(favouriteDoctors),
       featuredDoctors = List.unmodifiable(featuredDoctors);

  final List<DoctorModel> favouriteDoctors;
  final List<DoctorModel> featuredDoctors;
}

final class FavouriteDoctorsFailure extends FavouriteDoctorsState {
  const FavouriteDoctorsFailure({required this.errorMessage});

  final String errorMessage;
}
