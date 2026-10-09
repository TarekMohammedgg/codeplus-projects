import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/services/appointment_service.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';

abstract class AdminAppointmentsRepository {
  Stream<List<AppointmentModel>> streamAppointments();
  Future<List<SpecialtyModel>> getSpecialties();
  Future<void> cancel(AppointmentModel appointment);
  Future<void> markCompleted(String appointmentId);
}

class AdminAppointmentsRepositoryImpl implements AdminAppointmentsRepository {
  const AdminAppointmentsRepositoryImpl({
    required this.appointmentService,
    required this.specialtyService,
  });

  final AppointmentService appointmentService;
  final SpecialtyService specialtyService;

  @override
  Stream<List<AppointmentModel>> streamAppointments() =>
      appointmentService.streamAllAppointments();

  @override
  Future<List<SpecialtyModel>> getSpecialties() =>
      specialtyService.fetchActiveSpecialties();

  @override
  Future<void> cancel(AppointmentModel appointment) =>
      appointmentService.cancel(appointment, cancelledBy: CancelledBy.admin);

  @override
  Future<void> markCompleted(String appointmentId) =>
      appointmentService.markCompleted(appointmentId);
}
