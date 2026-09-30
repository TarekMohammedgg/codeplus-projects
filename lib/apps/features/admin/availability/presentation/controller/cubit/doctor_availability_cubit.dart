import 'package:flutter_bloc/flutter_bloc.dart';
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
    final current = Set<int>.from(state.workingDays);
    if (current.contains(weekday)) {
      current.remove(weekday);
    } else {
      current.add(weekday);
    }
    emit(
      state.copyWith(
        workingDays: current,
        status: DoctorAvailabilityStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void setWorkingDays(Set<int> days) {
    emit(
      state.copyWith(
        workingDays: days,
        status: DoctorAvailabilityStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void setStartMinutes(int minutes) {
    emit(
      state.copyWith(
        startMinutes: minutes,
        status: DoctorAvailabilityStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void setEndMinutes(int minutes) {
    emit(
      state.copyWith(
        endMinutes: minutes,
        status: DoctorAvailabilityStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void setSlotMinutes(int minutes) {
    emit(
      state.copyWith(
        slotMinutes: minutes,
        status: DoctorAvailabilityStatus.initial,
        errorMessage: null,
      ),
    );
  }

  Future<bool> saveAvailability(String doctorId) async {
    if (!state.isValid) {
      emit(
        state.copyWith(
          status: DoctorAvailabilityStatus.failure,
          errorMessage: _getValidationErrorMessage(state.validationError),
        ),
      );
      return false;
    }

    emit(
      state.copyWith(
        status: DoctorAvailabilityStatus.saving,
        errorMessage: null,
      ),
    );
    try {
      await repository.updateAvailability(doctorId, state.toAvailability());
      emit(state.copyWith(status: DoctorAvailabilityStatus.success));
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          status: DoctorAvailabilityStatus.failure,
          errorMessage: e.toString(),
        ),
      );
      return false;
    }
  }

  static String _getValidationErrorMessage(AvailabilityValidationError error) {
    switch (error) {
      case AvailabilityValidationError.emptyDays:
        return 'Please select at least one working day';
      case AvailabilityValidationError.invalidTimeRange:
        return 'Start time must be before end time';
      case AvailabilityValidationError.slotTooLong:
        return 'Slot duration cannot exceed working hours';
      case AvailabilityValidationError.none:
        return '';
    }
  }
}
