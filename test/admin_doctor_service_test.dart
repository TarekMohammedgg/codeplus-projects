import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/apps/features/admin/data/models/admin_doctor_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdminDoctorModel', () {
    test('parses timestamps and computes lastModified correctly', () {
      final created = DateTime(2026, 9, 1, 10, 0);
      final updated = DateTime(2026, 9, 5, 12, 30);

      final modelWithBoth = AdminDoctorModel.fromFirestore('doc1', {
        'name': 'Dr. Alice',
        'specialty': 'Dentist',
        'createdAt': Timestamp.fromDate(created),
        'updatedAt': Timestamp.fromDate(updated),
      });

      expect(modelWithBoth.lastModified, updated);

      final modelCreatedOnly = AdminDoctorModel.fromFirestore('doc2', {
        'name': 'Dr. Bob',
        'specialty': 'Cardiologist',
        'createdAt': Timestamp.fromDate(created),
      });

      expect(modelCreatedOnly.lastModified, created);

      final modelNoTimestamp = AdminDoctorModel.fromFirestore('doc3', {
        'name': 'Dr. Charlie',
        'specialty': 'Pediatrician',
      });

      expect(modelNoTimestamp.lastModified, isNull);
    });
  });

  group('Admin doctor list sorting', () {
    void sortDoctors(List<AdminDoctorModel> list) {
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

      final doc1 = AdminDoctorModel(
        id: '1',
        name: 'Doctor 1',
        specialty: 'Spec 1',
        lastModified: t1,
      );
      final doc2 = AdminDoctorModel(
        id: '2',
        name: 'Doctor 2',
        specialty: 'Spec 2',
        lastModified: t2,
      );
      final doc3 = AdminDoctorModel(
        id: '3',
        name: 'Doctor 3',
        specialty: 'Spec 3',
        lastModified: t3,
      );

      final list = [doc1, doc3, doc2];
      sortDoctors(list);

      expect(list.map((d) => d.id).toList(), ['3', '2', '1']);
    });

    test('places newly added doctor at index 0 (top)', () {
      final tOld = DateTime(2026, 9, 1, 10, 0);
      final tNew = DateTime(2026, 9, 5, 15, 0);

      final existing1 = AdminDoctorModel(
        id: '1',
        name: 'Existing A',
        specialty: 'Dentist',
        lastModified: tOld,
      );
      final existing2 = AdminDoctorModel(
        id: '2',
        name: 'Existing B',
        specialty: 'Pediatrician',
        lastModified: tOld.add(const Duration(hours: 1)),
      );
      final newlyAdded = AdminDoctorModel(
        id: '3',
        name: 'New Doctor',
        specialty: 'Cardiologist',
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

      final doc1 = AdminDoctorModel(
        id: '1',
        name: 'Doctor 1',
        specialty: 'Spec',
        lastModified: tModified, // updated recently
      );
      final doc2 = AdminDoctorModel(
        id: '2',
        name: 'Doctor 2',
        specialty: 'Spec',
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

      final doc1 = AdminDoctorModel(
        id: '1',
        name: 'Doctor 1',
        specialty: 'Spec',
        lastModified: t1,
      );
      final doc2 = AdminDoctorModel(
        id: '2',
        name: 'Doctor 2',
        specialty: 'Spec',
        lastModified: t2,
      );
      final doc3 = AdminDoctorModel(
        id: '3',
        name: 'Doctor 3',
        specialty: 'Spec',
        lastModified: t3,
      );

      final list = [doc1, doc2, doc3];
      sortDoctors(list);
      expect(list.map((d) => d.id).toList(), ['3', '2', '1']);

      // Simulate deleting doc2
      list.removeWhere((d) => d.id == '2');
      sortDoctors(list);

      expect(list.map((d) => d.id).toList(), ['3', '1']);
    });
  });
}
