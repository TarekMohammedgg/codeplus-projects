import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/data/repositories/favourite_doctors_repository.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/presentation/controller/cubit/favourite_doctors_state.dart';

class FavouriteDoctorsCubit extends Cubit<FavouriteDoctorsState> {
  FavouriteDoctorsCubit({required this.repository})
    : super(const FavouriteDoctorsInitial());

  final FavouriteDoctorsRepository repository;

  Future<void> load({
    List<DoctorModel>? initialFavouriteDoctors,
    List<DoctorModel>? initialFeaturedDoctors,
  }) async {
    if (state is FavouriteDoctorsLoading) return;

    emit(const FavouriteDoctorsLoading());
    try {
      final doctorsFuture = initialFavouriteDoctors != null
          ? Future.value(initialFavouriteDoctors)
          : repository.fetchFavouriteDoctors();
      final featuredFuture = initialFeaturedDoctors != null
          ? Future.value(initialFeaturedDoctors)
          : repository.fetchFeaturedDoctors();
      final doctors = await Future.wait([doctorsFuture, featuredFuture]);

      if (isClosed) return;
      emit(
        FavouriteDoctorsSuccess(
          favouriteDoctors: doctors[0],
          featuredDoctors: doctors[1],
        ),
      );
    } catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      emit(FavouriteDoctorsFailure(errorMessage: error.toString()));
    }
  }
}
