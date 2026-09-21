import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/service/find_doctors_service.dart';

abstract interface class DoctorRepository {
  Future<List<DoctorModel>> fetchDoctors();
}

class FirebaseDoctorRepository implements DoctorRepository {
  FirebaseDoctorRepository({required this.findDoctorsService});

  final FindDoctorsService findDoctorsService;

  @override
  Future<List<DoctorModel>> fetchDoctors() {
    return findDoctorsService.fetchDoctors();
  }
}
