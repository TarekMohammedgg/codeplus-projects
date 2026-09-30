import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/service/find_doctors_service.dart';

abstract interface class DoctorRepository {
  Future<List<DoctorModel>> fetchDoctors();

  Future<List<SpecialtyModel>> fetchSpecialties();
}

class FirebaseDoctorRepository implements DoctorRepository {
  FirebaseDoctorRepository({
    required this.findDoctorsService,
    required this.specialtyService,
  });

  final FindDoctorsService findDoctorsService;
  final SpecialtyService specialtyService;

  @override
  Future<List<DoctorModel>> fetchDoctors() {
    return findDoctorsService.fetchDoctors();
  }

  @override
  Future<List<SpecialtyModel>> fetchSpecialties() {
    return specialtyService.fetchActiveSpecialties();
  }
}
