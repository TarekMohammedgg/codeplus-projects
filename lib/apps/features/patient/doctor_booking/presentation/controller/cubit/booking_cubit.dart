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
    try {
      final slots = await Future.wait(
        dates.map((date) => _fetchSlots(doctor, date)),
      );
      if (isClosed) return;
      emit(
        BookingLoaded(
          doctor: doctor,
          bookableDates: dates,
          selectedDate: dates.first,
          slotsByDate: Map.fromIterables(dates, slots),
        ),
      );
    } catch (error, stackTrace) {
      _emitLoadFailure(error, stackTrace);
    }
  }

  Future<void> selectDate(DateTime date) async {
    final current = state;
    if (current is! BookingLoaded) return;

    emit(
      BookingLoaded(
        doctor: current.doctor,
        bookableDates: current.bookableDates,
        selectedDate: date,
        slotsByDate: current.slotsByDate,
        isLoadingSlots: true,
      ),
    );
    try {
      final slots = await _fetchSlots(current.doctor, date);
      if (isClosed) return;
      emit(
        BookingLoaded(
          doctor: current.doctor,
          bookableDates: current.bookableDates,
          selectedDate: date,
          slotsByDate: {...current.slotsByDate, date: slots},
        ),
      );
    } catch (error, stackTrace) {
      _emitLoadFailure(error, stackTrace);
    }
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

  Future<List<DateTime>> _fetchSlots(DoctorModel doctor, DateTime day) async {
    final booked = await repository.fetchBookedStarts(doctor.id, day);
    return slotsForDay(doctor.availability!, day, booked, _now);
  }

  void _emitLoadFailure(Object error, StackTrace stackTrace) {
    if (isClosed) return;
    addError(error, stackTrace);
    emit(const BookingLoadFailure());
  }
}
