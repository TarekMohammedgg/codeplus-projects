import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/core/utils/slot_generator.dart';

void main() {
  // 09:00–11:00, 30 min, Monday + Wednesday.
  const availability = DoctorAvailability(
    workingDays: [DateTime.monday, DateTime.wednesday],
    startMinutes: 540,
    endMinutes: 660,
    slotMinutes: 30,
  );
  // Monday 5 Oct 2026.
  final monday = DateTime(2026, 10, 5);
  final sundayBefore = DateTime(2026, 10, 4, 12);

  group('slotsForDay', () {
    test('09:00–11:00 with 30 min slots gives 4 slots', () {
      // act
      final slots = slotsForDay(availability, monday, {}, sundayBefore);

      // assert
      expect(slots, [
        DateTime(2026, 10, 5, 9),
        DateTime(2026, 10, 5, 9, 30),
        DateTime(2026, 10, 5, 10),
        DateTime(2026, 10, 5, 10, 30),
      ]);
    });

    test('removes booked slots', () {
      // arrange
      final booked = {DateTime(2026, 10, 5, 9, 30)};

      // act
      final slots = slotsForDay(availability, monday, booked, sundayBefore);

      // assert
      expect(slots, isNot(contains(DateTime(2026, 10, 5, 9, 30))));
      expect(slots, hasLength(3));
    });

    test('removes slots that are not after now for today', () {
      // arrange
      final now = DateTime(2026, 10, 5, 10);

      // act
      final slots = slotsForDay(availability, monday, {}, now);

      // assert
      expect(slots, [DateTime(2026, 10, 5, 10, 30)]);
    });

    test('last slot must end at or before endMinutes', () {
      // arrange: 09:00–10:45 with 30 min slots leaves a 15 min tail.
      const uneven = DoctorAvailability(
        workingDays: [DateTime.monday],
        startMinutes: 540,
        endMinutes: 645,
        slotMinutes: 30,
      );

      // act
      final slots = slotsForDay(uneven, monday, {}, sundayBefore);

      // assert
      expect(slots.last, DateTime(2026, 10, 5, 10));
      expect(slots, hasLength(3));
    });
  });

  group('bookableDates', () {
    test('keeps only working days inside the booking window', () {
      // act
      final dates = bookableDates(availability, DateTime(2026, 10, 5, 8));

      // assert
      expect(dates, hasLength(4));
      expect(
        dates.every(
          (day) =>
              day.weekday == DateTime.monday ||
              day.weekday == DateTime.wednesday,
        ),
        isTrue,
      );
      expect(dates.first, DateTime(2026, 10, 5));
      expect(
        dates.last.isBefore(
          DateTime(2026, 10, 5).add(const Duration(days: bookingWindowDays)),
        ),
        isTrue,
      );
    });

    test('excludes non-working days', () {
      // act: Tuesday is not a working day.
      final dates = bookableDates(availability, DateTime(2026, 10, 6, 8));

      // assert
      expect(dates.any((day) => day.weekday == DateTime.tuesday), isFalse);
      expect(dates.first, DateTime(2026, 10, 7));
    });
  });

  group('ids', () {
    test('slotIdFor is deterministic per doctor and start time', () {
      // act
      final id = slotIdFor('doc1', DateTime(2026, 10, 5, 9, 30));

      // assert
      expect(id, 'doc1_202610050930');
    });

    test('dateKeyFor formats yyyy-MM-dd', () {
      // act
      final key = dateKeyFor(DateTime(2026, 10, 5, 9, 30));

      // assert
      expect(key, '2026-10-05');
    });
  });
}
