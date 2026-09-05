import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class DoctorModel {
  static const defaultAccentColor = Color(0xFF0EBE7E);
  static const defaultLocation = LatLng(-1.286389, 36.817223);

  static DoctorModel placeholder() {
    return DoctorModel(
      id: 'placeholder',
      name: 'Dr. Pediatrician',
      specialty: tr.medicineSpecialist,
      services: [tr.serviceOne, tr.serviceTwo, tr.serviceThree],
      location: defaultLocation,
    );
  }

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    this.imageUrl,
    this.accentColor = defaultAccentColor,
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
    this.category,
  });

  final String id;
  final String name;
  final String specialty;
  final String? imageUrl;
  final String? category;
  final Color accentColor;
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

  factory DoctorModel.fromFirestore(String id, Map<String, dynamic> data) {
    return DoctorModel(
      id: id,
      name: _require(data, 'name', id),
      specialty: _localizedSpecialty(_require(data, 'specialtyKey', id)),
      imageUrl: (data['imageUrl'] as String?)?.trim(),
      accentColor: _colorFromHex(data['accentColorHex']),
      rating: (data['rating'] as num?)?.toDouble() ?? 4.5,
      ratingPercent: (data['ratingPercent'] as num?)?.toInt() ?? 85,
      reviewsCount: (data['reviewsCount'] as num?)?.toInt() ?? 100,
      patientStoriesCount: (data['patientStoriesCount'] as num?)?.toInt() ?? 50,
      experienceYears: (data['experienceYears'] as num?)?.toInt() ?? 5,
      hourlyRate: (data['hourlyRate'] as num?)?.toDouble() ?? 28.0,
      nextAvailableTime: data['nextAvailableAt'] as String? ?? '',
      services: _parseServices(data),
      location: _parseLocation(data['location']),
      runningCount: (data['runningCount'] as num?)?.toInt() ?? 100,
      ongoingCount: (data['ongoingCount'] as num?)?.toInt() ?? 500,
      patientCount: (data['patientCount'] as num?)?.toInt() ?? 700,
      isFavorite: data['isFavorite'] as bool? ?? false,
      isActive: data['isActive'] as bool? ?? true,
      isLive: data['isLive'] as bool? ?? false,
      isPopular: data['isPopular'] as bool? ?? false,
      isFeatured: data['isFeatured'] as bool? ?? false,
      liveOrder: (data['liveOrder'] as num?)?.toInt() ?? 9999,
      popularOrder: (data['popularOrder'] as num?)?.toInt() ?? 9999,
      featuredOrder: (data['featuredOrder'] as num?)?.toInt() ?? 9999,
      category: data['category'] as String?,
    );
  }

  DoctorModel copyWith({
    String? id,
    String? name,
    String? specialty,
    String? imageUrl,
    Color? accentColor,
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
    String? category,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      imageUrl: imageUrl ?? this.imageUrl,
      accentColor: accentColor ?? this.accentColor,
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
      category: category ?? this.category,
    );
  }
}

String _require(Map<String, dynamic> data, String field, String id) {
  final value = data[field];
  if (value is String && value.trim().isNotEmpty) return value.trim();
  throw FormatException('Doctor $id is missing required field: $field');
}

List<String> _parseServices(Map<String, dynamic> data) {
  final raw = data['serviceKeys'] ?? data['services'];
  return raw is List ? raw.map((e) => e.toString()).toList() : const [];
}

LatLng? _parseLocation(dynamic locationData) {
  if (locationData is! Map<String, dynamic>) return null;
  final lat = (locationData['latitude'] as num?)?.toDouble();
  final lng = (locationData['longitude'] as num?)?.toDouble();
  return (lat != null && lng != null) ? LatLng(lat, lng) : null;
}

Color _colorFromHex(dynamic hex) {
  if (hex is! String) return DoctorModel.defaultAccentColor;
  final cleaned = hex.replaceFirst('#', '');
  final value = switch (cleaned.length) {
    6 => int.tryParse('FF$cleaned', radix: 16),
    8 => int.tryParse(cleaned, radix: 16),
    _ => null,
  };
  return value != null ? Color(value) : DoctorModel.defaultAccentColor;
}

String _localizedSpecialty(String key) {
  return switch (key) {
    'cardiologist' ||
    'heart_specialist' ||
    'live_cardiologist' => tr.specialtyCardiologist,
    'dentist' || 'dental_specialist' || 'live_dentist' => tr.specialtyDentist,
    'pediatrician' || 'live_pediatrician' => tr.specialtyPediatrician,
    'neurologist' || 'live_neurologist' => tr.specialtyNeurologist,
    'eye_specialist' => tr.specialtyEyeSpecialist,
    'medicine_specialist' => tr.specialtyMedicineSpecialist,
    'general_surgeon' => tr.specialtyGeneralSurgeon,
    'orthopedic' => tr.specialtyOrthopedic,
    'dermatologist' => tr.specialtyDermatologist,
    _ => key.replaceAll('_', ' '),
  };
}
