import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/data/repositories/patient_appointments_repository.dart';
import 'patient_appointments_state.dart';

export 'patient_appointments_state.dart';

class PatientAppointmentsCubit extends Cubit<PatientAppointmentsState> {
  PatientAppointmentsCubit({
    required this.repository,
    required this.authService,
  }) : super(const PatientAppointmentsLoading());

  final PatientAppointmentsRepository repository;
  final AuthService authService;

  StreamSubscription<List<AppointmentModel>>? _subscription;
  Map<String, SpecialtyModel> _specialtiesMap = {};

  Future<void> init() async {
    final user = authService.currentUser;
    if (user == null) {
      emit(const PatientAppointmentsError('User not authenticated'));
      return;
    }

    emit(const PatientAppointmentsLoading());

    try {
      final specialties = await repository.getSpecialties();
      _specialtiesMap = {for (final s in specialties) s.id: s};
    } catch (error, stackTrace) {
      // Specialty names are optional; the list still loads without them.
      addError(error, stackTrace);
    }

    await _subscription?.cancel();
    _subscription = repository
        .watchPatientAppointments(user.uid)
        .listen(
          (appointments) {
            emit(
              PatientAppointmentsLoaded(
                grouped: groupAppointmentsByStatus(appointments),
                specialties: _specialtiesMap,
              ),
            );
          },
          onError: (error) {
            final appEx = AppException.from(error);
            emit(PatientAppointmentsError(appEx.message));
          },
        );
  }

  Future<void> cancelAppointment(AppointmentModel appointment) async {
    try {
      await repository.cancelAppointment(appointment);
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
