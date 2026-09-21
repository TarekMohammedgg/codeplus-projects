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
    }, specialtyNameEn: AppLocale.en.buildSync().dentist);

    expect(doctor.specialty, AppLocale.en.buildSync().dentist);
    expect(doctor.isFavorite, isTrue);
    expect(doctor.services, isEmpty);
    expect(doctor.location, isNull);
    expect(doctor.nextAvailableTime, isEmpty);
    expect(doctor.experienceYears, 5);
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
  });
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
