import 'package:flutter/material.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class SpecialtyModel {
  const SpecialtyModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.iconKey = 'medical_services',
    this.isActive = true,
    this.sortOrder = 0,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final String iconKey;
  final bool isActive;
  final int sortOrder;

  String get localizedName =>
      LocaleSettings.currentLocale == AppLocale.ar ? nameAr : nameEn;

  IconData get icon => switch (iconKey) {
    'cardiology' => Icons.favorite_rounded,
    'orthopedic' => Icons.accessibility_new_rounded,
    'dentistry' => Icons.medical_services_rounded,
    'pediatrics' => Icons.child_care_rounded,
    'dermatology' => Icons.face_rounded,
    'neurology' => Icons.psychology_rounded,
    'ophthalmology' => Icons.remove_red_eye_rounded,
    'surgery' => Icons.healing_rounded,
    'internal_medicine' => Icons.medication_rounded,
    _ => Icons.medical_services_outlined,
  };

  @override
  bool operator ==(Object other) => other is SpecialtyModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
