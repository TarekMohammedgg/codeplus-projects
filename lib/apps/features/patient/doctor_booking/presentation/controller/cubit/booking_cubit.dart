import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/utils/slot_generator.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/models/booking_draft.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/repositories/booking_repository.dart';

import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit({required this.repository}) : super(const BookingInitial());

  final BookingRepository repository;
  DateTime _now = DateTime.now();
  StreamSubscription<Set<DateTime>>? _bookedSubscription;

  Future<void> init(DoctorModel doctor, {DateTime? now}) async {
    _now = now ?? DateTime.now();
    final availability = doctor.availability;
    final dates = availability == null
        ? const <DateTime>[]
        : bookableDates(availability, _now);
    if (dates.isEmpty) {
      emit(const BookingUnavailable());
      return;
    }

    emit(
      BookingLoaded(
        doctor: doctor,
        bookableDates: dates,
        selectedDate: dates.first,
        isLoadingSlots: true,
      ),
    );
    await _bookedSubscription?.cancel();
    _bookedSubscription = repository
        .watchBookedStarts(doctor.id, dates)
        .listen(_onBookedChanged, onError: _emitLoadFailure);
  }

  void _onBookedChanged(Set<DateTime> booked) {
    final current = state;
    if (current is! BookingLoaded) return;
    final slotsByDate = {
      for (final date in current.bookableDates)
        date: slotsForDay(current.doctor.availability!, date, booked, _now),
    };
    final selectedSlot = current.selectedSlot;
    emit(
      BookingLoaded(
        doctor: current.doctor,
        bookableDates: current.bookableDates,
        selectedDate: current.selectedDate,
        slotsByDate: slotsByDate,
        selectedSlot:
            selectedSlot != null &&
                slotsByDate[current.selectedDate]!.contains(selectedSlot)
            ? selectedSlot
            : null,
      ),
    );
  }

  void selectDate(DateTime date) {
    final current = state;
    if (current is! BookingLoaded) return;
    emit(
      BookingLoaded(
        doctor: current.doctor,
        bookableDates: current.bookableDates,
        selectedDate: date,
        slotsByDate: current.slotsByDate,
        isLoadingSlots: current.isLoadingSlots,
      ),
    );
  }

  void selectSlot(DateTime slot) {
    final current = state;
    if (current is! BookingLoaded) return;
    emit(
      BookingLoaded(
        doctor: current.doctor,
        bookableDates: current.bookableDates,
        selectedDate: current.selectedDate,
        slotsByDate: current.slotsByDate,
        selectedSlot: slot,
      ),
    );
  }

  Stream<ClinicModel?> watchClinic() => repository.watchClinic();

  Future<void> confirm(BookingDraft draft) async {
    if (state is BookingSubmitting) return;

    emit(const BookingSubmitting());
    try {
      await repository.book(draft);
      if (isClosed) return;
      emit(BookingConfirmed(draft: draft));
    } on SlotAlreadyBookedException {
      if (isClosed) return;
      emit(
        const BookingConfirmFailure(code: BookingFailureCode.slotAlreadyBooked),
      );
    } on DoctorUnavailableException {
      if (isClosed) return;
      emit(
        const BookingConfirmFailure(code: BookingFailureCode.doctorUnavailable),
      );
    } catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      emit(const BookingConfirmFailure(code: BookingFailureCode.unknown));
    }
  }

  void _emitLoadFailure(Object error, StackTrace stackTrace) {
    if (isClosed) return;
    addError(error, stackTrace);
    emit(const BookingLoadFailure());
  }

  @override
  Future<void> close() async {
    await _bookedSubscription?.cancel();
    return super.close();
  }
}
