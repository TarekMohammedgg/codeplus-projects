import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/services/appointment_service.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';

abstract interface class PatientAppointmentsRepository {
  Stream<List<AppointmentModel>> watchPatientAppointments(String patientId);
  Future<void> cancelAppointment(AppointmentModel appointment);
  Future<List<SpecialtyModel>> getSpecialties();
}

class PatientAppointmentsRepositoryImpl
    implements PatientAppointmentsRepository {
  PatientAppointmentsRepositoryImpl({
    required this.appointmentService,
    required this.specialtyService,
  });

  final AppointmentService appointmentService;
  final SpecialtyService specialtyService;

  @override
  Stream<List<AppointmentModel>> watchPatientAppointments(String patientId) {
    return appointmentService.streamPatientAppointments(patientId);
  }

  @override
  Future<void> cancelAppointment(AppointmentModel appointment) {
    return appointmentService.cancel(
      appointment,
      cancelledBy: CancelledBy.patient,
    );
  }

  @override
  Future<List<SpecialtyModel>> getSpecialties() {
    return specialtyService.fetchActiveSpecialties();
  }
}
