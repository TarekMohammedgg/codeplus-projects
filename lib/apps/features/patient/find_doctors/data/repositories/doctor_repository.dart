import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/services/doctor_service.dart';

abstract interface class DoctorRepository {
  Future<List<DoctorModel>> fetchDoctors();

  Future<List<DoctorModel>> fetchFavouriteDoctors();

  Future<List<DoctorModel>> fetchFeaturedDoctors();
}

class FirebaseDoctorRepository implements DoctorRepository {
  FirebaseDoctorRepository({required this.doctorService});

  final DoctorService doctorService;

  @override
  Future<List<DoctorModel>> fetchDoctors() {
    return doctorService.fetchDoctors();
  }

  @override
  Future<List<DoctorModel>> fetchFavouriteDoctors() {
    return doctorService.fetchFavouriteDoctors();
  }

  @override
  Future<List<DoctorModel>> fetchFeaturedDoctors() {
    return doctorService.fetchFeaturedDoctors();
  }
}
