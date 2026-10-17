import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class DoctorModel {
  const DoctorModel({
    required this.id,
    required this.nameEn,
    this.nameAr = '',
    this.specialtyEn = '',
    this.specialtyAr = '',
    this.specialtyId,
    this.imageUrl,
    this.consultationFee = 0,
    this.rating = 0,
    this.reviewsCount = 0,
    this.isActive = true,
    this.availability,
    this.lastModified,
  });

  final String id;
  final String nameEn;
  final String nameAr;
  final String specialtyEn;
  final String specialtyAr;
  final String? specialtyId;
  final String? imageUrl;
  final double consultationFee;
  final double rating;
  final int reviewsCount;
  final bool isActive;
  final DoctorAvailability? availability;
  final DateTime? lastModified;

  bool get _isArabic => LocaleSettings.currentLocale == AppLocale.ar;

  String get name => _isArabic && nameAr.isNotEmpty ? nameAr : nameEn;

  String get specialty =>
      _isArabic && specialtyAr.isNotEmpty ? specialtyAr : specialtyEn;

  bool nameContains(String query) {
    final text = query.trim().toLowerCase();
    return nameEn.toLowerCase().contains(text) ||
        nameAr.toLowerCase().contains(text);
  }

  factory DoctorModel.fromFirestore(
    String id,
    Map<String, dynamic> data, {
    SpecialtyModel? specialty,
  }) {
    final fullName = data['fullName'] as Map? ?? const {};
    return DoctorModel(
      id: id,
      nameEn: fullName['en'] as String? ?? '',
      nameAr: fullName['ar'] as String? ?? '',
      specialtyEn: specialty?.nameEn ?? '',
      specialtyAr: specialty?.nameAr ?? '',
      specialtyId: data['specialtyId'] as String?,
      imageUrl: data['imageUrl'] as String?,
      consultationFee: (data['consultationFee'] as num?)?.toDouble() ?? 0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      reviewsCount: (data['reviewsCount'] as num?)?.toInt() ?? 0,
      isActive: data['isActive'] as bool? ?? true,
      availability: DoctorAvailability.tryParse(data['availability']),
      lastModified: ((data['updatedAt'] ?? data['createdAt']) as Timestamp?)
          ?.toDate(),
    );
  }
}
