import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';

Future<List<DoctorModel>> fetchHomeDoctors() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('doctors')
      .where('homeVisible', isEqualTo: true)
      .get();

  return snapshot.docs
      .map((doc) => DoctorModel.fromFirestore(doc.id, doc.data()))
      .where((doctor) => doctor.isActive)
      .toList();
}
