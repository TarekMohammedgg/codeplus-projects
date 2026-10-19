import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/data/models/patient_appointments_group.dart';

GroupedAppointments groupAppointmentsByStatus(
  List<AppointmentModel> appointments,
) {
  final upcoming = <AppointmentModel>[];
  final completed = <AppointmentModel>[];
  final cancelled = <AppointmentModel>[];

  for (final appt in appointments) {
    switch (appt.status) {
      case AppointmentStatus.upcoming:
        upcoming.add(appt);
      case AppointmentStatus.completed:
        completed.add(appt);
      case AppointmentStatus.cancelled:
        cancelled.add(appt);
    }
  }

  upcoming.sort((a, b) => a.startAt.compareTo(b.startAt));
  completed.sort((a, b) => b.startAt.compareTo(a.startAt));
  cancelled.sort((a, b) => b.startAt.compareTo(a.startAt));

  return GroupedAppointments(
    upcoming: List.unmodifiable(upcoming),
    completed: List.unmodifiable(completed),
    cancelled: List.unmodifiable(cancelled),
  );
}

sealed class PatientAppointmentsState {
  const PatientAppointmentsState();
}

final class PatientAppointmentsLoading extends PatientAppointmentsState {
  const PatientAppointmentsLoading();
}

final class PatientAppointmentsLoaded extends PatientAppointmentsState {
  const PatientAppointmentsLoaded({
    required this.grouped,
    this.specialties = const {},
  });

  final GroupedAppointments grouped;
  final Map<String, SpecialtyModel> specialties;
}

final class PatientAppointmentsError extends PatientAppointmentsState {
  const PatientAppointmentsError(this.error);

  final AppErrorCode error;
}
