import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/apps/core/services/firestore_collections.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';

class SpecialtyService {
  SpecialtyService({required this.firestore});

  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> get _specialties =>
      firestore.collection(FirestoreCollections.specialty);

  Future<List<SpecialtyModel>> fetchActiveSpecialties() async {
    final snapshot = await _specialties
        .where('isActive', isEqualTo: true)
        .get();
    return snapshot.docs.map(_fromDocument).toList()..sort((a, b) {
      final order = a.sortOrder.compareTo(b.sortOrder);
      return order != 0 ? order : a.localizedName.compareTo(b.localizedName);
    });
  }

  Future<Map<String, SpecialtyModel>> fetchSpecialtiesById() async {
    final snapshot = await _specialties.get();
    return {for (final doc in snapshot.docs) doc.id: _fromDocument(doc)};
  }

  Future<String?> fetchSpecialtyName(String? specialtyId) async {
    if (specialtyId == null || specialtyId.isEmpty) return null;
    final doc = await _specialties.doc(specialtyId).get();
    return doc.exists ? _fromDocument(doc).localizedName : null;
  }

  SpecialtyModel _fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const {};
    final name = data['name'] as Map? ?? const {};
    return SpecialtyModel(
      id: doc.id,
      nameAr: name['ar'] as String? ?? '',
      nameEn: name['en'] as String? ?? '',
      iconKey: data['iconKey'] as String? ?? 'medical_services',
      isActive: data['isActive'] as bool? ?? true,
      sortOrder: (data['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }
}
