import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';

class DoctorService {
  DoctorService({FirebaseFirestore? firestore}) : _customFirestore = firestore;

  final FirebaseFirestore? _customFirestore;

  FirebaseFirestore? get _firestore {
    if (_customFirestore != null) return _customFirestore;
    try {
      return FirebaseFirestore.instance;
    } catch (_) {
      return null;
    }
  }

  CollectionReference<Map<String, dynamic>>? get _doctors {
    try {
      return _firestore?.collection('doctors');
    } catch (_) {
      return null;
    }
  }

  Future<List<DoctorModel>> fetchDoctors() async {
    final collection = _doctors;
    if (collection == null) return const [];

    try {
      final snapshot = await collection
          .where('isActive', isEqualTo: true)
          .get();
      return _parseDoctors(snapshot);
    } catch (_) {
      return const [];
    }
  }

  Future<List<DoctorModel>> fetchFavouriteDoctors() async {
    final collection = _doctors;
    if (collection == null) return const [];

    try {
      final snapshot = await collection
          .where('isActive', isEqualTo: true)
          .where('isFavorite', isEqualTo: true)
          .get();
      return _parseDoctors(snapshot);
    } catch (_) {
      return const [];
    }
  }

  Future<List<DoctorModel>> fetchFeaturedDoctors() async {
    final collection = _doctors;
    if (collection == null) return const [];

    try {
      final snapshot = await collection
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
    final firestore = _firestore;
    if (firestore == null) return const {};

    try {
      final snapshot = await firestore.collection('specialty').get();
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
