import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/features/home/data/models/doctor_model.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

abstract final class MockHomeData {
  static List<LiveDoctorItem> liveDoctors(Translations t) => [
    LiveDoctorItem(
      id: 'live_1',
      name: 'Dr. Stephanie',
      specialty: t.liveCardiologist,
      accentColor: const Color(0xFF4A90E2),
      image: Assets.assetsDummyLiveDoctor1,
    ),
    LiveDoctorItem(
      id: 'live_2',
      name: 'Dr. Alexander',
      specialty: t.liveDentist,
      accentColor: const Color(0xFF0EBE7E),
      image: Assets.assetsDummyLiveDoctor2,
    ),
    LiveDoctorItem(
      id: 'live_3',
      name: 'Dr. Michael',
      specialty: t.livePediatrician,
      accentColor: const Color(0xFFFF7A59),
      image: Assets.assetsDummyLiveDoctor3,
    ),
    LiveDoctorItem(
      id: 'live_4',
      name: 'Dr. Jessica',
      specialty: t.liveNeurologist,
      accentColor: const Color(0xFF9B51E0),
      image: Assets.assetsDummyLiveDoctor1,
    ),
  ];

  static List<DoctorCategoryItem> categories(Translations t) => [
    DoctorCategoryItem(
      id: 'cat_dental',
      name: t.dental,
      image: Assets.assetsDummyDentist,
      icon: Icons.medical_services_rounded,
      primaryColor: const Color(0xFF2B7CEE),
      secondaryColor: const Color(0xFFE9F2FF),
    ),
    DoctorCategoryItem(
      id: 'cat_cardiology',
      name: t.cardiology,
      image: Assets.assetsDummyHeart,
      icon: Icons.favorite_rounded,
      primaryColor: const Color(0xFF0EBE7E),
      secondaryColor: const Color(0xFFE8FBF6),
    ),
    DoctorCategoryItem(
      id: 'cat_eye',
      name: t.eyeCare,
      image: Assets.assetsDummyEye,
      icon: Icons.remove_red_eye_rounded,
      primaryColor: const Color(0xFFFE7F44),
      secondaryColor: const Color(0xFFFFF2EC),
    ),
    DoctorCategoryItem(
      id: 'cat_nutrition',
      name: t.nutrition,
      image: Assets.assetsDummyBody,
      icon: Icons.apple_rounded,
      primaryColor: const Color(0xFFFF5C5C),
      secondaryColor: const Color(0xFFFFEEEE),
    ),
    DoctorCategoryItem(
      id: 'cat_pediatric',
      name: t.pediatric,
      icon: Icons.child_care_rounded,
      primaryColor: const Color(0xFF9059FF),
      secondaryColor: const Color(0xFFF4EEFF),
    ),
    DoctorCategoryItem(
      id: 'cat_neurology',
      name: t.neurology,
      icon: Icons.psychology_rounded,
      primaryColor: const Color(0xFF07D9AD),
      secondaryColor: const Color(0xFFE7FAF6),
    ),
  ];

  static List<PopularDoctorItem> popularDoctors(Translations t) => [
    PopularDoctorItem(
      id: 'pop_1',
      name: 'Dr. Fillerup Grab',
      specialty: t.medicineSpecialist,
      rating: 4.9,
      reviewsCount: 124,
      accentColor: const Color(0xFF0EBE7E),
      image: Assets.assetsDummyPopularDoctor1,
      isFavorite: true,
    ),
    PopularDoctorItem(
      id: 'pop_2',
      name: 'Dr. Blessing',
      specialty: t.dentalSpecialist,
      rating: 4.8,
      reviewsCount: 98,
      accentColor: const Color(0xFF2B7CEE),
      image: Assets.assetsDummyPopularDoctor2,
    ),
    PopularDoctorItem(
      id: 'pop_3',
      name: 'Dr. Crick',
      specialty: t.heartSpecialist,
      rating: 4.7,
      reviewsCount: 86,
      accentColor: const Color(0xFFFE7F44),
      image: Assets.assetsDummyPopularDoctor1,
    ),
    PopularDoctorItem(
      id: 'pop_4',
      name: 'Dr. Lachinet',
      specialty: t.eyeSpecialist,
      rating: 4.9,
      reviewsCount: 140,
      accentColor: const Color(0xFF9059FF),
      image: Assets.assetsDummyPopularDoctor2,
    ),
  ];

  static List<FeaturedDoctorItem> featuredDoctors(Translations t) => [
    FeaturedDoctorItem(
      id: 'feat_1',
      name: 'Dr. Cric',
      specialty: t.generalSurgeon,
      hourlyRate: 25.00,
      rating: 3.7,
      reviewsCount: 42,
      accentColor: const Color(0xFF0EBE7E),
      image: Assets.assetsDummyDoctorsDoctor1,
    ),
    FeaturedDoctorItem(
      id: 'feat_2',
      name: 'Dr. Strain',
      specialty: t.dentalSpecialist,
      hourlyRate: 22.00,
      rating: 3.9,
      reviewsCount: 56,
      accentColor: const Color(0xFF2B7CEE),
      image: Assets.assetsDummyDoctorsDoctor2,
      isFavorite: true,
    ),
    FeaturedDoctorItem(
      id: 'feat_3',
      name: 'Dr. Lachinet',
      specialty: t.heartSpecialist,
      hourlyRate: 29.00,
      rating: 4.0,
      reviewsCount: 78,
      accentColor: const Color(0xFFFF5C5C),
      image: Assets.assetsDummyDoctorsDoctor3,
    ),
    FeaturedDoctorItem(
      id: 'feat_4',
      name: 'Dr. Balestra',
      specialty: t.eyeSpecialist,
      hourlyRate: 28.00,
      rating: 4.2,
      reviewsCount: 65,
      accentColor: const Color(0xFF9059FF),
      image: Assets.assetsDummyDoctorsDoctor4,
    ),
  ];
}
