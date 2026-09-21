import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class DoctorModel {
  static const defaultLocation = LatLng(-1.286389, 36.817223);

  static DoctorModel placeholder() {
    return DoctorModel(
      id: 'placeholder',
      name: tr.placeholderDoctorName,
      nameAr: AppLocale.ar.translations.placeholderDoctorName,
      nameEn: AppLocale.en.translations.placeholderDoctorName,
      specialty: tr.medicineSpecialist,
      specialtyAr: AppLocale.ar.translations.medicineSpecialist,
      specialtyEn: AppLocale.en.translations.medicineSpecialist,
      services: [tr.serviceOne, tr.serviceTwo, tr.serviceThree],
      location: defaultLocation,
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
    this.rating = 4.5,
    this.ratingPercent = 85,
    this.reviewsCount = 100,
    this.patientStoriesCount = 50,
    this.experienceYears = 5,
    this.hourlyRate = 28.0,
    this.nextAvailableTime = '',
    this.services = const [],
    this.location,
    this.runningCount = 100,
    this.ongoingCount = 500,
    this.patientCount = 700,
    this.isFavorite = false,
    this.isActive = true,
    this.isLive = false,
    this.isPopular = false,
    this.isFeatured = false,
    this.liveOrder = 9999,
    this.popularOrder = 9999,
    this.featuredOrder = 9999,
    this.bioAr = '',
    this.bioEn = '',
    this.qualifications = const [],
    this.languages = const [],
    this.consultationFee = 0,
    this.clinicNameAr = '',
    this.clinicNameEn = '',
    this.clinicAddressAr = '',
    this.clinicAddressEn = '',
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
  final double rating;
  final int ratingPercent;
  final int reviewsCount;
  final int patientStoriesCount;
  final int experienceYears;
  final double hourlyRate;
  final String nextAvailableTime;
  final List<String> services;
  final LatLng? location;
  final int runningCount;
  final int ongoingCount;
  final int patientCount;
  final bool isFavorite;
  final bool isActive;
  final bool isLive;
  final bool isPopular;
  final bool isFeatured;
  final int liveOrder;
  final int popularOrder;
  final int featuredOrder;
  final String bioAr;
  final String bioEn;
  final List<String> qualifications;
  final List<String> languages;
  final double consultationFee;
  final String clinicNameAr;
  final String clinicNameEn;
  final String clinicAddressAr;
  final String clinicAddressEn;

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

    final clinic = data['clinic'] is Map
        ? Map<String, dynamic>.from(data['clinic'] as Map)
        : const <String, dynamic>{};
    final clinicName = _localizedMap(clinic['name']);
    final clinicAddress = _localizedMap(clinic['address']);

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
      rating: (data['rating'] as num?)?.toDouble() ?? 4.5,
      ratingPercent: (data['ratingPercent'] as num?)?.toInt() ?? 85,
      reviewsCount: (data['reviewsCount'] as num?)?.toInt() ?? 0,
      patientStoriesCount: (data['patientStoriesCount'] as num?)?.toInt() ?? 0,
      experienceYears: (data['experienceYears'] as num?)?.toInt() ?? 5,
      hourlyRate:
          (data['hourlyRate'] as num?)?.toDouble() ??
          (data['consultationFee'] as num?)?.toDouble() ??
          0,
      nextAvailableTime: data['nextAvailableAt'] as String? ?? '',
      services: _parseServices(data),
      location: _parseLocation(clinic['location'] ?? data['location']),
      runningCount: (data['runningCount'] as num?)?.toInt() ?? 0,
      ongoingCount: (data['ongoingCount'] as num?)?.toInt() ?? 0,
      patientCount: (data['patientCount'] as num?)?.toInt() ?? 0,
      isFavorite: data['isFavorite'] as bool? ?? false,
      isActive: data['isActive'] as bool? ?? true,
      isLive: data['isLive'] as bool? ?? false,
      isPopular: data['isPopular'] as bool? ?? false,
      isFeatured: data['isFeatured'] as bool? ?? false,
      liveOrder: (data['liveOrder'] as num?)?.toInt() ?? 9999,
      popularOrder: (data['popularOrder'] as num?)?.toInt() ?? 9999,
      featuredOrder: (data['featuredOrder'] as num?)?.toInt() ?? 9999,
      bioAr:
          _localizedMap(data['bio'])['ar']?.toString() ??
          (data['bioAr'] as String? ?? ''),
      bioEn:
          _localizedMap(data['bio'])['en']?.toString() ??
          (data['bioEn'] as String? ?? ''),
      qualifications: _parseStringList(data['qualifications']),
      languages: _parseStringList(data['languages']),
      consultationFee: (data['consultationFee'] as num?)?.toDouble() ?? 0,
      clinicNameAr: clinicName['ar']?.toString() ?? '',
      clinicNameEn: clinicName['en']?.toString() ?? '',
      clinicAddressAr: clinicAddress['ar']?.toString() ?? '',
      clinicAddressEn: clinicAddress['en']?.toString() ?? '',
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
    double? rating,
    int? ratingPercent,
    int? reviewsCount,
    int? patientStoriesCount,
    int? experienceYears,
    double? hourlyRate,
    String? nextAvailableTime,
    List<String>? services,
    LatLng? location,
    int? runningCount,
    int? ongoingCount,
    int? patientCount,
    bool? isFavorite,
    bool? isActive,
    bool? isLive,
    bool? isPopular,
    bool? isFeatured,
    int? liveOrder,
    int? popularOrder,
    int? featuredOrder,
    String? bioAr,
    String? bioEn,
    List<String>? qualifications,
    List<String>? languages,
    double? consultationFee,
    String? clinicNameAr,
    String? clinicNameEn,
    String? clinicAddressAr,
    String? clinicAddressEn,
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
      rating: rating ?? this.rating,
      ratingPercent: ratingPercent ?? this.ratingPercent,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      patientStoriesCount: patientStoriesCount ?? this.patientStoriesCount,
      experienceYears: experienceYears ?? this.experienceYears,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      nextAvailableTime: nextAvailableTime ?? this.nextAvailableTime,
      services: services ?? this.services,
      location: location ?? this.location,
      runningCount: runningCount ?? this.runningCount,
      ongoingCount: ongoingCount ?? this.ongoingCount,
      patientCount: patientCount ?? this.patientCount,
      isFavorite: isFavorite ?? this.isFavorite,
      isActive: isActive ?? this.isActive,
      isLive: isLive ?? this.isLive,
      isPopular: isPopular ?? this.isPopular,
      isFeatured: isFeatured ?? this.isFeatured,
      liveOrder: liveOrder ?? this.liveOrder,
      popularOrder: popularOrder ?? this.popularOrder,
      featuredOrder: featuredOrder ?? this.featuredOrder,
      bioAr: bioAr ?? this.bioAr,
      bioEn: bioEn ?? this.bioEn,
      qualifications: qualifications ?? this.qualifications,
      languages: languages ?? this.languages,
      consultationFee: consultationFee ?? this.consultationFee,
      clinicNameAr: clinicNameAr ?? this.clinicNameAr,
      clinicNameEn: clinicNameEn ?? this.clinicNameEn,
      clinicAddressAr: clinicAddressAr ?? this.clinicAddressAr,
      clinicAddressEn: clinicAddressEn ?? this.clinicAddressEn,
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

//CR We can use enums !
// solved
List<String> _parseServices(Map<String, dynamic> data) {
  final raw = data['services'] is Map
      ? _localizedMap(
          data['services'],
        )[LocaleSettings.currentLocale == AppLocale.ar ? 'ar' : 'en']
      : data['services'] ?? data['serviceKeys'];
  return _parseStringList(raw);
}

List<String> _parseStringList(dynamic raw) {
  return raw is List ? raw.whereType<String>().toList() : const [];
}

LatLng? _parseLocation(dynamic locationData) {
  if (locationData is GeoPoint) {
    return LatLng(locationData.latitude, locationData.longitude);
  }
  if (locationData is! Map) return null;
  final lat = (locationData['latitude'] as num?)?.toDouble();
  final lng = (locationData['longitude'] as num?)?.toDouble();
  return (lat != null && lng != null) ? LatLng(lat, lng) : null;
}

String? _accentColorHex(dynamic value) {
  if (value is! String) return null;
  final trimmed = value.trim();
  final hex = trimmed.startsWith('#') ? trimmed.substring(1) : trimmed;
  if (hex.length != 6 && hex.length != 8) return null;
  if (!RegExp(r'^[0-9a-fA-F]+$').hasMatch(hex)) return null;
  return '#${hex.toUpperCase()}';
}
