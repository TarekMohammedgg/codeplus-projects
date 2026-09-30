import 'package:doctor_hunt/apps/core/models/doctor_model.dart';

sealed class BookingState {
  const BookingState();
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingUnavailable extends BookingState {
  const BookingUnavailable();
}

class BookingLoaded extends BookingState {
  const BookingLoaded({
    required this.doctor,
    required this.bookableDates,
    required this.selectedDate,
    required this.slots,
    this.selectedSlot,
    this.nextAvailableDate,
    this.isLoadingSlots = false,
  });

  final DoctorModel doctor;
  final List<DateTime> bookableDates;
  final DateTime selectedDate;
  final List<DateTime> slots;
  final DateTime? selectedSlot;
  final DateTime? nextAvailableDate;
  final bool isLoadingSlots;

  bool get hasSlots => slots.isNotEmpty;

  BookingLoaded copyWith({
    DoctorModel? doctor,
    List<DateTime>? bookableDates,
    DateTime? selectedDate,
    List<DateTime>? slots,
    DateTime? selectedSlot,
    bool clearSelectedSlot = false,
    DateTime? nextAvailableDate,
    bool clearNextAvailableDate = false,
    bool? isLoadingSlots,
  }) {
    return BookingLoaded(
      doctor: doctor ?? this.doctor,
      bookableDates: bookableDates ?? this.bookableDates,
      selectedDate: selectedDate ?? this.selectedDate,
      slots: slots ?? this.slots,
      selectedSlot: clearSelectedSlot
          ? null
          : (selectedSlot ?? this.selectedSlot),
      nextAvailableDate: clearNextAvailableDate
          ? null
          : (nextAvailableDate ?? this.nextAvailableDate),
      isLoadingSlots: isLoadingSlots ?? this.isLoadingSlots,
    );
  }
}
