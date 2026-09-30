import 'package:flutter/foundation.dart';
import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';

enum DoctorAvailabilityStatus { initial, saving, success, failure }

enum AvailabilityValidationError {
  none,
  emptyDays,
  invalidTimeRange,
  slotTooLong,
}

@immutable
class DoctorAvailabilityState {
  const DoctorAvailabilityState({
    this.status = DoctorAvailabilityStatus.initial,
    this.workingDays = const {1, 2, 3, 4, 5},
    this.startMinutes = 540, // 09:00
    this.endMinutes = 1020, // 17:00
    this.slotMinutes = 30,
    this.errorMessage,
  });

  factory DoctorAvailabilityState.fromAvailability(
    DoctorAvailability? availability,
  ) {
    if (availability != null) {
      return DoctorAvailabilityState(
        workingDays: availability.workingDays.toSet(),
        startMinutes: availability.startMinutes,
        endMinutes: availability.endMinutes,
        slotMinutes: availability.slotMinutes,
      );
    }
    // Default: Mon-Fri (1..5), 09:00-17:00, 30 min
    return const DoctorAvailabilityState();
  }

  final DoctorAvailabilityStatus status;
  final Set<int> workingDays;
  final int startMinutes;
  final int endMinutes;
  final int slotMinutes;
  final String? errorMessage;

  int get slotsPerDay {
    if (endMinutes <= startMinutes || slotMinutes <= 0) return 0;
    return (endMinutes - startMinutes) ~/ slotMinutes;
  }

  bool get isWorkingDaysValid => workingDays.isNotEmpty;
  bool get isTimeRangeValid => startMinutes < endMinutes;
  bool get isSlotFitsValid =>
      startMinutes < endMinutes && (endMinutes - startMinutes) >= slotMinutes;

  AvailabilityValidationError get validationError {
    if (!isWorkingDaysValid) return AvailabilityValidationError.emptyDays;
    if (!isTimeRangeValid) return AvailabilityValidationError.invalidTimeRange;
    if (!isSlotFitsValid) return AvailabilityValidationError.slotTooLong;
    return AvailabilityValidationError.none;
  }

  bool get isValid => validationError == AvailabilityValidationError.none;

  DoctorAvailability toAvailability() {
    final sortedDays = workingDays.toList()..sort();
    return DoctorAvailability(
      workingDays: sortedDays,
      startMinutes: startMinutes,
      endMinutes: endMinutes,
      slotMinutes: slotMinutes,
    );
  }

  DoctorAvailabilityState copyWith({
    DoctorAvailabilityStatus? status,
    Set<int>? workingDays,
    int? startMinutes,
    int? endMinutes,
    int? slotMinutes,
    String? errorMessage,
  }) {
    return DoctorAvailabilityState(
      status: status ?? this.status,
      workingDays: workingDays ?? this.workingDays,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      slotMinutes: slotMinutes ?? this.slotMinutes,
      errorMessage: errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DoctorAvailabilityState &&
        other.status == status &&
        setEquals(other.workingDays, workingDays) &&
        other.startMinutes == startMinutes &&
        other.endMinutes == endMinutes &&
        other.slotMinutes == slotMinutes &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(
    status,
    Object.hashAll(workingDays),
    startMinutes,
    endMinutes,
    slotMinutes,
    errorMessage,
  );
}
