import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/controller/cubit/booking_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/controller/cubit/booking_state.dart';
import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/models/booking_draft.dart';

import '../../../helpers/test_fakes.dart';

void main() {
  final availability = DoctorAvailability(
    workingDays: const [1, 2, 3, 4, 5, 6, 7],
    startMinutes: 9 * 60, // 09:00
    endMinutes: 12 * 60, // 12:00
    slotMinutes: 60, // 3 slots: 9, 10, 11
  );

  final testDoctorWithAvail = DoctorModel(
    id: 'doc-1',
    name: 'Dr. Test',
    specialty: 'Cardiologist',
    availability: availability,
  );

  final testDoctorNoAvail = const DoctorModel(
    id: 'doc-2',
    name: 'Dr. No Avail',
    specialty: 'Cardiologist',
  );

  group('BookingCubit', () {
    test('emits BookingUnavailable when doctor has no availability', () async {
      final repo = FakeBookingRepository();
      final cubit = BookingCubit(repository: repo);

      await cubit.init(testDoctorNoAvail);

      expect(cubit.state, isA<BookingUnavailable>());
      await cubit.close();
    });

    test(
      'emits BookingLoaded and fetches slots when availability is present',
      () async {
        final repo = FakeBookingRepository();
        final cubit = BookingCubit(repository: repo);
        final testNow = DateTime(2026, 3, 2, 8, 0); // Monday 08:00

        await cubit.init(testDoctorWithAvail, now: testNow);

        expect(cubit.state, isA<BookingLoaded>());
        final loaded = cubit.state as BookingLoaded;
        expect(loaded.doctor.id, 'doc-1');
        expect(loaded.bookableDates.isNotEmpty, isTrue);
        expect(loaded.slots.length, 3);
        expect(loaded.slotsCountByDate.isNotEmpty, isTrue);
        expect(loaded.slotsCountByDate[DateTime(2026, 3, 2)], 3);
        expect(loaded.selectedSlot, isNull);

        await cubit.close();
      },
    );

    test('selectSlot updates selectedSlot in state', () async {
      final repo = FakeBookingRepository();
      final cubit = BookingCubit(repository: repo);
      final testNow = DateTime(2026, 3, 2, 8, 0);

      await cubit.init(testDoctorWithAvail, now: testNow);
      final loaded = cubit.state as BookingLoaded;
      final slotToSelect = loaded.slots.first;

      cubit.selectSlot(slotToSelect);

      expect((cubit.state as BookingLoaded).selectedSlot, slotToSelect);
      await cubit.close();
    });

    test(
      'when selected date is fully booked, finds nextAvailableDate',
      () async {
        // 2026-03-02 slots are 9:00, 10:00, 11:00
        final fullyBookedDay = [
          DateTime(2026, 3, 2, 9, 0),
          DateTime(2026, 3, 2, 10, 0),
          DateTime(2026, 3, 2, 11, 0),
        ];
        final repo = FakeBookingRepository(booked: fullyBookedDay);
        final cubit = BookingCubit(repository: repo);
        final testNow = DateTime(2026, 3, 2, 8, 0);

        await cubit.init(testDoctorWithAvail, now: testNow);

        final loaded = cubit.state as BookingLoaded;
        expect(loaded.slots, isEmpty);
        expect(loaded.nextAvailableDate, isNotNull);
        expect(loaded.nextAvailableDate!.day, 3);

        await cubit.close();
      },
    );
  });

  group('confirm', () {
    final draft = BookingDraft(
      doctor: testDoctorWithAvail,
      startAt: DateTime(2026, 10, 15, 10),
    );

    test('emits submitting then confirmed and books the draft', () async {
      // arrange
      final repo = FakeBookingRepository();
      final cubit = BookingCubit(repository: repo);
      final states = expectLater(
        cubit.stream,
        emitsInOrder([isA<BookingSubmitting>(), isA<BookingConfirmed>()]),
      );

      // act
      await cubit.confirm(draft);

      // assert
      await states;
      expect(repo.bookedDrafts.single.startAt, draft.startAt);
      await cubit.close();
    });

    test('second patient on the same slot gets slotAlreadyBooked', () async {
      // arrange
      final repo = FakeBookingRepository(
        bookError: const SlotAlreadyBookedException(),
      );
      final cubit = BookingCubit(repository: repo);

      // act
      await cubit.confirm(draft);

      // assert
      final state = cubit.state as BookingConfirmFailure;
      expect(state.code, BookingFailureCode.slotAlreadyBooked);
      await cubit.close();
    });

    test('any other error maps to unknown', () async {
      // arrange
      final repo = FakeBookingRepository(bookError: StateError('offline'));
      final cubit = BookingCubit(repository: repo);

      // act
      await cubit.confirm(draft);

      // assert
      final state = cubit.state as BookingConfirmFailure;
      expect(state.code, BookingFailureCode.unknown);
      await cubit.close();
    });
  });
}
