import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/features/common/appointment_details/data/repositories/appointment_details_repository.dart';
import 'package:doctor_hunt/apps/features/common/appointment_details/presentation/controller/cubit/appointment_details_state.dart';

export 'appointment_details_state.dart';

class AppointmentDetailsCubit extends Cubit<AppointmentDetailsState> {
  AppointmentDetailsCubit({required this.repository})
    : super(const AppointmentDetailsState());

  final AppointmentDetailsRepository repository;
  StreamSubscription<ClinicModel?>? _clinicSubscription;

  Future<void> init(AppointmentModel appointment) async {
    await _clinicSubscription?.cancel();
    _clinicSubscription = repository.watchClinic().listen((clinic) {
      if (!isClosed) emit(state.copyWith(clinic: clinic));
    }, onError: addError);

    try {
      final name = await repository.fetchSpecialtyName(appointment.specialtyId);
      if (isClosed || name == null) return;
      emit(state.copyWith(specialtyName: name));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> cancel(AppointmentModel appointment, CancelledBy cancelledBy) {
    return repository.cancel(appointment, cancelledBy);
  }

  Future<void> markCompleted(String appointmentId) {
    return repository.markCompleted(appointmentId);
  }

  @override
  Future<void> close() {
    _clinicSubscription?.cancel();
    return super.close();
  }
}
