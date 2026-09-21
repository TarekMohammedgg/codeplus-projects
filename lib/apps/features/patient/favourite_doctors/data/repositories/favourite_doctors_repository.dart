import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/data/service/favourite_doctors_service.dart';

abstract interface class FavouriteDoctorsRepository {
  Future<List<DoctorModel>> fetchFavouriteDoctors();

  Future<List<DoctorModel>> fetchFeaturedDoctors();
}

class FirebaseFavouriteDoctorsRepository implements FavouriteDoctorsRepository {
  FirebaseFavouriteDoctorsRepository({required this.favouriteDoctorsService});

  final FavouriteDoctorsService favouriteDoctorsService;

  @override
  Future<List<DoctorModel>> fetchFavouriteDoctors() {
    return favouriteDoctorsService.fetchFavouriteDoctors();
  }

  @override
  Future<List<DoctorModel>> fetchFeaturedDoctors() {
    return favouriteDoctorsService.fetchFeaturedDoctors();
  }
}
