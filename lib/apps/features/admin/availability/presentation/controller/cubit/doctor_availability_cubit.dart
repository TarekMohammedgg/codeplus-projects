import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/features/admin/availability/data/repositories/doctor_availability_repository.dart';
import 'package:doctor_hunt/apps/features/admin/availability/presentation/controller/cubit/doctor_availability_state.dart';

class DoctorAvailabilityCubit extends Cubit<DoctorAvailabilityState> {
  DoctorAvailabilityCubit({
    required this.repository,
    DoctorAvailability? initialAvailability,
  }) : super(DoctorAvailabilityState.fromAvailability(initialAvailability));

  final DoctorAvailabilityRepository repository;

  void toggleDay(int weekday) {
    final days = Set<int>.from(state.workingDays);
    if (!days.remove(weekday)) days.add(weekday);
    _edit(state.copyWith(workingDays: days));
  }

  void setStartMinutes(int minutes) =>
      _edit(state.copyWith(startMinutes: minutes));

  void setEndMinutes(int minutes) => _edit(state.copyWith(endMinutes: minutes));

  void setSlotMinutes(int minutes) =>
      _edit(state.copyWith(slotMinutes: minutes));

  void _edit(DoctorAvailabilityState edited) {
    emit(edited.copyWith(status: DoctorAvailabilityStatus.initial));
  }

  Future<bool> saveAvailability(String doctorId) async {
    if (!state.isValid) {
      emit(state.copyWith(status: DoctorAvailabilityStatus.failure));
      return false;
    }

    emit(state.copyWith(status: DoctorAvailabilityStatus.saving));
    try {
      await repository.updateAvailability(doctorId, state.toAvailability());
      emit(state.copyWith(status: DoctorAvailabilityStatus.success));
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          status: DoctorAvailabilityStatus.failure,
          error: AppException.from(e).code,
        ),
      );
      return false;
    }
  }
}
