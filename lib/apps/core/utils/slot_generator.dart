import 'package:intl/intl.dart';

import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';

// ponytail: fixed window, make admin-configurable if needed
const bookingWindowDays = 14;

/// Dates (at midnight) in the next [bookingWindowDays] days, starting today,
/// that fall on one of the doctor's working days.
List<DateTime> bookableDates(DoctorAvailability availability, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  return [
    for (var offset = 0; offset < bookingWindowDays; offset++)
      DateTime(today.year, today.month, today.day + offset),
  ].where((day) => availability.workingDays.contains(day.weekday)).toList();
}

/// Slot start times for [day], excluding [booked] ones and anything not
/// after [now]. The last slot always ends at or before `endMinutes`.
List<DateTime> slotsForDay(
  DoctorAvailability availability,
  DateTime day,
  Set<DateTime> booked,
  DateTime now,
) {
  final slots = <DateTime>[];
  for (
    var minutes = availability.startMinutes;
    minutes + availability.slotMinutes <= availability.endMinutes;
    minutes += availability.slotMinutes
  ) {
    final start = DateTime(
      day.year,
      day.month,
      day.day,
      minutes ~/ 60,
      minutes % 60,
    );
    if (start.isAfter(now) && !booked.contains(start)) slots.add(start);
  }
  return slots;
}

/// Deterministic id of the `bookedSlots` lock document for one slot.
String slotIdFor(String doctorId, DateTime startAt) =>
    '${doctorId}_${DateFormat('yyyyMMddHHmm').format(startAt)}';

String dateKeyFor(DateTime day) => DateFormat('yyyy-MM-dd').format(day);
