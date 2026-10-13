import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/data/repositories/admin_appointments_repository.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/presentation/controller/cubit/admin_appointments_state.dart';

class AdminAppointmentsCubit extends Cubit<AdminAppointmentsState> {
  AdminAppointmentsCubit({
    required this.repository,
    AdminAppointmentsState? initialState,
  }) : super(initialState ?? const AdminAppointmentsState());

  final AdminAppointmentsRepository repository;
  StreamSubscription<List<AppointmentModel>>? _subscription;

  Future<void> init() async {
    emit(state.copyWith(status: AdminAppointmentsStatus.loading));

    try {
      final specialties = await repository.getSpecialties();
      final map = {for (final s in specialties) s.id: s};
      emit(state.copyWith(specialties: map));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }

    await _subscription?.cancel();
    _subscription = repository.streamAppointments().listen(
      (appointments) {
        emit(
          state.copyWith(
            status: AdminAppointmentsStatus.loaded,
            appointments: appointments,
          ),
        );
        _loadPatientPhotos(appointments);
      },
      onError: (error) {
        final ex = AppException.from(error);
        emit(
          state.copyWith(
            status: AdminAppointmentsStatus.failure,
            errorMessage: ex.message,
          ),
        );
      },
    );
  }

  Future<void> _loadPatientPhotos(List<AppointmentModel> appointments) async {
    final ids = appointments
        .map((a) => a.patientId)
        .where((id) => !state.patientPhotos.containsKey(id))
        .toSet();
    if (ids.isEmpty) return;
    final photos = await Future.wait(
      ids.map((id) => repository.getPatientPhoto(id).catchError((_) => null)),
    );
    if (isClosed) return;
    emit(
      state.copyWith(
        patientPhotos: {
          ...state.patientPhotos,
          ...Map.fromIterables(ids, photos),
        },
      ),
    );
  }

  void selectTab(AdminAppointmentTab tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  Future<void> cancel(AppointmentModel appointment) =>
      repository.cancel(appointment);

  Future<void> markCompleted(String appointmentId) =>
      repository.markCompleted(appointmentId);

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
