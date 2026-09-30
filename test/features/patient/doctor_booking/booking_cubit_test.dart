import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/repositories/booking_repository.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/controller/cubit/booking_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/controller/cubit/booking_state.dart';

class _FakeBookingRepository implements BookingRepository {
  _FakeBookingRepository({this.booked = const []});
  final List<DateTime> booked;

  @override
  Future<Set<DateTime>> fetchBookedStarts(
    String doctorId,
    DateTime day,
  ) async {
    return booked
        .where(
          (b) => b.year == day.year && b.month == day.month && b.day == day.day,
        )
        .toSet();
  }
}

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
      final repo = _FakeBookingRepository();
      final cubit = BookingCubit(repository: repo);

      await cubit.init(testDoctorNoAvail);

      expect(cubit.state, isA<BookingUnavailable>());
      await cubit.close();
    });

    test(
      'emits BookingLoaded and fetches slots when availability is present',
      () async {
        final repo = _FakeBookingRepository();
        final cubit = BookingCubit(repository: repo);
        final testNow = DateTime(2026, 3, 2, 8, 0); // Monday 08:00

        await cubit.init(testDoctorWithAvail, now: testNow);

        expect(cubit.state, isA<BookingLoaded>());
        final loaded = cubit.state as BookingLoaded;
        expect(loaded.doctor.id, 'doc-1');
        expect(loaded.bookableDates.isNotEmpty, isTrue);
        expect(loaded.slots.length, 3);
        expect(loaded.selectedSlot, isNull);

        await cubit.close();
      },
    );

    test('selectSlot updates selectedSlot in state', () async {
      final repo = _FakeBookingRepository();
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
        final repo = _FakeBookingRepository(booked: fullyBookedDay);
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
}
