import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';

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

  setUpAll(() => initializeDateFormatting('en'));

  group('DoctorModel', () {
    test('parses timestamps and computes lastModified correctly', () {
      final created = DateTime(2026, 9, 1, 10, 0);
      final updated = DateTime(2026, 9, 5, 12, 30);

      final modelWithBoth = DoctorModel.fromFirestore('doc1', {
        'name': 'Dr. Alice',
        'specialty': 'Dentist',
        'createdAt': Timestamp.fromDate(created),
        'updatedAt': Timestamp.fromDate(updated),
      });

      expect(modelWithBoth.lastModified, updated);

      final modelCreatedOnly = DoctorModel.fromFirestore('doc2', {
        'name': 'Dr. Bob',
        'specialty': 'Cardiologist',
        'createdAt': Timestamp.fromDate(created),
      });

      expect(modelCreatedOnly.lastModified, created);

      final modelNoTimestamp = DoctorModel.fromFirestore('doc3', {
        'name': 'Dr. Charlie',
        'specialty': 'Pediatrician',
      });

      expect(modelNoTimestamp.lastModified, isNull);
    });

    test('parses rating, reviewsCount, and availability correctly', () {
      final model = DoctorModel.fromFirestore('doc4', {
        'name': 'Dr. David',
        'specialty': 'Cardiologist',
        'rating': 4.8,
        'reviewsCount': 35,
        'availability': {
          'workingDays': [1, 2, 3],
          'startMinutes': 540,
          'endMinutes': 1020,
          'slotMinutes': 30,
        },
      });

      expect(model.rating, 4.8);
      expect(model.reviewsCount, 35);
      expect(model.availability, isNotNull);
      expect(model.availability!.workingDays, [1, 2, 3]);
      expect(model.availability!.startMinutes, 540);
      expect(model.availability!.endMinutes, 1020);
      expect(model.availability!.slotMinutes, 30);

      final summary = model.availability!.formatSummary(locale: 'en');
      expect(summary, contains('09:00–17:00'));
      expect(summary, contains('30 min'));
    });
  });

  group('Admin doctor list sorting', () {
    void sortDoctors(List<DoctorModel> list) {
      list.sort((a, b) {
        final aTime = a.lastModified ?? DateTime.now();
        final bTime = b.lastModified ?? DateTime.now();
        return bTime.compareTo(aTime);
      });
    }

    test('sorts doctors descending by lastModified (newest first)', () {
      final t1 = DateTime(2026, 9, 1, 10, 0);
      final t2 = DateTime(2026, 9, 2, 10, 0);
      final t3 = DateTime(2026, 9, 3, 10, 0);

      final doc1 = DoctorModel(
        id: '1',
        nameEn: 'Doctor 1',
        specialtyEn: 'Spec 1',
        lastModified: t1,
      );
      final doc2 = DoctorModel(
        id: '2',
        nameEn: 'Doctor 2',
        specialtyEn: 'Spec 2',
        lastModified: t2,
      );
      final doc3 = DoctorModel(
        id: '3',
        nameEn: 'Doctor 3',
        specialtyEn: 'Spec 3',
        lastModified: t3,
      );

      final list = [doc1, doc3, doc2];
      sortDoctors(list);

      expect(list.map((d) => d.id).toList(), ['3', '2', '1']);
    });

    test('places newly added doctor at index 0 (top)', () {
      final tOld = DateTime(2026, 9, 1, 10, 0);
      final tNew = DateTime(2026, 9, 5, 15, 0);

      final existing1 = DoctorModel(
        id: '1',
        nameEn: 'Existing A',
        specialtyEn: 'Dentist',
        lastModified: tOld,
      );
      final existing2 = DoctorModel(
        id: '2',
        nameEn: 'Existing B',
        specialtyEn: 'Pediatrician',
        lastModified: tOld.add(const Duration(hours: 1)),
      );
      final newlyAdded = DoctorModel(
        id: '3',
        nameEn: 'New Doctor',
        specialtyEn: 'Cardiologist',
        lastModified: tNew,
      );

      final list = [existing1, existing2, newlyAdded];
      sortDoctors(list);

      expect(list.first.id, '3');
      expect(list.first.name, 'New Doctor');
    });

    test('updates position to top when existing doctor is modified', () {
      final t2 = DateTime(2026, 9, 2);
      final tModified = DateTime(2026, 9, 5);

      final doc1 = DoctorModel(
        id: '1',
        nameEn: 'Doctor 1',
        specialtyEn: 'Spec',
        lastModified: tModified,
      );
      final doc2 = DoctorModel(
        id: '2',
        nameEn: 'Doctor 2',
        specialtyEn: 'Spec',
        lastModified: t2,
      );

      final list = [doc2, doc1];
      sortDoctors(list);

      expect(list.map((d) => d.id).toList(), ['1', '2']);
    });

    test('maintains correct order when a doctor is deleted', () {
      final t1 = DateTime(2026, 9, 1);
      final t2 = DateTime(2026, 9, 2);
      final t3 = DateTime(2026, 9, 3);

      final doc1 = DoctorModel(
        id: '1',
        nameEn: 'Doctor 1',
        specialtyEn: 'Spec',
        lastModified: t1,
      );
      final doc2 = DoctorModel(
        id: '2',
        nameEn: 'Doctor 2',
        specialtyEn: 'Spec',
        lastModified: t2,
      );
      final doc3 = DoctorModel(
        id: '3',
        nameEn: 'Doctor 3',
        specialtyEn: 'Spec',
        lastModified: t3,
      );

      final list = [doc1, doc2, doc3];
      sortDoctors(list);
      expect(list.map((d) => d.id).toList(), ['3', '2', '1']);

      list.removeWhere((d) => d.id == '2');
      sortDoctors(list);

      expect(list.map((d) => d.id).toList(), ['3', '1']);
    });
  });
}
