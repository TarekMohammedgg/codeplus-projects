import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/features/home/data/models/doctor_model.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

List<DoctorCategoryItem> categories() {
  return [
    DoctorCategoryItem(
      id: 'cat_dental',
      name: tr.dental,
      image: Assets.assetsDummyDentist,
      icon: Icons.medical_services_rounded,
      primaryColor: const Color(0xFF2B7CEE),
      secondaryColor: const Color(0xFFE9F2FF),
    ),
    DoctorCategoryItem(
      id: 'cat_cardiology',
      name: tr.cardiology,
      image: Assets.assetsDummyHeart,
      icon: Icons.favorite_rounded,
      primaryColor: const Color(0xFF0EBE7E),
      secondaryColor: const Color(0xFFE8FBF6),
    ),
    DoctorCategoryItem(
      id: 'cat_eye',
      name: tr.eyeCare,
      image: Assets.assetsDummyEye,
      icon: Icons.remove_red_eye_rounded,
      primaryColor: const Color(0xFFFE7F44),
      secondaryColor: const Color(0xFFFFF2EC),
    ),
    DoctorCategoryItem(
      id: 'cat_nutrition',
      name: tr.nutrition,
      image: Assets.assetsDummyBody,
      icon: Icons.apple_rounded,
      primaryColor: const Color(0xFFFF5C5C),
      secondaryColor: const Color(0xFFFFEEEE),
    ),
    DoctorCategoryItem(
      id: 'cat_pediatric',
      name: tr.pediatric,
      icon: Icons.child_care_rounded,
      primaryColor: const Color(0xFF9059FF),
      secondaryColor: const Color(0xFFF4EEFF),
    ),
    DoctorCategoryItem(
      id: 'cat_neurology',
      name: tr.neurology,
      icon: Icons.psychology_rounded,
      primaryColor: const Color(0xFF07D9AD),
      secondaryColor: const Color(0xFFE7FAF6),
    ),
  ];
}
