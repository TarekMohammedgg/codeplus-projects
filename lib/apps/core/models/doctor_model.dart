import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String? image;
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
  final String? category;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    this.image,
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
    this.category,
  });

  DoctorModel copyWith({
    String? id,
    String? name,
    String? specialty,
    String? image,
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
    String? category,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      image: image ?? this.image,
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
      category: category ?? this.category,
    );
  }
}
