import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/apps/features/admin/data/models/admin_doctor_model.dart';

class AdminDoctorService {
  AdminDoctorService({FirebaseFirestore? firestore})
    : _customFirestore = firestore;

  final FirebaseFirestore? _customFirestore;
  FirebaseFirestore get _firestore =>
      _customFirestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _doctors =>
      _firestore.collection('doctors');

  Stream<List<AdminDoctorModel>> streamDoctors() {
    return _doctors.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => AdminDoctorModel.fromFirestore(doc.id, doc.data()))
          .toList(),
    );
  }

  Future<void> createDoctor({
    required String name,
    required String specialty,
    required String specialtyKey,
    String? imageUrl,
  }) {
    return _doctors.add({
      'name': name.trim(),
      'specialty': specialty,
      'specialtyKey': specialtyKey,
      'imageUrl': imageUrl,
      'isActive': true,
      'homeVisible': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateDoctor({
    required String id,
    required String name,
    required String specialty,
    required String specialtyKey,
    String? imageUrl,
  }) {
    return _doctors.doc(id).update({
      'name': name.trim(),
      'specialty': specialty,
      'specialtyKey': specialtyKey,
      'imageUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteDoctor(String id) {
    return _doctors.doc(id).delete();
  }
}
