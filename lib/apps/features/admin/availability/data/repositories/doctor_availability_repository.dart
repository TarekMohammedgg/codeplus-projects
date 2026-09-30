import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/service/admin_doctor_service.dart';

abstract class DoctorAvailabilityRepository {
  Future<void> updateAvailability(
    String doctorId,
    DoctorAvailability availability,
  );
}

class DoctorAvailabilityRepositoryImpl implements DoctorAvailabilityRepository {
  const DoctorAvailabilityRepositoryImpl({required this.doctorService});

  final AdminDoctorService doctorService;

  @override
  Future<void> updateAvailability(
    String doctorId,
    DoctorAvailability availability,
  ) {
    return doctorService.updateAvailability(doctorId, availability);
  }
}
