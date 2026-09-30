import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class AdminDoctorModel {
  const AdminDoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    this.nameAr,
    this.nameEn,
    this.specialtyId,
    this.imageUrl,
    this.consultationFee = 0,
    this.isActive = true,
    this.rating = 0,
    this.reviewsCount = 0,
    this.availability,
    this.lastModified,
  });

  final String id;
  final String name;
  final String? nameAr;
  final String? nameEn;
  final String specialty;
  final String? specialtyId;
  final String? imageUrl;
  final double consultationFee;
  final bool isActive;
  final double rating;
  final int reviewsCount;
  final DoctorAvailability? availability;
  final DateTime? lastModified;

  AdminDoctorModel copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? nameEn,
    String? specialty,
    String? specialtyId,
    String? imageUrl,
    double? consultationFee,
    bool? isActive,
    double? rating,
    int? reviewsCount,
    DoctorAvailability? availability,
    DateTime? lastModified,
  }) {
    return AdminDoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      specialty: specialty ?? this.specialty,
      specialtyId: specialtyId ?? this.specialtyId,
      imageUrl: imageUrl ?? this.imageUrl,
      consultationFee: consultationFee ?? this.consultationFee,
      isActive: isActive ?? this.isActive,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      availability: availability ?? this.availability,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  factory AdminDoctorModel.fromFirestore(
    String id,
    Map<String, dynamic> data, {
    String? specialtyNameAr,
    String? specialtyNameEn,
  }) {
    final names = _localizedMap(data['fullName']);
    final nameEn = _firstText([names['en'], data['fullNameEn'], data['name']]);
    final nameAr = _firstText([names['ar'], data['fullNameAr'], data['name']]);
    final storedSpecialty = _localizedMap(data['specialty']);
    final specialtyEn =
        specialtyNameEn ??
        _firstText([
          storedSpecialty['en'],
          data['specialtyEn'],
          data['specialty'],
          data['specialtyKey'],
        ]);
    final specialtyAr =
        specialtyNameAr ??
        _firstText([storedSpecialty['ar'], data['specialtyAr'], specialtyEn]);
    final rawTimestamp = data['updatedAt'] ?? data['createdAt'];
    final lastModified = rawTimestamp is Timestamp
        ? rawTimestamp.toDate()
        : null;

    return AdminDoctorModel(
      id: id,
      name: LocaleSettings.currentLocale == AppLocale.ar ? nameAr : nameEn,
      nameAr: nameAr,
      nameEn: nameEn,
      specialty: LocaleSettings.currentLocale == AppLocale.ar
          ? specialtyAr
          : specialtyEn,
      specialtyId:
          (data['specialtyId'] as String?)?.trim() ??
          (data['specialtyKey'] as String?)?.trim(),
      imageUrl: (data['imageUrl'] as String?)?.trim(),
      consultationFee: (data['consultationFee'] as num?)?.toDouble() ?? 0,
      isActive: data['isActive'] as bool? ?? true,
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      reviewsCount: (data['reviewsCount'] as num?)?.toInt() ?? 0,
      availability: DoctorAvailability.tryParse(data['availability']),
      lastModified: lastModified,
    );
  }

  DoctorModel toDoctorModel() {
    return DoctorModel(
      id: id,
      name: name,
      specialty: specialty,
      nameAr: nameAr,
      nameEn: nameEn,
      specialtyId: specialtyId,
      imageUrl: imageUrl,
      consultationFee: consultationFee,
      rating: rating,
      reviewsCount: reviewsCount,
      isActive: isActive,
      availability: availability,
    );
  }
}

Map<String, dynamic> _localizedMap(dynamic value) {
  if (value is Map) return Map<String, dynamic>.from(value);
  return const <String, dynamic>{};
}

String _firstText(List<dynamic> values) {
  for (final value in values) {
    if (value is String && value.trim().isNotEmpty) return value.trim();
  }
  return '';
}
