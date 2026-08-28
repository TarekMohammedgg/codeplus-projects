import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  test('DoctorModel list filters inactive doctors and keeps section order', () {
    final rawDoctors = [
      _doctor(id: 'second', popularOrder: 2),
      _doctor(id: 'inactive', popularOrder: 1, isActive: false),
      _doctor(id: 'first', popularOrder: 1),
    ];

    final activePopular = [
      ...rawDoctors.where((d) => d.isActive && d.isPopular),
    ]..sort((a, b) => a.popularOrder.compareTo(b.popularOrder));

    expect(activePopular.map((doctor) => doctor.id), ['first', 'second']);
  });

  test('DoctorModel.fromFirestore parses and maps fields properly', () {
    final doctor = DoctorModel.fromFirestore('home_doctor', {
      'name': 'Dr. Home',
      'specialtyKey': 'dentist',
      'imageUrl': 'https://res.cloudinary.com/example/doctor',
      'accentColorHex': '#2B7CEE',
      'rating': 4.9,
      'reviewsCount': 12,
      'hourlyRate': 30,
      'isFavorite': true,
      'isPopular': true,
      'popularOrder': 1,
    });

    expect(doctor.specialty, AppLocale.en.buildSync().dentist);
    expect(doctor.isFavorite, isTrue);
    expect(doctor.services, isEmpty);
    expect(doctor.location, isNull);
    expect(doctor.nextAvailableTime, isEmpty);
    expect(doctor.experienceYears, 5);
  });

  test(
    'DoctorModel.fromFirestore throws FormatException on missing required field',
    () {
      expect(
        () =>
            DoctorModel.fromFirestore('bad_doc', {'name': 'Dr. No Specialty'}),
        throwsA(isA<FormatException>()),
      );
    },
  );
}

DoctorModel _doctor({
  required String id,
  required int popularOrder,
  bool isActive = true,
}) {
  return DoctorModel.fromFirestore(id, {
    'name': 'Dr. $id',
    'specialtyKey': 'dentist',
    'imageUrl': 'https://res.cloudinary.com/example/$id',
    'isActive': isActive,
    'isPopular': true,
    'popularOrder': popularOrder,
  });
}
