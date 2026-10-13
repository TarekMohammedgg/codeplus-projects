import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/data/repositories/patient_appointments_repository.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'patient_appointments_state.dart';

export 'patient_appointments_state.dart';

class PatientAppointmentsCubit extends Cubit<PatientAppointmentsState> {
  PatientAppointmentsCubit({required this.repository})
    : super(const PatientAppointmentsLoading());

  final PatientAppointmentsRepository repository;

  StreamSubscription<List<AppointmentModel>>? _subscription;

  Future<void> init() async {
    final userId = repository.currentUserId;
    if (userId == null) {
      emit(PatientAppointmentsError(tr.userNotFoundError));
      return;
    }

    emit(const PatientAppointmentsLoading());

    var specialties = <String, SpecialtyModel>{};
    try {
      specialties = await repository.fetchSpecialties();
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }

    await _subscription?.cancel();
    _subscription = repository
        .watchPatientAppointments(userId)
        .listen(
          (appointments) => emit(
            PatientAppointmentsLoaded(
              grouped: groupAppointmentsByStatus(appointments),
              specialties: specialties,
            ),
          ),
          onError: (Object error) =>
              emit(PatientAppointmentsError(AppException.from(error).message)),
        );
  }

  Future<void> cancelAppointment(AppointmentModel appointment) =>
      repository.cancelAppointment(appointment);

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
