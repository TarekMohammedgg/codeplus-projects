import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/core/utils/slot_generator.dart';

void main() {
  const availability = DoctorAvailability(
    workingDays: [DateTime.monday, DateTime.wednesday],
    startMinutes: 540,
    endMinutes: 660,
    slotMinutes: 30,
  );
  final monday = DateTime(2026, 10, 5);
  final sundayBefore = DateTime(2026, 10, 4, 12);

  group('slotsForDay', () {
    test('09:00–11:00 with 30 min slots gives 4 slots', () {
      final slots = slotsForDay(availability, monday, {}, sundayBefore);

      expect(slots, [
        DateTime(2026, 10, 5, 9),
        DateTime(2026, 10, 5, 9, 30),
        DateTime(2026, 10, 5, 10),
        DateTime(2026, 10, 5, 10, 30),
      ]);
    });

    test('removes booked slots', () {
      final booked = {DateTime(2026, 10, 5, 9, 30)};

      final slots = slotsForDay(availability, monday, booked, sundayBefore);

      expect(slots, isNot(contains(DateTime(2026, 10, 5, 9, 30))));
      expect(slots, hasLength(3));
    });

    test('removes slots that are not after now for today', () {
      final now = DateTime(2026, 10, 5, 10);

      final slots = slotsForDay(availability, monday, {}, now);

      expect(slots, [DateTime(2026, 10, 5, 10, 30)]);
    });

    test('last slot must end at or before endMinutes', () {
      const uneven = DoctorAvailability(
        workingDays: [DateTime.monday],
        startMinutes: 540,
        endMinutes: 645,
        slotMinutes: 30,
      );

      final slots = slotsForDay(uneven, monday, {}, sundayBefore);

      expect(slots.last, DateTime(2026, 10, 5, 10));
      expect(slots, hasLength(3));
    });
  });

  group('bookableDates', () {
    test('keeps only working days inside the booking window', () {
      final dates = bookableDates(availability, DateTime(2026, 10, 5, 8));

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
      final dates = bookableDates(availability, DateTime(2026, 10, 6, 8));

      expect(dates.any((day) => day.weekday == DateTime.tuesday), isFalse);
      expect(dates.first, DateTime(2026, 10, 7));
    });
  });

  group('ids', () {
    test('slotIdFor is deterministic per doctor and start time', () {
      final id = slotIdFor('doc1', DateTime(2026, 10, 5, 9, 30));

      expect(id, 'doc1_202610050930');
    });

    test('dateKeyFor formats yyyy-MM-dd', () {
      final key = dateKeyFor(DateTime(2026, 10, 5, 9, 30));

      expect(key, '2026-10-05');
    });
  });
}
