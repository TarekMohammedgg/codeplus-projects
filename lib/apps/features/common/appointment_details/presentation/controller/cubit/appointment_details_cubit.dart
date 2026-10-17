import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/features/common/appointment_details/data/repositories/appointment_details_repository.dart';
import 'package:doctor_hunt/apps/features/common/appointment_details/presentation/controller/cubit/appointment_details_state.dart';

export 'appointment_details_state.dart';

class AppointmentDetailsCubit extends Cubit<AppointmentDetailsState> {
  AppointmentDetailsCubit({
    required this.repository,
    required AppointmentModel appointment,
  }) : super(AppointmentDetailsState(appointment: appointment));

  final AppointmentDetailsRepository repository;
  StreamSubscription<AppointmentModel?>? _appointmentSubscription;
  StreamSubscription<ClinicModel?>? _clinicSubscription;

  Future<void> init() async {
    _appointmentSubscription = repository
        .watchAppointment(state.appointment.id)
        .listen((appointment) {
          if (appointment != null) {
            emit(state.copyWith(appointment: appointment));
          }
        }, onError: addError);
    _clinicSubscription = repository.watchClinic().listen(
      (clinic) => emit(state.copyWith(clinic: clinic)),
      onError: addError,
    );

    try {
      final name = await repository.fetchSpecialtyName(
        state.appointment.specialtyId,
      );
      if (isClosed || name == null) return;
      emit(state.copyWith(specialtyName: name));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> cancel(CancelledBy cancelledBy) => _run(
    AppointmentActionStatus.cancelling,
    AppointmentActionStatus.cancelled,
    () => repository.cancel(state.appointment, cancelledBy),
  );

  Future<void> markCompleted() => _run(
    AppointmentActionStatus.completing,
    AppointmentActionStatus.completed,
    () => repository.markCompleted(state.appointment.id),
  );

  Future<void> _run(
    AppointmentActionStatus busy,
    AppointmentActionStatus done,
    Future<void> Function() action,
  ) async {
    if (state.isBusy) return;
    emit(state.copyWith(action: busy));
    try {
      await action();
      if (!isClosed) emit(state.copyWith(action: done));
    } catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      emit(
        state.copyWith(
          action: AppointmentActionStatus.failed,
          error: AppException.from(error).code,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _appointmentSubscription?.cancel();
    _clinicSubscription?.cancel();
    return super.close();
  }
}
