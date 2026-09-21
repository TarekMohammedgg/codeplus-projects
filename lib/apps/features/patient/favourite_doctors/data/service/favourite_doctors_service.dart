import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';

class FavouriteDoctorsService {
  FavouriteDoctorsService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _doctors =>
      _firestore.collection('doctors');

  Future<List<DoctorModel>> fetchFavouriteDoctors() async {
    try {
      final snapshot = await _doctors
          .where('isActive', isEqualTo: true)
          .where('isFavorite', isEqualTo: true)
          .get();
      return _parseDoctors(snapshot);
    } catch (_) {
      return const [];
    }
  }

  Future<List<DoctorModel>> fetchFeaturedDoctors() async {
    try {
      final snapshot = await _doctors
          .where('isActive', isEqualTo: true)
          .where('isFeatured', isEqualTo: true)
          .get();
      final list = await _parseDoctors(snapshot);
      list.sort((a, b) => a.featuredOrder.compareTo(b.featuredOrder));
      return list;
    } catch (_) {
      return const [];
    }
  }

  Future<List<DoctorModel>> _parseDoctors(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) async {
    final specialtyNames = await _fetchSpecialtyNames();
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

  Future<Map<String, (String, String)>> _fetchSpecialtyNames() async {
    try {
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
    } catch (_) {
      return const {};
    }
  }

  static String? _localizedText(dynamic value, String language) {
    if (value is Map) return value[language] as String?;
    return null;
  }
}
