import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/features/home/data/models/doctor_model.dart';

const dummySkeletonDoctor = DoctorModel(
  id: 'skeleton',
  name: 'Dr. Filler Doctor Name',
  specialty: 'Specialist Medicine Long Text',
  imageUrl: null,
  accentColor: Color(0xFFE0E0E0),
  rating: 4.8,
  reviewsCount: 120,
  hourlyRate: 30.0,
  isLive: true,
  isPopular: true,
  isFeatured: true,
);

const dummySkeletonDoctors = [
  dummySkeletonDoctor,
  dummySkeletonDoctor,
  dummySkeletonDoctor,
];

const dummySkeletonCategoryItem = DoctorCategoryItem(
  id: 'cat_skeleton',
  name: '',
  icon: Icons.category_rounded,
  primaryColor: Color(0xFFC4C8D0),
  secondaryColor: Color(0xFFE8EBEF),
);

const dummySkeletonCategories = [
  dummySkeletonCategoryItem,
  dummySkeletonCategoryItem,
  dummySkeletonCategoryItem,
  dummySkeletonCategoryItem,
  dummySkeletonCategoryItem,
  dummySkeletonCategoryItem,
];
