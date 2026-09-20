import 'package:doctor_hunt/apps/features/admin/doctors/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/service/admin_doctor_service.dart';

abstract interface class AdminDoctorsRepository {
  Stream<List<AdminDoctorModel>> streamDoctors();

  Future<void> deleteDoctor(String id);
}

class FirebaseAdminDoctorsRepository implements AdminDoctorsRepository {
  FirebaseAdminDoctorsRepository({required this.doctorService});

  final AdminDoctorService doctorService;

  @override
  Stream<List<AdminDoctorModel>> streamDoctors() {
    return doctorService.streamDoctors();
  }

  @override
  Future<void> deleteDoctor(String id) {
    return doctorService.deleteDoctor(id);
  }
}
