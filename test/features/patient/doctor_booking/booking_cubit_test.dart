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
    startMinutes: 9 * 60,
    endMinutes: 12 * 60,
    slotMinutes: 60,
  );

  final testDoctorWithAvail = DoctorModel(
    id: 'doc-1',
    nameEn: 'Dr. Test',
    specialtyEn: 'Cardiologist',
    availability: availability,
  );

  final testDoctorNoAvail = const DoctorModel(
    id: 'doc-2',
    nameEn: 'Dr. No Avail',
    specialtyEn: 'Cardiologist',
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
        final testNow = DateTime(2026, 3, 2, 8, 0);

        await cubit.init(testDoctorWithAvail, now: testNow);

        expect(cubit.state, isA<BookingLoaded>());
        final loaded = cubit.state as BookingLoaded;
        expect(loaded.doctor.id, 'doc-1');
        expect(loaded.bookableDates.isNotEmpty, isTrue);
        expect(loaded.slots.length, 3);
        expect(loaded.slotsByDate[DateTime(2026, 3, 2)], hasLength(3));
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
      'a fully booked day has no slots while the next day keeps its slots',
      () async {
        // arrange
        final repo = FakeBookingRepository(
          booked: [
            DateTime(2026, 3, 2, 9, 0),
            DateTime(2026, 3, 2, 10, 0),
            DateTime(2026, 3, 2, 11, 0),
          ],
        );
        final cubit = BookingCubit(repository: repo);

        // act
        await cubit.init(testDoctorWithAvail, now: DateTime(2026, 3, 2, 8, 0));

        // assert
        final loaded = cubit.state as BookingLoaded;
        expect(loaded.slots, isEmpty);
        expect(loaded.slotsByDate[DateTime(2026, 3, 3)], hasLength(3));
        await cubit.close();
      },
    );

    test(
      'emits BookingLoadFailure when booked slots cannot be loaded',
      () async {
        // arrange
        final repo = FakeBookingRepository(fetchError: StateError('offline'));
        final cubit = BookingCubit(repository: repo);

        // act
        await cubit.init(testDoctorWithAvail, now: DateTime(2026, 3, 2, 8, 0));

        // assert
        expect(cubit.state, isA<BookingLoadFailure>());
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
      final repo = FakeBookingRepository();
      final cubit = BookingCubit(repository: repo);
      final states = expectLater(
        cubit.stream,
        emitsInOrder([isA<BookingSubmitting>(), isA<BookingConfirmed>()]),
      );

      await cubit.confirm(draft);

      await states;
      expect(repo.bookedDrafts.single.startAt, draft.startAt);
      await cubit.close();
    });

    test('second patient on the same slot gets slotAlreadyBooked', () async {
      final repo = FakeBookingRepository(
        bookError: const SlotAlreadyBookedException(),
      );
      final cubit = BookingCubit(repository: repo);

      await cubit.confirm(draft);

      final state = cubit.state as BookingConfirmFailure;
      expect(state.code, BookingFailureCode.slotAlreadyBooked);
      await cubit.close();
    });

    test('any other error maps to unknown', () async {
      final repo = FakeBookingRepository(bookError: StateError('offline'));
      final cubit = BookingCubit(repository: repo);

      await cubit.confirm(draft);

      final state = cubit.state as BookingConfirmFailure;
      expect(state.code, BookingFailureCode.unknown);
      await cubit.close();
    });
  });
}
