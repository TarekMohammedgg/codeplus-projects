import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

const defaultDoctorLocation = LatLng(-1.286389, 36.817223);

List<String> defaultServices() {
  return [tr.serviceOne, tr.serviceTwo, tr.serviceThree];
}

DoctorModel defaultDoctorDetails() {
  return DoctorModel(
    id: '1',
    name: 'Dr. Pediatrician',
    specialty: tr.medicineSpecialist,
    services: defaultServices(),
    location: defaultDoctorLocation,
  );
}

/// Central Master List of all Doctors in the application.
List<DoctorModel> allDoctors() {
  return [
    // ── Primary Doctors (Find Doctors / Shared) ──────────────────────────────
    DoctorModel(
      id: 'doc_1',
      name: 'Dr. Shruti Kedia',
      specialty: tr.dentist,
      experienceYears: 7,
      ratingPercent: 87,
      patientStoriesCount: 69,
      nextAvailableTime: '10:00 AM ${tr.tomorrow}',
      image: Assets.assetsDummyDoctorsDoctor1,
      services: defaultServices(),
      location: defaultDoctorLocation,
    ),
    DoctorModel(
      id: 'doc_5',
      name: 'Dr. Fillerup Grab',
      specialty: tr.medicineSpecialist,
      experienceYears: 8,
      ratingPercent: 92,
      patientStoriesCount: 104,
      rating: 4.9,
      reviewsCount: 124,
      hourlyRate: 30.00,
      accentColor: const Color(0xFF0EBE7E),
      nextAvailableTime: '02:30 PM ${tr.tomorrow}',
      image: Assets.assetsDummyPopularDoctor1,
      isPopular: true,
      services: defaultServices(),
      location: defaultDoctorLocation,
    ),
    DoctorModel(
      id: 'doc_6',
      name: 'Dr. Blessing',
      specialty: tr.dentalSpecialist,
      experienceYears: 10,
      ratingPercent: 95,
      patientStoriesCount: 120,
      rating: 4.8,
      reviewsCount: 98,
      hourlyRate: 26.00,
      accentColor: const Color(0xFF2B7CEE),
      nextAvailableTime: '04:00 PM ${tr.tomorrow}',
      image: Assets.assetsDummyPopularDoctor2,
      isPopular: true,
      isFavorite: true,
      services: defaultServices(),
      location: defaultDoctorLocation,
    ),
    DoctorModel(
      id: 'doc_3',
      name: 'Dr. Crownover',
      specialty: tr.dentist,
      experienceYears: 5,
      ratingPercent: 59,
      patientStoriesCount: 86,
      rating: 4.9,
      reviewsCount: 110,
      nextAvailableTime: '11:00 AM ${tr.tomorrow}',
      image: Assets.assetsDummyDoctorsDoctor3,
      isFavorite: true,
      services: defaultServices(),
      location: defaultDoctorLocation,
    ),
    DoctorModel(
      id: 'doc_4',
      name: 'Dr. Balestra',
      specialty: tr.dentist,
      experienceYears: 6,
      ratingPercent: 87,
      patientStoriesCount: 69,
      hourlyRate: 28.00,
      rating: 4.2,
      reviewsCount: 65,
      accentColor: const Color(0xFF9059FF),
      nextAvailableTime: '01:00 PM ${tr.tomorrow}',
      image: Assets.assetsDummyDoctorsDoctor4,
      isFeatured: true,
      services: defaultServices(),
      location: defaultDoctorLocation,
    ),
    DoctorModel(
      id: 'doc_2',
      name: 'Dr. Watamaniuk',
      specialty: tr.dentist,
      experienceYears: 9,
      ratingPercent: 74,
      patientStoriesCount: 78,
      nextAvailableTime: '12:00 AM ${tr.tomorrow}',
      image: Assets.assetsDummyDoctorsDoctor2,
      services: defaultServices(),
      location: defaultDoctorLocation,
    ),

    // ── Popular & Featured Doctors ───────────────────────────────────────────
    DoctorModel(
      id: 'feat_1',
      name: 'Dr. Cric',
      specialty: tr.generalSurgeon,
      hourlyRate: 25.00,
      rating: 3.7,
      reviewsCount: 42,
      accentColor: const Color(0xFF0EBE7E),
      image: Assets.assetsDummyDoctorsDoctor1,
      isFeatured: true,
      services: defaultServices(),
      location: defaultDoctorLocation,
    ),
    DoctorModel(
      id: 'feat_2',
      name: 'Dr. Strain',
      specialty: tr.dentalSpecialist,
      hourlyRate: 22.00,
      rating: 3.9,
      reviewsCount: 56,
      accentColor: const Color(0xFF2B7CEE),
      image: Assets.assetsDummyDoctorsDoctor2,
      isFeatured: true,
      services: defaultServices(),
      location: defaultDoctorLocation,
    ),
    DoctorModel(
      id: 'pop_3',
      name: 'Dr. Crick',
      specialty: tr.heartSpecialist,
      rating: 4.7,
      reviewsCount: 86,
      accentColor: const Color(0xFFFE7F44),
      image: Assets.assetsDummyPopularDoctor1,
      isPopular: true,
      services: defaultServices(),
      location: defaultDoctorLocation,
    ),
    DoctorModel(
      id: 'pop_4',
      name: 'Dr. Lachinet',
      specialty: tr.eyeSpecialist,
      rating: 4.9,
      reviewsCount: 140,
      hourlyRate: 29.00,
      accentColor: const Color(0xFF9059FF),
      image: Assets.assetsDummyPopularDoctor2,
      isPopular: true,
      isFeatured: true,
      services: defaultServices(),
      location: defaultDoctorLocation,
    ),

    // ── Favourite Doctors ────────────────────────────────────────────────────
    DoctorModel(
      id: 'fav_1',
      name: 'Dr. Shouey',
      specialty: tr.medicineSpecialist,
      image: Assets.assetsDummyDoctorsDoctor1,
      rating: 4.9,
      reviewsCount: 120,
      isFavorite: true,
      services: defaultServices(),
      location: defaultDoctorLocation,
    ),
    DoctorModel(
      id: 'fav_2',
      name: 'Dr. Christen',
      specialty: tr.dentalSpecialist,
      image: Assets.assetsDummyDoctorsDoctor2,
      rating: 4.8,
      reviewsCount: 95,
      isFavorite: true,
      services: defaultServices(),
      location: defaultDoctorLocation,
    ),

    // ── Live Doctors ──────────────────────────────────────────────────────────
    DoctorModel(
      id: 'live_1',
      name: 'Dr. Stephanie',
      specialty: tr.liveCardiologist,
      accentColor: const Color(0xFF4A90E2),
      image: Assets.assetsDummyLiveDoctor1,
      isLive: true,
      services: defaultServices(),
      location: defaultDoctorLocation,
    ),
    DoctorModel(
      id: 'live_2',
      name: 'Dr. Alexander',
      specialty: tr.liveDentist,
      accentColor: const Color(0xFF0EBE7E),
      image: Assets.assetsDummyLiveDoctor2,
      isLive: true,
      services: defaultServices(),
      location: defaultDoctorLocation,
    ),
    DoctorModel(
      id: 'live_3',
      name: 'Dr. Michael',
      specialty: tr.livePediatrician,
      accentColor: const Color(0xFFFF7A59),
      image: Assets.assetsDummyLiveDoctor3,
      isLive: true,
      services: defaultServices(),
      location: defaultDoctorLocation,
    ),
    DoctorModel(
      id: 'live_4',
      name: 'Dr. Jessica',
      specialty: tr.liveNeurologist,
      accentColor: const Color(0xFF9B51E0),
      image: Assets.assetsDummyLiveDoctor1,
      isLive: true,
      services: defaultServices(),
      location: defaultDoctorLocation,
    ),
  ];
}

/// Filtered doctor getters based on properties
List<DoctorModel> favouriteDoctors() =>
    allDoctors().where((doctor) => doctor.isFavorite).toList();

List<DoctorModel> featuredDoctors() =>
    allDoctors().where((doctor) => doctor.isFeatured).toList();

List<DoctorModel> popularDoctors() =>
    allDoctors().where((doctor) => doctor.isPopular).toList();

List<DoctorModel> liveDoctors() =>
    allDoctors().where((doctor) => doctor.isLive).toList();

List<DoctorModel> doctors() => allDoctors();
