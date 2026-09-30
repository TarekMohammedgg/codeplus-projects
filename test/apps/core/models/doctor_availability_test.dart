import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';

void main() {
  final validMap = {
    'workingDays': [1, 2, 3],
    'startMinutes': 540,
    'endMinutes': 1020,
    'slotMinutes': 30,
  };

  test('tryParse reads a valid map and toMap round-trips it', () {
    // act
    final availability = DoctorAvailability.tryParse(validMap);

    // assert
    expect(availability, isNotNull);
    expect(availability!.toMap(), validMap);
  });

  test('tryParse returns null for missing or malformed data', () {
    // assert
    expect(DoctorAvailability.tryParse(null), isNull);
    expect(DoctorAvailability.tryParse('not a map'), isNull);
    expect(
      DoctorAvailability.tryParse({...validMap, 'startMinutes': '09:00'}),
      isNull,
    );
  });

  test('tryParse returns null for an unusable schedule', () {
    // assert
    expect(
      DoctorAvailability.tryParse({...validMap, 'workingDays': <int>[]}),
      isNull,
    );
    expect(
      DoctorAvailability.tryParse({
        ...validMap,
        'workingDays': [0, 8],
      }),
      isNull,
    );
    expect(
      DoctorAvailability.tryParse({...validMap, 'slotMinutes': 0}),
      isNull,
    );
    expect(
      DoctorAvailability.tryParse({...validMap, 'endMinutes': 540}),
      isNull,
    );
  });
}
