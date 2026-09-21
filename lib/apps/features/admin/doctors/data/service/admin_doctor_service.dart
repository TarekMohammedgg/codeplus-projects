import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';
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
    required SpecialtyService specialtyService,
    // ignore: prefer_initializing_formals
  }) : _firestore = firestore,
       // ignore: prefer_initializing_formals
       _specialtyService = specialtyService;

  final FirebaseFirestore _firestore;
  final SpecialtyService _specialtyService;

  //CR Bad DI: Avoid mixing static singletons and swallowing Firebase uninitialized errors with catch (_) => null.
  //CR Inject non-nullable `FirebaseFirestore` via constructor.
  // solved
  CollectionReference<Map<String, dynamic>> get _doctors =>
      _firestore.collection('doctors');

  Stream<List<AdminDoctorModel>> streamDoctors() {
    return _doctors.snapshots().asyncMap((snapshot) async {
      final specialtyNames = await _specialtyService.fetchSpecialtyNames();
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
}
