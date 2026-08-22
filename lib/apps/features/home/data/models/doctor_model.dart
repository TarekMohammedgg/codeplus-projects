import 'package:flutter/material.dart';

class LiveDoctorItem {
  final String id;
  final String name;
  final String specialty;
  final Color accentColor;
  final String? image;

  const LiveDoctorItem({
    required this.id,
    required this.name,
    required this.specialty,
    required this.accentColor,
    this.image,
  });
}

class DoctorCategoryItem {
  final String id;
  final String name;
  final IconData? icon;
  final String? image;
  final Color primaryColor;
  final Color secondaryColor;

  const DoctorCategoryItem({
    required this.id,
    required this.name,
    this.icon,
    this.image,
    required this.primaryColor,
    required this.secondaryColor,
  });
}

class PopularDoctorItem {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviewsCount;
  final Color accentColor;
  final String? image;
  final bool isFavorite;

  const PopularDoctorItem({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewsCount,
    required this.accentColor,
    this.image,
    this.isFavorite = false,
  });
}

class FeaturedDoctorItem {
  final String id;
  final String name;
  final String specialty;
  final double hourlyRate;
  final double rating;
  final int reviewsCount;
  final Color accentColor;
  final String? image;
  final bool isFavorite;

  const FeaturedDoctorItem({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hourlyRate,
    required this.rating,
    required this.reviewsCount,
    required this.accentColor,
    this.image,
    this.isFavorite = false,
  });
}

