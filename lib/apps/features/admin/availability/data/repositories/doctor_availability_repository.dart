import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/core/services/doctor_service.dart';

abstract interface class DoctorAvailabilityRepository {
  Future<void> updateAvailability(
    String doctorId,
    DoctorAvailability availability,
  );
}

class DoctorAvailabilityRepositoryImpl implements DoctorAvailabilityRepository {
  const DoctorAvailabilityRepositoryImpl({required this.doctorService});

  final DoctorService doctorService;

  @override
  Future<void> updateAvailability(
    String doctorId,
    DoctorAvailability availability,
  ) {
    return doctorService.updateAvailability(doctorId, availability);
  }
}
