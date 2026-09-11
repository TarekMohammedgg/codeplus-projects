import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/doctors/data/repositories/doctor_repository.dart';
import 'package:doctor_hunt/apps/features/favourite_doctors/presentation/cubit/favourite_doctors_state.dart';

class FavouriteDoctorsCubit extends Cubit<FavouriteDoctorsState> {
  FavouriteDoctorsCubit({required this.repository})
    : super(const FavouriteDoctorsInitial());

  final DoctorRepository repository;

  Future<void> load({
    List<DoctorModel>? initialFavouriteDoctors,
    List<DoctorModel>? initialFeaturedDoctors,
  }) async {
    if (state is FavouriteDoctorsLoading) return;

    emit(const FavouriteDoctorsLoading());
    try {
      final favouriteFuture = initialFavouriteDoctors != null
          ? Future.value(initialFavouriteDoctors)
          : repository.fetchFavouriteDoctors();
      final featuredFuture = initialFeaturedDoctors != null
          ? Future.value(initialFeaturedDoctors)
          : repository.fetchFeaturedDoctors();
      final doctors = await Future.wait([favouriteFuture, featuredFuture]);

      emit(
        FavouriteDoctorsSuccess(
          favouriteDoctors: doctors[0],
          featuredDoctors: doctors[1],
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(FavouriteDoctorsFailure(errorMessage: error.toString()));
    }
  }
}
