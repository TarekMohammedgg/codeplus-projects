import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class DoctorModel {
  static const defaultAccentColor = Color(0xFF0EBE7E);

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

  // Core & Identification
  final String id;
  final String name;
  final String specialty;
  final String? imageUrl;
  final String? category;

  // Visual
  final Color accentColor;

  // Ratings & Metrics
  final double rating;
  final int ratingPercent;
  final int reviewsCount;
  final int patientStoriesCount;
  final int experienceYears;
  final double hourlyRate;

  // Availability & Location
  final String nextAvailableTime;
  final List<String> services;
  final LatLng? location;

  // Practice Statistics
  final int runningCount;
  final int ongoingCount;
  final int patientCount;

  // Status Flags
  final bool isFavorite;
  final bool isActive;
  final bool isLive;
  final bool isPopular;
  final bool isFeatured;

  // Section Ordering
  final int liveOrder;
  final int popularOrder;
  final int featuredOrder;

  factory DoctorModel.fromFirestore(String id, Map<String, dynamic> data) {
    return DoctorModel(
      id: id,
      name: _require(data, 'name', id),
      specialty: _localizedSpecialty(_require(data, 'specialtyKey', id)),
      imageUrl: data['imageUrl'] as String?,
      accentColor: _colorFromHex(data['accentColorHex']),
      rating: _toDouble(data['rating'], 4.5),
      ratingPercent: _toInt(data['ratingPercent'], 85),
      reviewsCount: _toInt(data['reviewsCount'], 100),
      patientStoriesCount: _toInt(data['patientStoriesCount'], 50),
      experienceYears: _toInt(data['experienceYears'], 5),
      hourlyRate: _toDouble(data['hourlyRate'], 28.0),
      nextAvailableTime: data['nextAvailableAt'] as String? ?? '',
      services: _parseServices(data),
      location: _parseLocation(data['location']),
      runningCount: _toInt(data['runningCount'], 100),
      ongoingCount: _toInt(data['ongoingCount'], 500),
      patientCount: _toInt(data['patientCount'], 700),
      isFavorite: data['isFavorite'] as bool? ?? false,
      isActive: data['isActive'] as bool? ?? true,
      isLive: data['isLive'] as bool? ?? false,
      isPopular: data['isPopular'] as bool? ?? false,
      isFeatured: data['isFeatured'] as bool? ?? false,
      liveOrder: _toInt(data['liveOrder'], 9999),
      popularOrder: _toInt(data['popularOrder'], 9999),
      featuredOrder: _toInt(data['featuredOrder'], 9999),
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

// ─────────────────────────────────────────────────────────────────────────────
// Firestore Parsing Helpers
// ─────────────────────────────────────────────────────────────────────────────

String _require(Map<String, dynamic> data, String field, String id) {
  final value = data[field];
  if (value is String && value.trim().isNotEmpty) return value.trim();
  throw FormatException('Doctor $id is missing required field: $field');
}

int _toInt(dynamic value, int fallback) => (value as num?)?.toInt() ?? fallback;

double _toDouble(dynamic value, double fallback) =>
    (value as num?)?.toDouble() ?? fallback;

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
    'dentist' => tr.dentist,
    'medicine_specialist' => tr.medicineSpecialist,
    'dental_specialist' => tr.dentalSpecialist,
    'general_surgeon' => tr.generalSurgeon,
    'heart_specialist' => tr.heartSpecialist,
    'eye_specialist' => tr.eyeSpecialist,
    'live_cardiologist' => tr.liveCardiologist,
    'live_dentist' => tr.liveDentist,
    'live_pediatrician' => tr.livePediatrician,
    'live_neurologist' => tr.liveNeurologist,
    _ => key.replaceAll('_', ' '),
  };
}
