import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';

/// Single Firestore access point for the patient-facing `doctors`
/// collection, shared by the home, find-doctors and favourite-doctors
/// features to avoid duplicating query/parse logic per feature.
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

  Future<List<DoctorModel>> fetchActiveDoctors() async {
    final snapshot = await _doctors.where('isActive', isEqualTo: true).get();
    return _parseDoctors(snapshot);
  }

  Future<List<DoctorModel>> fetchFavouriteDoctors() async {
    final snapshot = await _doctors
        .where('isActive', isEqualTo: true)
        .where('isFavorite', isEqualTo: true)
        .get();
    return _parseDoctors(snapshot);
  }

  Future<List<DoctorModel>> fetchFeaturedDoctors() async {
    final snapshot = await _doctors
        .where('isActive', isEqualTo: true)
        .where('isFeatured', isEqualTo: true)
        .get();
    final doctors = await _parseDoctors(snapshot);
    doctors.sort((a, b) => a.featuredOrder.compareTo(b.featuredOrder));
    return doctors;
  }

  Future<List<DoctorModel>> _parseDoctors(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) async {
    final specialtyNames = await _specialtyService.fetchSpecialtyNames();
    return snapshot.docs
        .map(
          (doc) => DoctorModel.fromFirestore(
            doc.id,
            doc.data(),
            specialtyNameAr: specialtyNames[doc.data()['specialtyId']]?.$1,
            specialtyNameEn: specialtyNames[doc.data()['specialtyId']]?.$2,
          ),
        )
        .toList();
  }
}
