import 'package:doctor_hunt/apps/core/models/appointment_model.dart';

class GroupedAppointments {
  const GroupedAppointments({
    this.upcoming = const [],
    this.completed = const [],
    this.cancelled = const [],
  });

  final List<AppointmentModel> upcoming;
  final List<AppointmentModel> completed;
  final List<AppointmentModel> cancelled;
}
