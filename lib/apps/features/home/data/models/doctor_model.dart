import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
export 'package:doctor_hunt/apps/core/models/doctor_model.dart';

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

typedef LiveDoctorItem = DoctorModel;
typedef PopularDoctorItem = DoctorModel;
typedef FeaturedDoctorItem = DoctorModel;
