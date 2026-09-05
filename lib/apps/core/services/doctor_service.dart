import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';

class DoctorService {
  DoctorService({FirebaseFirestore? firestore})
    : _customFirestore = firestore;

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

  Future<List<DoctorModel>> fetchHomeDoctors() async {
    final collection = _doctors;
    if (collection == null) return const [];

    try {
      final snapshot = await collection
          .where('homeVisible', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((doc) => DoctorModel.fromFirestore(doc.id, doc.data()))
          .where((doctor) => doctor.isActive)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<DoctorModel>> fetchDoctors() async {
    final collection = _doctors;
    if (collection == null) return const [];

    try {
      final snapshot = await collection.get();
      return snapshot.docs
          .map((doc) => DoctorModel.fromFirestore(doc.id, doc.data()))
          .where((doctor) => doctor.isActive)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<DoctorModel>> fetchFavouriteDoctors() async {
    final collection = _doctors;
    if (collection == null) return const [];

    try {
      final snapshot = await collection
          .where('isFavorite', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((doc) => DoctorModel.fromFirestore(doc.id, doc.data()))
          .where((doctor) => doctor.isActive)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<DoctorModel>> fetchFeaturedDoctors() async {
    final collection = _doctors;
    if (collection == null) return const [];

    try {
      final snapshot = await collection
          .where('isFeatured', isEqualTo: true)
          .get();
      final list = snapshot.docs
          .map((doc) => DoctorModel.fromFirestore(doc.id, doc.data()))
          .where((doctor) => doctor.isActive)
          .toList();
      list.sort((a, b) => a.featuredOrder.compareTo(b.featuredOrder));
      return list;
    } catch (_) {
      return const [];
    }
  }
}
