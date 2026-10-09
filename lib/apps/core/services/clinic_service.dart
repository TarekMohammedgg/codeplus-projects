import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

import 'package:doctor_hunt/apps/core/models/clinic_model.dart';

class ClinicService {
  ClinicService({required FirebaseFirestore firestore})
    // ignore: prefer_initializing_formals
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> get _settings =>
      _firestore.collection('clinic').doc('settings');

  Stream<ClinicModel?> streamClinic() =>
      _settings.snapshots().map((snapshot) => _parse(snapshot.data()));

  Future<ClinicModel?> fetchClinic() async =>
      _parse((await _settings.get()).data());

  Future<void> updateClinic({
    required String addressAr,
    required String addressEn,
    required LatLng location,
  }) {
    return _settings.set({
      'address': {'ar': addressAr, 'en': addressEn},
      'location': GeoPoint(location.latitude, location.longitude),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  ClinicModel? _parse(Map<String, dynamic>? data) {
    if (data == null) return null;
    final address = data['address'] is Map
        ? Map<String, dynamic>.from(data['address'] as Map)
        : const <String, dynamic>{};
    final point = data['location'];
    return ClinicModel(
      addressAr: address['ar'] as String? ?? '',
      addressEn: address['en'] as String? ?? '',
      location: point is GeoPoint
          ? LatLng(point.latitude, point.longitude)
          : null,
    );
  }
}
