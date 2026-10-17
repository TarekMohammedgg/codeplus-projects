import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:doctor_hunt/apps/core/services/firestore_collections.dart';
import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';

class DoctorService {
  // Moved from the removed AdminDoctorService (it only forwarded to this class).
  //CR Bad DI: Avoid mixing static singletons and swallowing Firebase uninitialized errors with catch (_) => null.
  //CR Inject non-nullable `FirebaseFirestore` via constructor.
  // solved
  DoctorService({required this.firestore, required this.specialtyService});

  final FirebaseFirestore firestore;
  final SpecialtyService specialtyService;

  CollectionReference<Map<String, dynamic>> get _doctors =>
      firestore.collection(FirestoreCollections.doctors);

  Future<List<DoctorModel>> fetchActiveDoctors() async {
    final snapshot = await _doctors.where('isActive', isEqualTo: true).get();
    final specialties = await specialtyService.fetchSpecialtiesById();
    return snapshot.docs
        .map((doc) => _parse(doc.id, doc.data(), specialties))
        .toList();
  }

  Stream<List<DoctorModel>> streamAllDoctors() {
    return _doctors.snapshots().asyncMap((snapshot) async {
      final specialties = await specialtyService.fetchSpecialtiesById();
      return snapshot.docs
          .map((doc) => _parse(doc.id, doc.data(), specialties))
          .toList()
        ..sort(
          (a, b) => (b.lastModified ?? DateTime(0)).compareTo(
            a.lastModified ?? DateTime(0),
          ),
        );
    });
  }

  Stream<DoctorModel?> streamDoctor(String id) {
    return _doctors.doc(id).snapshots().asyncMap((doc) async {
      final data = doc.data();
      if (data == null) return null;
      final specialties = await specialtyService.fetchSpecialtiesById();
      return _parse(doc.id, data, specialties);
    });
  }

  Future<void> createDoctor({
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    required double consultationFee,
    String? imageUrl,
  }) {
    return _doctors.add(
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
  }) {
    return _doctors.doc(id).update({
      'fullName': {'ar': fullNameAr.trim(), 'en': fullNameEn.trim()},
      'specialtyId': specialtyId,
      'imageUrl': _cleanUrl(imageUrl),
      'consultationFee': consultationFee,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> setActive(String id, bool isActive) {
    return _doctors.doc(id).update({
      'isActive': isActive,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateAvailability(String id, DoctorAvailability availability) {
    return _doctors.doc(id).update({
      'availability': availability.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  DoctorModel _parse(
    String id,
    Map<String, dynamic> data,
    Map<String, SpecialtyModel> specialties,
  ) {
    return DoctorModel.fromFirestore(
      id,
      data,
      specialty: specialties[data['specialtyId']],
    );
  }
}

String? _cleanUrl(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

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
