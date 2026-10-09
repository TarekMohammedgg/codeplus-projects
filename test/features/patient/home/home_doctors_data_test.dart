import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/core/extensions/doctor_accent_color.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  test('DoctorModel list filters inactive doctors', () {
    // arrange
    final rawDoctors = [
      _doctor(id: 'first'),
      _doctor(id: 'inactive', isActive: false),
      _doctor(id: 'second'),
    ];

    // act
    final active = rawDoctors.where((d) => d.isActive);

    // assert
    expect(active.map((doctor) => doctor.id), ['first', 'second']);
  });

  test('DoctorModel.fromFirestore parses and maps fields properly', () {
    // act
    final doctor = DoctorModel.fromFirestore('home_doctor', {
      'name': 'Dr. Home',
      'specialtyKey': 'dentist',
      'imageUrl': 'https://res.cloudinary.com/example/doctor',
      'accentColorHex': '#2B7CEE',
      'rating': 4.9,
      'reviewsCount': 12,
      'consultationFee': 30,
      'availability': {
        'workingDays': [1, 3],
        'startMinutes': 540,
        'endMinutes': 1020,
        'slotMinutes': 30,
      },
    }, specialtyNameEn: AppLocale.en.buildSync().dentist);

    // assert
    expect(doctor.specialty, AppLocale.en.buildSync().dentist);
    expect(doctor.rating, 4.9);
    expect(doctor.reviewsCount, 12);
    expect(doctor.consultationFee, 30);
    expect(doctor.availability?.workingDays, [1, 3]);
    expect(doctor.availability?.slotMinutes, 30);
  });

  test('DoctorModel defaults to no rating, no fee and no availability', () {
    // act
    final doctor = DoctorModel.fromFirestore('new_doctor', {
      'name': 'Dr. New',
      'specialtyKey': 'dentist',
    });

    // assert
    expect(doctor.rating, 0);
    expect(doctor.reviewsCount, 0);
    expect(doctor.consultationFee, 0);
    expect(doctor.availability, isNull);
  });

  test('DoctorModel displays the current locale name after data is loaded', () {
    LocaleSettings.setLocaleSync(AppLocale.ar);
    final doctor = DoctorModel.fromFirestore('bilingual_doctor', {
      'fullName': {'ar': 'د. أحمد', 'en': 'Dr. Ahmed'},
      'specialtyKey': 'dentist',
    });

    LocaleSettings.setLocaleSync(AppLocale.en);

    expect(doctor.name, 'Dr. Ahmed');
  });

  test('DoctorModel.fromFirestore keeps a doc with a missing field instead of '
      'throwing, so one bad doc cannot break a whole list', () {
    // act
    final doctor = DoctorModel.fromFirestore('bad_doc', {
      'name': 'Dr. No Specialty',
    });

    // assert
    expect(doctor.name, 'Dr. No Specialty');
    expect(doctor.specialty, isEmpty);
  });

  group('DoctorModel accentColorHex normalization and UI fallback', () {
    test('normalizes six-digit color with #', () {
      final doctor = DoctorModel.fromFirestore('doc_color_1', {
        'name': 'Dr. Color',
        'specialty': 'Dentist',
        'accentColorHex': '#2b7cee',
      });
      expect(doctor.accentColorHex, '#2B7CEE');
      expect(doctor.accentColor, const Color(0xFF2B7CEE));
    });

    test('normalizes six-digit color without #', () {
      final doctor = DoctorModel.fromFirestore('doc_color_2', {
        'name': 'Dr. Color',
        'specialty': 'Dentist',
        'accentColorHex': '2b7cee',
      });
      expect(doctor.accentColorHex, '#2B7CEE');
      expect(doctor.accentColor, const Color(0xFF2B7CEE));
    });

    test('normalizes eight-digit color with #', () {
      final doctor = DoctorModel.fromFirestore('doc_color_3', {
        'name': 'Dr. Color',
        'specialty': 'Dentist',
        'accentColorHex': '#FF2B7CEE',
      });
      expect(doctor.accentColorHex, '#FF2B7CEE');
      expect(doctor.accentColor, const Color(0xFF2B7CEE));
    });

    test('normalizes eight-digit color without #', () {
      final doctor = DoctorModel.fromFirestore('doc_color_4', {
        'name': 'Dr. Color',
        'specialty': 'Dentist',
        'accentColorHex': 'ff2b7cee',
      });
      expect(doctor.accentColorHex, '#FF2B7CEE');
      expect(doctor.accentColor, const Color(0xFF2B7CEE));
    });

    test(
      'missing value becomes null and UI falls back to AppColors.primary',
      () {
        final doctor = DoctorModel.fromFirestore('doc_color_5', {
          'name': 'Dr. Color',
          'specialty': 'Dentist',
        });
        expect(doctor.accentColorHex, isNull);
        expect(doctor.accentColor, AppColors.primary);
      },
    );

    test(
      'invalid value becomes null without throwing and falls back to primary',
      () {
        final doctor = DoctorModel.fromFirestore('doc_color_6', {
          'name': 'Dr. Color',
          'specialty': 'Dentist',
          'accentColorHex': 'invalid-hex',
        });
        expect(doctor.accentColorHex, isNull);
        expect(doctor.accentColor, AppColors.primary);

        final doctorShort = DoctorModel.fromFirestore('doc_color_7', {
          'name': 'Dr. Color',
          'specialty': 'Dentist',
          'accentColorHex': '#123',
        });
        expect(doctorShort.accentColorHex, isNull);
        expect(doctorShort.accentColor, AppColors.primary);
      },
    );

    test('copyWith updates or preserves accentColorHex properly', () {
      final doctor = DoctorModel.fromFirestore('doc_color_8', {
        'name': 'Dr. Color',
        'specialty': 'Dentist',
        'accentColorHex': '#112233',
      });
      expect(doctor.accentColorHex, '#112233');

      final updated = doctor.copyWith(accentColorHex: '#445566');
      expect(updated.accentColorHex, '#445566');
      expect(updated.accentColor, const Color(0xFF445566));

      final unchanged = doctor.copyWith(name: 'Dr. New Name');
      expect(unchanged.accentColorHex, '#112233');
    });
  });

  group('DoctorModel Firestore-driven specialty resolution', () {
    test('resolves specialty in Arabic locale', () {
      LocaleSettings.setLocaleSync(AppLocale.ar);
      final doctor = DoctorModel.fromFirestore(
        'doc_spec_ar',
        {'name': 'Dr. Test'},
        specialtyNameAr: 'طبيب باطني',
        specialtyNameEn: 'Medicine Specialist',
      );
      expect(doctor.specialty, 'طبيب باطني');
    });

    test('resolves specialty in English locale', () {
      LocaleSettings.setLocaleSync(AppLocale.en);
      final doctor = DoctorModel.fromFirestore(
        'doc_spec_en',
        {'name': 'Dr. Test'},
        specialtyNameAr: 'طبيب باطني',
        specialtyNameEn: 'Medicine Specialist',
      );
      expect(doctor.specialty, 'Medicine Specialist');
    });

    test(
      'updates specialty dynamically when locale changes after model parsing',
      () {
        LocaleSettings.setLocaleSync(AppLocale.ar);
        final doctor = DoctorModel.fromFirestore(
          'doc_spec_dyn',
          {
            'fullName': {'ar': 'د. سامي', 'en': 'Dr. Sami'},
          },
          specialtyNameAr: 'طبيب أطفال',
          specialtyNameEn: 'Pediatrician',
        );
        expect(doctor.specialty, 'طبيب أطفال');
        expect(doctor.name, 'د. سامي');

        LocaleSettings.setLocaleSync(AppLocale.en);
        expect(doctor.specialty, 'Pediatrician');
        expect(doctor.name, 'Dr. Sami');
      },
    );

    test('falls back to alternate language when Arabic value is missing', () {
      LocaleSettings.setLocaleSync(AppLocale.ar);
      final doctor = DoctorModel.fromFirestore('doc_spec_no_ar', {
        'name': 'Dr. Test',
      }, specialtyNameEn: 'Cardiologist');
      expect(doctor.specialty, 'Cardiologist');
    });

    test('falls back to alternate language when English value is missing', () {
      LocaleSettings.setLocaleSync(AppLocale.en);
      final doctor = DoctorModel.fromFirestore('doc_spec_no_en', {
        'name': 'Dr. Test',
      }, specialtyNameAr: 'طبيب قلب');
      expect(doctor.specialty, 'طبيب قلب');
    });

    test('resolves legacy raw specialty string for older documents', () {
      LocaleSettings.setLocaleSync(AppLocale.en);
      final doctor = DoctorModel.fromFirestore('doc_spec_legacy', {
        'name': 'Dr. Test',
        'specialty': 'Dermatology',
      });
      expect(doctor.specialty, 'Dermatology');
    });

    test('safely resolves legacy specialty with unknown specialty ID', () {
      final doctor = DoctorModel.fromFirestore('doc_spec_unknown_id', {
        'name': 'Dr. Test',
        'specialtyId': 'unknown_specialty_999',
        'specialty': 'Legacy Specialty',
      });
      expect(doctor.specialtyId, 'unknown_specialty_999');
      expect(doctor.specialty, 'Legacy Specialty');
    });

    test(
      'resolves a new arbitrary Firestore specialty without Dart enum change',
      () {
        final doctor = DoctorModel.fromFirestore(
          'doc_spec_arbitrary',
          {'name': 'Dr. Test'},
          specialtyNameAr: 'تخصص غير مسبوق في الطب الجيني',
          specialtyNameEn: 'Genetic Medicine Specialist',
        );
        LocaleSettings.setLocaleSync(AppLocale.en);
        expect(doctor.specialty, 'Genetic Medicine Specialist');
        LocaleSettings.setLocaleSync(AppLocale.ar);
        expect(doctor.specialty, 'تخصص غير مسبوق في الطب الجيني');
      },
    );

    test(
      'resolves placeholder doctor using slang translations dynamically',
      () {
        addTearDown(() => LocaleSettings.setLocaleSync(AppLocale.en));

        final doctor = DoctorModel.placeholder();
        expect(doctor.id, 'placeholder');

        LocaleSettings.setLocaleSync(AppLocale.en);
        expect(doctor.name, 'Dr. Pediatrician');
        expect(doctor.specialty, 'Medicine Specialist');

        LocaleSettings.setLocaleSync(AppLocale.ar);
        expect(doctor.name, 'د. طبيب أطفال');
        expect(doctor.specialty, 'أخصائي طب عام');
      },
    );
  });
}

DoctorModel _doctor({required String id, bool isActive = true}) {
  return DoctorModel.fromFirestore(id, {
    'name': 'Dr. $id',
    'specialtyKey': 'dentist',
    'imageUrl': 'https://res.cloudinary.com/example/$id',
    'isActive': isActive,
  });
}
