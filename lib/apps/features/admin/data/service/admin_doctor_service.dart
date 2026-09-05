import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/apps/features/admin/data/models/admin_doctor_model.dart';

class AdminDoctorService {
  static final AdminDoctorService instance = AdminDoctorService();

  final FirebaseFirestore? _firestore;

  AdminDoctorService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? _safeFirestore();

  static FirebaseFirestore? _safeFirestore() {
    try {
      return FirebaseFirestore.instance;
    } catch (_) {
      return null;
    }
  }

  CollectionReference<Map<String, dynamic>>? get _doctors =>
      _firestore?.collection('doctors');

  Stream<List<AdminDoctorModel>> streamDoctors() {
    final collection = _doctors;
    if (collection == null) return const Stream.empty();

    return collection.snapshots().map((snapshot) {
      final doctors = snapshot.docs
          .map((doc) => AdminDoctorModel.fromFirestore(doc.id, doc.data()))
          .toList();
      doctors.sort((a, b) {
        final aTime = a.lastModified ?? DateTime.now();
        final bTime = b.lastModified ?? DateTime.now();
        return bTime.compareTo(aTime);
      });
      return doctors;
    });
  }

  Future<void> createDoctor({
    required String name,
    required String specialty,
    required String specialtyKey,
    String? imageUrl,
  }) async {
    final now = FieldValue.serverTimestamp();
    await _doctors?.add({
      'name': name.trim(),
      'specialty': specialty,
      'specialtyKey': specialtyKey,
      'imageUrl': imageUrl,
      'isActive': true,
      'homeVisible': false,
      'createdAt': now,
      'updatedAt': now,
    });
  }

  Future<void> updateDoctor({
    required String id,
    required String name,
    required String specialty,
    required String specialtyKey,
    String? imageUrl,
  }) async {
    await _doctors?.doc(id).update({
      'name': name.trim(),
      'specialty': specialty,
      'specialtyKey': specialtyKey,
      'imageUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteDoctor(String id) async {
    await _doctors?.doc(id).delete();
  }
}
