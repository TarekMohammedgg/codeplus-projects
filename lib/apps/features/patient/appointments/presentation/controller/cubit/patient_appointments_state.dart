import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';

class GroupedAppointments {
  const GroupedAppointments({
    this.upcoming = const [],
    this.completed = const [],
    this.cancelled = const [],
  });

  final List<AppointmentModel> upcoming;
  final List<AppointmentModel> completed;
  final List<AppointmentModel> cancelled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupedAppointments &&
          runtimeType == other.runtimeType &&
          _listEquals(upcoming, other.upcoming) &&
          _listEquals(completed, other.completed) &&
          _listEquals(cancelled, other.cancelled);

  @override
  int get hashCode =>
      Object.hash(upcoming.length, completed.length, cancelled.length);

  static bool _listEquals(List<AppointmentModel> a, List<AppointmentModel> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }
}

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientAppointmentsLoaded &&
          runtimeType == other.runtimeType &&
          grouped == other.grouped;

  @override
  int get hashCode => grouped.hashCode;
}

final class PatientAppointmentsError extends PatientAppointmentsState {
  const PatientAppointmentsError(this.message);

  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientAppointmentsError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
