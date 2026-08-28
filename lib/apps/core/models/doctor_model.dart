import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String? imageUrl;
  String? get image => imageUrl;
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

  // Filter props / flags
  final bool isFavorite;
  final bool isFeatured;
  final bool isPopular;
  final bool isLive;
  final bool isActive;
  final int liveOrder;
  final int popularOrder;
  final int featuredOrder;
  final String? category;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    this.imageUrl,
    this.accentColor = const Color(0xFF0EBE7E),
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
    this.isFeatured = false,
    this.isPopular = false,
    this.isLive = false,
    this.isActive = true,
    this.liveOrder = _lastOrder,
    this.popularOrder = _lastOrder,
    this.featuredOrder = _lastOrder,
    this.category,
  });

  static const _lastOrder = 0x7fffffff;

  factory DoctorModel.fromFirestore(String id, Map<String, dynamic> data) {
    final locationData = data['location'];
    LatLng? location;
    if (locationData is Map<String, dynamic>) {
      final lat = (locationData['latitude'] as num?)?.toDouble();
      final lng = (locationData['longitude'] as num?)?.toDouble();
      if (lat != null && lng != null) {
        location = LatLng(lat, lng);
      }
    }

    final rawServices = data['serviceKeys'] ?? data['services'];
    final services = rawServices is List
        ? rawServices.map((e) => e.toString()).toList()
        : const <String>[];

    return DoctorModel(
      id: id,
      name: _requiredString(data, 'name', id),
      specialty: _localizedSpecialty(_requiredString(data, 'specialtyKey', id)),
      imageUrl: data['imageUrl'] as String?,
      accentColor: _colorFromHex(data['accentColorHex'] as String?),
      rating: (data['rating'] as num?)?.toDouble() ?? 4.5,
      ratingPercent: (data['ratingPercent'] as num?)?.toInt() ?? 85,
      reviewsCount: (data['reviewsCount'] as num?)?.toInt() ?? 100,
      patientStoriesCount: (data['patientStoriesCount'] as num?)?.toInt() ?? 50,
      experienceYears: (data['experienceYears'] as num?)?.toInt() ?? 5,
      hourlyRate: (data['hourlyRate'] as num?)?.toDouble() ?? 28.0,
      nextAvailableTime: (data['nextAvailableAt'] as String?) ?? '',
      services: services,
      location: location,
      runningCount: (data['runningCount'] as num?)?.toInt() ?? 100,
      ongoingCount: (data['ongoingCount'] as num?)?.toInt() ?? 500,
      patientCount: (data['patientCount'] as num?)?.toInt() ?? 700,
      isActive: data['isActive'] as bool? ?? true,
      isFavorite: data['isFavorite'] as bool? ?? false,
      isPopular: data['isPopular'] as bool? ?? false,
      isFeatured: data['isFeatured'] as bool? ?? false,
      isLive: data['isLive'] as bool? ?? false,
      category: data['category'] as String?,
      liveOrder: (data['liveOrder'] as num?)?.toInt() ?? _lastOrder,
      popularOrder: (data['popularOrder'] as num?)?.toInt() ?? _lastOrder,
      featuredOrder: (data['featuredOrder'] as num?)?.toInt() ?? _lastOrder,
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
    bool? isFeatured,
    bool? isPopular,
    bool? isLive,
    bool? isActive,
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
      isFeatured: isFeatured ?? this.isFeatured,
      isPopular: isPopular ?? this.isPopular,
      isLive: isLive ?? this.isLive,
      isActive: isActive ?? this.isActive,
      liveOrder: liveOrder ?? this.liveOrder,
      popularOrder: popularOrder ?? this.popularOrder,
      featuredOrder: featuredOrder ?? this.featuredOrder,
      category: category ?? this.category,
    );
  }
}

String _requiredString(
  Map<String, dynamic> data,
  String field,
  String doctorId,
) {
  final value = data[field];
  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }
  throw FormatException('Doctor $doctorId is missing $field.');
}

Color _colorFromHex(String? value) {
  final hex = value?.replaceFirst('#', '');
  if (hex == null) {
    return const Color(0xFF0EBE7E);
  }

  final colorValue = switch (hex.length) {
    6 => int.tryParse('FF$hex', radix: 16),
    8 => int.tryParse(hex, radix: 16),
    _ => null,
  };

  return colorValue == null ? const Color(0xFF0EBE7E) : Color(colorValue);
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
