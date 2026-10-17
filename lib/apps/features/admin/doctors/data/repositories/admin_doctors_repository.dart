import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/services/doctor_service.dart';

abstract interface class AdminDoctorsRepository {
  Stream<List<DoctorModel>> streamDoctors();

  Stream<DoctorModel?> streamDoctor(String id);

  Future<List<SpecialtyModel>> fetchSpecialties();

  Future<void> setActive(String id, bool isActive);
}

class FirebaseAdminDoctorsRepository implements AdminDoctorsRepository {
  FirebaseAdminDoctorsRepository({
    required this.doctorService,
    required this.specialtyService,
  });

  final DoctorService doctorService;
  final SpecialtyService specialtyService;

  @override
  Stream<List<DoctorModel>> streamDoctors() {
    return doctorService.streamAllDoctors();
  }

  @override
  Stream<DoctorModel?> streamDoctor(String id) =>
      doctorService.streamDoctor(id);

  @override
  Future<List<SpecialtyModel>> fetchSpecialties() {
    return specialtyService.fetchActiveSpecialties();
  }

  @override
  Future<void> setActive(String id, bool isActive) {
    return doctorService.setActive(id, isActive);
  }
}
