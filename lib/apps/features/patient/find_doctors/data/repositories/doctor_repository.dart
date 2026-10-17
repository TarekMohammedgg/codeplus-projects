import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/services/doctor_service.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';

abstract interface class DoctorRepository {
  Future<List<DoctorModel>> fetchDoctors();

  Future<List<SpecialtyModel>> fetchSpecialties();
}

class FirebaseDoctorRepository implements DoctorRepository {
  FirebaseDoctorRepository({
    required this.doctorService,
    required this.specialtyService,
  });

  final DoctorService doctorService;
  final SpecialtyService specialtyService;

  @override
  Future<List<DoctorModel>> fetchDoctors() =>
      doctorService.fetchActiveDoctors();

  @override
  Future<List<SpecialtyModel>> fetchSpecialties() =>
      specialtyService.fetchActiveSpecialties();
}
