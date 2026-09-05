import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDoctorModel {
  const AdminDoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    this.specialtyKey,
    this.imageUrl,
    this.isActive = true,
    this.lastModified,
  });

  final String id;
  final String name;
  final String specialty;
  final String? specialtyKey;
  final String? imageUrl;
  final bool isActive;
  final DateTime? lastModified;

  factory AdminDoctorModel.fromFirestore(String id, Map<String, dynamic> data) {
    final rawTimestamp = data['updatedAt'] ?? data['createdAt'];
    final lastModified = rawTimestamp is Timestamp
        ? rawTimestamp.toDate()
        : null;

    return AdminDoctorModel(
      id: id,
      name: (data['name'] as String?)?.trim() ?? '',
      specialty: _specialty(data),
      specialtyKey: (data['specialtyKey'] as String?)?.trim(),
      imageUrl: (data['imageUrl'] as String?)?.trim(),
      isActive: data['isActive'] as bool? ?? true,
      lastModified: lastModified,
    );
  }
}

String _specialty(Map<String, dynamic> data) {
  final display = (data['specialty'] as String?)?.trim();
  if (display != null && display.isNotEmpty) return display;

  final key = (data['specialtyKey'] as String?)?.trim();
  if (key == null || key.isEmpty) return '';

  return key
      .split('_')
      .where((word) => word.isNotEmpty)
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}
