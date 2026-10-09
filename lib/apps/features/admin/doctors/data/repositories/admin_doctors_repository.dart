import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/service/admin_doctor_service.dart';

abstract interface class AdminDoctorsRepository {
  Stream<List<DoctorModel>> streamDoctors();

  Future<List<SpecialtyModel>> fetchSpecialties();

  Future<void> setActive(String id, bool isActive);
}

class FirebaseAdminDoctorsRepository implements AdminDoctorsRepository {
  FirebaseAdminDoctorsRepository({
    required this.doctorService,
    required this.specialtyService,
  });

  final AdminDoctorService doctorService;
  final SpecialtyService specialtyService;

  @override
  Stream<List<DoctorModel>> streamDoctors() {
    return doctorService.streamDoctors();
  }

  @override
  Future<List<SpecialtyModel>> fetchSpecialties() {
    return specialtyService.fetchActiveSpecialties();
  }

  @override
  Future<void> setActive(String id, bool isActive) {
    return doctorService.setActive(id, isActive);
  }
}
