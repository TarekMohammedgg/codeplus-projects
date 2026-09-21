import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';

class SpecialtyService {
  SpecialtyService({
    required FirebaseFirestore firestore,
    // ignore: prefer_initializing_formals
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _specialties =>
      _firestore.collection('specialty');

  Future<List<SpecialtyModel>> fetchActiveSpecialties() async {
    final snapshot = await _specialties
        .where('isActive', isEqualTo: true)
        .get();
    final specialties = snapshot.docs.map((doc) => _fromDocument(doc)).toList();
    specialties.sort((a, b) {
      final order = a.sortOrder.compareTo(b.sortOrder);
      return order != 0 ? order : a.localizedName.compareTo(b.localizedName);
    });
    return specialties;
  }

  Stream<List<SpecialtyModel>> streamActiveSpecialties() {
    return _specialties.where('isActive', isEqualTo: true).snapshots().map((
      snapshot,
    ) {
      final specialties = snapshot.docs
          .map((doc) => _fromDocument(doc))
          .toList();
      specialties.sort((a, b) {
        final order = a.sortOrder.compareTo(b.sortOrder);
        return order != 0 ? order : a.localizedName.compareTo(b.localizedName);
      });
      return specialties;
    });
  }

  static SpecialtyModel _fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    final names = data['name'];
    final nameMap = names is Map
        ? Map<String, dynamic>.from(names)
        : const <String, dynamic>{};

    return SpecialtyModel(
      id: doc.id,
      nameAr: _readText(nameMap['ar'] ?? data['nameAr'], doc.id),
      nameEn: _readText(nameMap['en'] ?? data['nameEn'], doc.id),
      iconKey: (data['iconKey'] as String?)?.trim() ?? 'medical_services',
      isActive: data['isActive'] as bool? ?? true,
      sortOrder: (data['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }

  static String _readText(dynamic value, String id) {
    if (value is String && value.trim().isNotEmpty) return value.trim();
    throw FormatException('Specialty $id has an invalid localized name');
  }

  /// Localized (ar, en) specialty names keyed by specialty id, used to
  /// resolve a doctor's `specialtyId` into display text.
  Future<Map<String, (String, String)>> fetchSpecialtyNames() async {
    final snapshot = await _specialties.get();
    return {
      for (final doc in snapshot.docs)
        doc.id: (
          _localizedText(doc.data()['name'], 'ar') ??
              (doc.data()['nameAr'] as String? ?? ''),
          _localizedText(doc.data()['name'], 'en') ??
              (doc.data()['nameEn'] as String? ?? ''),
        ),
    };
  }

  static String? _localizedText(dynamic value, String language) {
    if (value is Map) return value[language] as String?;
    return null;
  }
}
