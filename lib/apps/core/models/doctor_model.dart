import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class DoctorModel {
  static DoctorModel placeholder() {
    return DoctorModel(
      id: 'placeholder',
      name: tr.placeholderDoctorName,
      nameAr: AppLocale.ar.translations.placeholderDoctorName,
      nameEn: AppLocale.en.translations.placeholderDoctorName,
      specialty: tr.medicineSpecialist,
      specialtyAr: AppLocale.ar.translations.medicineSpecialist,
      specialtyEn: AppLocale.en.translations.medicineSpecialist,
    );
  }

  const DoctorModel({
    required this.id,
    required String name,
    required String specialty,
    this.nameAr,
    this.nameEn,
    this.specialtyAr,
    this.specialtyEn,
    this.specialtyId,
    this.imageUrl,
    this.accentColorHex,
    this.consultationFee = 0,
    this.rating = 0,
    this.reviewsCount = 0,
    this.isActive = true,
    this.availability,
    // ignore: prefer_initializing_formals
  }) : _name = name,
       // ignore: prefer_initializing_formals
       _specialty = specialty;

  final String id;
  final String _name;
  String get name {
    if (LocaleSettings.currentLocale == AppLocale.ar &&
        (nameAr?.isNotEmpty ?? false)) {
      return nameAr!;
    }
    if (LocaleSettings.currentLocale == AppLocale.en &&
        (nameEn?.isNotEmpty ?? false)) {
      return nameEn!;
    }
    return _name;
  }

  final String? nameAr;
  final String? nameEn;
  final String? specialtyAr;
  final String? specialtyEn;
  final String _specialty;

  String get specialty {
    if (LocaleSettings.currentLocale == AppLocale.ar &&
        (specialtyAr?.isNotEmpty ?? false)) {
      return specialtyAr!;
    }
    if (LocaleSettings.currentLocale == AppLocale.en &&
        (specialtyEn?.isNotEmpty ?? false)) {
      return specialtyEn!;
    }
    return _specialty;
  }

  final String? specialtyId;
  final String? imageUrl;
  final String? accentColorHex;
  final double consultationFee;
  final double rating;
  final int reviewsCount;
  final bool isActive;

  /// Null until the admin sets working days and hours for this doctor.
  final DoctorAvailability? availability;

  factory DoctorModel.fromFirestore(
    String id,
    Map<String, dynamic> data, {
    String? specialtyNameAr,
    String? specialtyNameEn,
  }) {
    final names = _localizedMap(data['fullName']);
    final nameEn = _firstText(
      [names['en'], data['fullNameEn'], data['name']],
      id,
      'fullName.en',
    );
    final nameAr = _firstText(
      [names['ar'], data['fullNameAr'], data['name']],
      id,
      'fullName.ar',
    );

    final storedSpecialty = _localizedMap(data['specialty']);
    final rawSpecialtyAr =
        (storedSpecialty['ar'] ?? data['specialtyAr']) as String?;
    final rawSpecialtyEn =
        (storedSpecialty['en'] ?? data['specialtyEn']) as String?;
    final legacyRawSpecialty =
        [
              rawSpecialtyEn,
              rawSpecialtyAr,
              data['specialty'],
              data['specialtyKey'],
            ].firstWhere(
              (value) => value is String && value.trim().isNotEmpty,
              orElse: () => null,
            )
            as String?;

    final resolvedAr = _firstText(
      [
        specialtyNameAr,
        rawSpecialtyAr,
        specialtyNameEn,
        rawSpecialtyEn,
        legacyRawSpecialty,
      ],
      id,
      'specialty',
    );
    final resolvedEn = _firstText(
      [
        specialtyNameEn,
        rawSpecialtyEn,
        specialtyNameAr,
        rawSpecialtyAr,
        legacyRawSpecialty,
      ],
      id,
      'specialty',
    );

    final localizedName = LocaleSettings.currentLocale == AppLocale.ar
        ? nameAr
        : nameEn;
    final localizedSpecialty = LocaleSettings.currentLocale == AppLocale.ar
        ? resolvedAr
        : resolvedEn;

    return DoctorModel(
      id: id,
      name: localizedName,
      nameAr: nameAr,
      nameEn: nameEn,
      specialty: localizedSpecialty,
      specialtyAr: resolvedAr,
      specialtyEn: resolvedEn,
      specialtyId: (data['specialtyId'] as String?)?.trim(),
      imageUrl: (data['imageUrl'] as String?)?.trim(),
      accentColorHex: _accentColorHex(data['accentColorHex']),
      consultationFee: (data['consultationFee'] as num?)?.toDouble() ?? 0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      reviewsCount: (data['reviewsCount'] as num?)?.toInt() ?? 0,
      isActive: data['isActive'] as bool? ?? true,
      availability: DoctorAvailability.tryParse(data['availability']),
    );
  }

  DoctorModel copyWith({
    String? id,
    String? name,
    String? specialty,
    String? nameAr,
    String? nameEn,
    String? specialtyAr,
    String? specialtyEn,
    String? specialtyId,
    String? imageUrl,
    String? accentColorHex,
    double? consultationFee,
    double? rating,
    int? reviewsCount,
    bool? isActive,
    DoctorAvailability? availability,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? _name,
      specialty: specialty ?? _specialty,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      specialtyAr: specialtyAr ?? this.specialtyAr,
      specialtyEn: specialtyEn ?? this.specialtyEn,
      specialtyId: specialtyId ?? this.specialtyId,
      imageUrl: imageUrl ?? this.imageUrl,
      accentColorHex: accentColorHex ?? this.accentColorHex,
      consultationFee: consultationFee ?? this.consultationFee,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      isActive: isActive ?? this.isActive,
      availability: availability ?? this.availability,
    );
  }
}

Map<String, dynamic> _localizedMap(dynamic value) {
  if (value is Map) return Map<String, dynamic>.from(value);
  return const <String, dynamic>{};
}

String _firstText(List<dynamic> values, String id, String field) {
  for (final value in values) {
    if (value is String && value.trim().isNotEmpty) return value.trim();
  }
  throw FormatException('Doctor $id is missing required field: $field');
}

String? _accentColorHex(dynamic value) {
  if (value is! String) return null;
  final trimmed = value.trim();
  final hex = trimmed.startsWith('#') ? trimmed.substring(1) : trimmed;
  if (hex.length != 6 && hex.length != 8) return null;
  if (!RegExp(r'^[0-9a-fA-F]+$').hasMatch(hex)) return null;
  return '#${hex.toUpperCase()}';
}
