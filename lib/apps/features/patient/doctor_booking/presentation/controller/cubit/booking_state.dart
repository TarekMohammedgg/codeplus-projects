import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/models/booking_draft.dart';

sealed class BookingState {
  const BookingState();
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingUnavailable extends BookingState {
  const BookingUnavailable();
}

class BookingLoadFailure extends BookingState {
  const BookingLoadFailure();
}

class BookingLoaded extends BookingState {
  const BookingLoaded({
    required this.doctor,
    required this.bookableDates,
    required this.selectedDate,
    this.slotsByDate = const {},
    this.selectedSlot,
    this.isLoadingSlots = false,
  });

  final DoctorModel doctor;
  final List<DateTime> bookableDates;
  final DateTime selectedDate;
  final Map<DateTime, List<DateTime>> slotsByDate;
  final DateTime? selectedSlot;
  final bool isLoadingSlots;

  List<DateTime> get slots => slotsByDate[selectedDate] ?? const [];
}

class BookingSubmitting extends BookingState {
  const BookingSubmitting();
}

class BookingConfirmed extends BookingState {
  const BookingConfirmed({required this.draft});

  final BookingDraft draft;
}

enum BookingFailureCode { slotAlreadyBooked, doctorUnavailable, unknown }

class BookingConfirmFailure extends BookingState {
  const BookingConfirmFailure({required this.code});

  final BookingFailureCode code;
}
