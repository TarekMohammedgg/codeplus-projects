import 'package:doctor_hunt/apps/core/models/clinic_model.dart';

final class AppointmentDetailsState {
  const AppointmentDetailsState({this.specialtyName, this.clinic});

  final String? specialtyName;

  /// Read live from `clinic/settings`, so admin changes show immediately.
  final ClinicModel? clinic;

  AppointmentDetailsState copyWith({
    String? specialtyName,
    ClinicModel? clinic,
  }) {
    return AppointmentDetailsState(
      specialtyName: specialtyName ?? this.specialtyName,
      clinic: clinic ?? this.clinic,
    );
  }
}
