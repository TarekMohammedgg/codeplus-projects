import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

void main() {
  const cardiology = SpecialtyModel(
    id: 'cardiologist',
    nameAr: 'طبيب قلب',
    nameEn: 'Cardiologist',
  );

  tearDown(() => LocaleSettings.setLocaleSync(AppLocale.en));

  test('fromFirestore reads the locked doctor fields', () {
    // arrange
    final data = {
      'fullName': {'ar': 'د. أحمد', 'en': 'Dr. Ahmed'},
      'specialtyId': 'cardiologist',
      'imageUrl': 'https://example.com/a.png',
      'consultationFee': 30,
      'rating': 4.5,
      'reviewsCount': 12,
      'isActive': false,
      'availability': {
        'workingDays': [1, 3],
        'startMinutes': 540,
        'endMinutes': 1020,
        'slotMinutes': 30,
      },
    };

    // act
    final doctor = DoctorModel.fromFirestore(
      'doc_1',
      data,
      specialty: cardiology,
    );

    // assert
    expect(doctor.nameEn, 'Dr. Ahmed');
    expect(doctor.nameAr, 'د. أحمد');
    expect(doctor.specialtyEn, 'Cardiologist');
    expect(doctor.specialtyId, 'cardiologist');
    expect(doctor.consultationFee, 30);
    expect(doctor.rating, 4.5);
    expect(doctor.reviewsCount, 12);
    expect(doctor.isActive, isFalse);
    expect(doctor.availability?.workingDays, [1, 3]);
  });

  test('fromFirestore uses safe defaults for missing optional fields', () {
    // act
    final doctor = DoctorModel.fromFirestore('doc_2', {
      'fullName': {'en': 'Dr. New'},
    });

    // assert
    expect(doctor.rating, 0);
    expect(doctor.reviewsCount, 0);
    expect(doctor.consultationFee, 0);
    expect(doctor.isActive, isTrue);
    expect(doctor.availability, isNull);
    expect(doctor.specialty, isEmpty);
  });

  test('name and specialty follow the current locale', () {
    // arrange
    final doctor = DoctorModel.fromFirestore('doc_3', {
      'fullName': {'ar': 'د. سامي', 'en': 'Dr. Sami'},
    }, specialty: cardiology);

    // act
    LocaleSettings.setLocaleSync(AppLocale.ar);

    // assert
    expect(doctor.name, 'د. سامي');
    expect(doctor.specialty, 'طبيب قلب');
  });

  test('Arabic locale falls back to English when Arabic is empty', () {
    // arrange
    const doctor = DoctorModel(id: 'doc_4', nameEn: 'Dr. Only English');

    // act
    LocaleSettings.setLocaleSync(AppLocale.ar);

    // assert
    expect(doctor.name, 'Dr. Only English');
  });

  test('nameContains matches either language and ignores case', () {
    // arrange
    const doctor = DoctorModel(
      id: 'doc_5',
      nameEn: 'Dr. Ahmed',
      nameAr: 'د. أحمد',
    );

    // act
    final results = [
      doctor.nameContains('ahm'),
      doctor.nameContains('أحمد'),
      doctor.nameContains(''),
      doctor.nameContains('sara'),
    ];

    // assert
    expect(results, [true, true, true, false]);
  });
}
