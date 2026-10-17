import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/services/appointment_service.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';

abstract interface class PatientAppointmentsRepository {
  String? get currentUserId;
  Stream<List<AppointmentModel>> watchPatientAppointments(String patientId);
  Future<Map<String, SpecialtyModel>> fetchSpecialties();
  Future<void> cancelAppointment(AppointmentModel appointment);
}

class PatientAppointmentsRepositoryImpl
    implements PatientAppointmentsRepository {
  PatientAppointmentsRepositoryImpl({
    required this.appointmentService,
    required this.specialtyService,
    required this.authService,
  });

  final AppointmentService appointmentService;
  final SpecialtyService specialtyService;
  final AuthService authService;

  @override
  String? get currentUserId => authService.currentUser?.uid;

  @override
  Stream<List<AppointmentModel>> watchPatientAppointments(String patientId) =>
      appointmentService.streamPatientAppointments(patientId);

  @override
  Future<Map<String, SpecialtyModel>> fetchSpecialties() =>
      specialtyService.fetchSpecialtiesById();

  @override
  Future<void> cancelAppointment(AppointmentModel appointment) =>
      appointmentService.cancel(appointment, cancelledBy: CancelledBy.patient);
}
