import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/utils/slot_generator.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/models/booking_draft.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/repositories/booking_repository.dart';

import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit({required this.repository, this.clock})
    : super(const BookingInitial());

  final BookingRepository repository;
  final DateTime Function()? clock;
  DoctorModel? _doctor;
  DateTime? _overrideNow;

  DateTime get _now =>
      _overrideNow ?? (clock != null ? clock!() : DateTime.now());

  Future<void> init(DoctorModel doctor, {DateTime? now}) async {
    _overrideNow = now;
    _doctor = doctor;
    final availability = doctor.availability;
    if (availability == null) {
      emit(const BookingUnavailable());
      return;
    }

    final currentTime = _now;
    final dates = bookableDates(availability, currentTime);
    if (dates.isEmpty) {
      emit(const BookingUnavailable());
      return;
    }

    final firstDate = dates.first;
    emit(
      BookingLoaded(
        doctor: doctor,
        bookableDates: dates,
        selectedDate: firstDate,
        slots: const [],
        isLoadingSlots: true,
      ),
    );

    await selectDate(firstDate, now: currentTime);
  }

  Future<void> selectDate(DateTime date, {DateTime? now}) async {
    final doctor = _doctor;
    final availability = doctor?.availability;
    if (doctor == null || availability == null) return;

    final currentTime = now ?? _now;
    final currentState = state;
    final dates = currentState is BookingLoaded
        ? currentState.bookableDates
        : bookableDates(availability, currentTime);

    emit(
      BookingLoaded(
        doctor: doctor,
        bookableDates: dates,
        selectedDate: date,
        slots: const [],
        selectedSlot: null,
        isLoadingSlots: true,
      ),
    );

    try {
      final booked = await repository.fetchBookedStarts(doctor.id, date);
      final slots = slotsForDay(availability, date, booked, currentTime);

      DateTime? nextDate;
      if (slots.isEmpty) {
        nextDate = await _findNextDateWithSlots(
          fromDate: date,
          dates: dates,
          availability: availability,
          doctorId: doctor.id,
          now: currentTime,
        );
      }

      emit(
        BookingLoaded(
          doctor: doctor,
          bookableDates: dates,
          selectedDate: date,
          slots: slots,
          selectedSlot: null,
          nextAvailableDate: nextDate,
          isLoadingSlots: false,
        ),
      );
    } catch (_) {
      emit(
        BookingLoaded(
          doctor: doctor,
          bookableDates: dates,
          selectedDate: date,
          slots: const [],
          selectedSlot: null,
          isLoadingSlots: false,
        ),
      );
    }
  }

  /// Clinic location for the review step (live from `clinic/settings`).
  Stream<ClinicModel?> watchClinic() => repository.watchClinic();

  /// Step 4: books [draft] in one transaction (appointment + slot lock).
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
    } catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      emit(const BookingConfirmFailure(code: BookingFailureCode.unknown));
    }
  }

  void selectSlot(DateTime slot) {
    final currentState = state;
    if (currentState is BookingLoaded) {
      emit(currentState.copyWith(selectedSlot: slot));
    }
  }

  Future<DateTime?> _findNextDateWithSlots({
    required DateTime fromDate,
    required List<DateTime> dates,
    required DoctorAvailability availability,
    required String doctorId,
    required DateTime now,
  }) async {
    final currentIndex = dates.indexWhere(
      (d) => DateUtils.isSameDay(d, fromDate),
    );
    final startIndex = currentIndex == -1 ? 0 : currentIndex + 1;

    for (var i = startIndex; i < dates.length; i++) {
      final candidateDate = dates[i];
      try {
        final booked = await repository.fetchBookedStarts(
          doctorId,
          candidateDate,
        );
        final slots = slotsForDay(availability, candidateDate, booked, now);
        if (slots.isNotEmpty) {
          return candidateDate;
        }
      } catch (_) {
        continue;
      }
    }
    return null;
  }
}
