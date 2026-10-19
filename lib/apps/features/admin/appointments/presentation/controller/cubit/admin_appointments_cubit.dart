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
  final _requestedPhotoIds = <String>{};

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
            error: ex.code,
          ),
        );
      },
    );
  }

  Future<void> _loadPatientPhotos(List<AppointmentModel> appointments) async {
    final newIds = {for (final a in appointments) a.patientId}
      ..removeAll(_requestedPhotoIds);
    if (newIds.isEmpty) return;

    _requestedPhotoIds.addAll(newIds);
    try {
      final photos = await repository.fetchPatientPhotos(newIds);
      if (isClosed) return;
      emit(state.copyWith(patientPhotos: {...state.patientPhotos, ...photos}));
    } catch (error, stackTrace) {
      _requestedPhotoIds.removeAll(newIds);
      if (isClosed) return;
      addError(error, stackTrace);
    }
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
