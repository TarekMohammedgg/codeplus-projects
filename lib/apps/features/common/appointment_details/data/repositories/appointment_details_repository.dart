import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/services/appointment_service.dart';
import 'package:doctor_hunt/apps/core/services/clinic_service.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';

abstract interface class AppointmentDetailsRepository {
  Stream<AppointmentModel?> watchAppointment(String appointmentId);
  Future<String?> fetchSpecialtyName(String? specialtyId);
  Stream<ClinicModel?> watchClinic();
  Future<void> cancel(AppointmentModel appointment, CancelledBy cancelledBy);
  Future<void> markCompleted(String appointmentId);
}

class AppointmentDetailsRepositoryImpl implements AppointmentDetailsRepository {
  AppointmentDetailsRepositoryImpl({
    required this.appointmentService,
    required this.clinicService,
    required this.specialtyService,
  });

  final AppointmentService appointmentService;
  final ClinicService clinicService;
  final SpecialtyService specialtyService;

  @override
  Stream<AppointmentModel?> watchAppointment(String appointmentId) =>
      appointmentService.streamAppointment(appointmentId);

  @override
  Future<String?> fetchSpecialtyName(String? specialtyId) =>
      specialtyService.fetchSpecialtyName(specialtyId);

  @override
  Stream<ClinicModel?> watchClinic() => clinicService.streamClinic();

  @override
  Future<void> cancel(AppointmentModel appointment, CancelledBy cancelledBy) {
    return appointmentService.cancel(appointment, cancelledBy: cancelledBy);
  }

  @override
  Future<void> markCompleted(String appointmentId) {
    return appointmentService.markCompleted(appointmentId);
  }
}
