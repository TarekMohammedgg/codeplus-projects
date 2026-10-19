import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/clinic_model.dart';

enum AppointmentActionStatus {
  idle,
  cancelling,
  completing,
  cancelled,
  completed,
  failed,
}

final class AppointmentDetailsState {
  const AppointmentDetailsState({
    required this.appointment,
    this.specialtyName,
    this.clinic,
    this.action = AppointmentActionStatus.idle,
    this.error,
  });

  final AppointmentModel appointment;
  final String? specialtyName;
  final ClinicModel? clinic;
  final AppointmentActionStatus action;
  final AppErrorCode? error;

  bool get isBusy =>
      action == AppointmentActionStatus.cancelling ||
      action == AppointmentActionStatus.completing;

  AppointmentDetailsState copyWith({
    AppointmentModel? appointment,
    String? specialtyName,
    ClinicModel? clinic,
    AppointmentActionStatus? action,
    AppErrorCode? error,
  }) {
    return AppointmentDetailsState(
      appointment: appointment ?? this.appointment,
      specialtyName: specialtyName ?? this.specialtyName,
      clinic: clinic ?? this.clinic,
      action: action ?? this.action,
      error: error,
    );
  }
}
