import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';

/// Single Firestore access point for the `doctors` collection: every query,
/// write and parse of a doctor lives here (patient reads and admin CRUD).
class DoctorService {
  DoctorService({
    required FirebaseFirestore firestore,
    required SpecialtyService specialtyService,
    // ignore: prefer_initializing_formals
  }) : _firestore = firestore,
       // ignore: prefer_initializing_formals
       _specialtyService = specialtyService;

  final FirebaseFirestore _firestore;
  final SpecialtyService _specialtyService;

  CollectionReference<Map<String, dynamic>> get _doctors =>
      _firestore.collection('doctors');

  /// Patients only ever see active doctors.
  Future<List<DoctorModel>> fetchActiveDoctors() async {
    final snapshot = await _doctors.where('isActive', isEqualTo: true).get();
    final specialtyNames = await _specialtyService.fetchSpecialtyNames();
    return snapshot.docs
        .map((doc) => _parse(doc.id, doc.data(), specialtyNames))
        .toList();
  }

  /// Every doctor (active or not), newest change first, for the admin list.
  Stream<List<DoctorModel>> streamAllDoctors() {
    return _doctors.snapshots().asyncMap((snapshot) async {
      final specialtyNames = await _specialtyService.fetchSpecialtyNames();
      final doctors = snapshot.docs
          .map((doc) => _parse(doc.id, doc.data(), specialtyNames))
          .toList();
      doctors.sort((a, b) {
        final aTime = a.lastModified ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.lastModified ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });
      return doctors;
    });
  }

  Stream<DoctorModel?> streamDoctor(String id) {
    return _doctors.doc(id).snapshots().asyncMap((doc) async {
      final data = doc.data();
      if (!doc.exists || data == null) return null;
      final specialtyNames = await _specialtyService.fetchSpecialtyNames();
      return _parse(doc.id, data, specialtyNames);
    });
  }

  Future<void> createDoctor({
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    required double consultationFee,
    String? imageUrl,
  }) async {
    final id = await _nextDoctorId();
    final reference = _doctors.doc(id);
    if ((await reference.get()).exists) {
      throw StateError('Doctor id $id already exists');
    }

    await reference.set(
      newDoctorData(
        fullNameAr: fullNameAr,
        fullNameEn: fullNameEn,
        specialtyId: specialtyId,
        consultationFee: consultationFee,
        imageUrl: imageUrl,
      ),
    );
  }

  Future<void> updateDoctor({
    required String id,
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    required double consultationFee,
    String? imageUrl,
  }) async {
    await _doctors.doc(id).update({
      'fullName': {'ar': fullNameAr.trim(), 'en': fullNameEn.trim()},
      'specialtyId': specialtyId,
      'imageUrl': _cleanUrl(imageUrl),
      'consultationFee': consultationFee,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Doctors are never deleted (booking history keeps them); patients only
  /// see active ones.
  Future<void> setActive(String id, bool isActive) {
    return _doctors.doc(id).update({
      'isActive': isActive,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateAvailability(
    String id,
    DoctorAvailability availability,
  ) async {
    await _doctors.doc(id).update({
      'availability': availability.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  DoctorModel _parse(
    String id,
    Map<String, dynamic> data,
    Map<String, (String, String)> specialtyNames,
  ) {
    final names = specialtyNames[data['specialtyId']];
    return DoctorModel.fromFirestore(
      id,
      data,
      specialtyNameAr: names?.$1,
      specialtyNameEn: names?.$2,
    );
  }

  Future<String> _nextDoctorId() async {
    final snapshot = await _doctors.get();
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
}

String? _cleanUrl(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

/// The only fields a new doctor document gets (see Locked decisions):
/// no location, no experience, no bio/services/flags.
Map<String, dynamic> newDoctorData({
  required String fullNameAr,
  required String fullNameEn,
  required String specialtyId,
  required double consultationFee,
  String? imageUrl,
}) {
  final now = FieldValue.serverTimestamp();
  return {
    'fullName': {'ar': fullNameAr.trim(), 'en': fullNameEn.trim()},
    'specialtyId': specialtyId,
    'imageUrl': _cleanUrl(imageUrl),
    'consultationFee': consultationFee,
    'rating': 0,
    'reviewsCount': 0,
    'isActive': true,
    'createdAt': now,
    'updatedAt': now,
  };
}
