import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/models/admin_doctor_model.dart';

class AdminDoctorService {
  //CR Bad DI: Avoid mixing static singletons and swallowing Firebase uninitialized errors with catch (_) => null.
  //CR Inject non-nullable `FirebaseFirestore` via constructor.
  // solved

  //CR Bad DI: Avoid mixing static singletons and swallowing Firebase uninitialized errors with catch (_) => null.
  //CR Inject non-nullable `FirebaseFirestore` via constructor.
  // solved
  AdminDoctorService({
    required FirebaseFirestore firestore,
    // ignore: prefer_initializing_formals
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  //CR Bad DI: Avoid mixing static singletons and swallowing Firebase uninitialized errors with catch (_) => null.
  //CR Inject non-nullable `FirebaseFirestore` via constructor.
  // solved
  CollectionReference<Map<String, dynamic>> get _doctors =>
      _firestore.collection('doctors');

  Stream<List<AdminDoctorModel>> streamDoctors() {
    return _doctors.snapshots().asyncMap((snapshot) async {
      final specialtyNames = await _fetchSpecialtyNames();
      final doctors = snapshot.docs
          .map(
            (doc) => AdminDoctorModel.fromFirestore(
              doc.id,
              doc.data(),
              specialtyNameAr: specialtyNames[doc.data()['specialtyId']]?.$1,
              specialtyNameEn: specialtyNames[doc.data()['specialtyId']]?.$2,
            ),
          )
          .toList();
      doctors.sort((a, b) {
        final aTime = a.lastModified ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.lastModified ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });
      return doctors;
    });
  }

  Future<void> createDoctor({
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    String? imageUrl,
  }) async {
    final collection = _doctors;
    final id = await _nextDoctorId(collection);
    final reference = collection.doc(id);
    if ((await reference.get()).exists) {
      throw StateError('A doctor with this English name already exists');
    }

    final now = FieldValue.serverTimestamp();
    await reference.set({
      'fullName': {'ar': fullNameAr.trim(), 'en': fullNameEn.trim()},
      'specialtyId': specialtyId,
      'imageUrl': _cleanUrl(imageUrl),
      'bio': {'ar': '', 'en': ''},
      'qualifications': <String>[],
      'languages': <String>['ar'],
      'consultationFee': 0,
      'services': {'ar': <String>[], 'en': <String>[]},
      'clinic': {
        'name': {'ar': '', 'en': ''},
        'address': {'ar': '', 'en': ''},
      },
      'rating': 0,
      'reviewsCount': 0,
      'isActive': true,
      'isLive': false,
      'isPopular': false,
      'isFeatured': false,
      'createdAt': now,
      'updatedAt': now,
    });
  }

  Future<void> updateDoctor({
    required String id,
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    String? imageUrl,
  }) async {
    await _doctors.doc(id).update({
      'fullName': {'ar': fullNameAr.trim(), 'en': fullNameEn.trim()},
      'specialtyId': specialtyId,
      'imageUrl': _cleanUrl(imageUrl),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteDoctor(String id) async {
    await _doctors.doc(id).delete();
  }

  Future<Map<String, (String, String)>> _fetchSpecialtyNames() async {
    final snapshot = await _firestore.collection('specialty').get();
    return {
      for (final doc in snapshot.docs)
        doc.id: (
          _localizedText(doc.data()['name'], 'ar') ??
              (doc.data()['nameAr'] as String? ?? ''),
          _localizedText(doc.data()['name'], 'en') ??
              (doc.data()['nameEn'] as String? ?? ''),
        ),
    };
  }

  static Future<String> _nextDoctorId(
    CollectionReference<Map<String, dynamic>> collection,
  ) async {
    final snapshot = await collection.get();
    var highestNumber = 0;
    final pattern = RegExp(r'^(?:doc|doctor)_(\d+)$', caseSensitive: false);

    for (final document in snapshot.docs) {
      final match = pattern.firstMatch(document.id);
      final number = int.tryParse(match?.group(1) ?? '');
      if (number != null && number > highestNumber) {
        highestNumber = number;
      }
    }

    return 'doc_${highestNumber + 1}';
  }

  static String? _cleanUrl(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  static String? _localizedText(dynamic value, String language) {
    if (value is Map) return value[language] as String?;
    return null;
  }
}
