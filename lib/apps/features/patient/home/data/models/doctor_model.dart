import 'package:flutter/material.dart';
export 'package:doctor_hunt/apps/core/models/doctor_model.dart';

class DoctorCategoryItem {
  final String id;
  final String name;
  final String? image;
  final IconData? icon;
  final Color primaryColor;
  final Color secondaryColor;

  const DoctorCategoryItem({
    required this.id,
    required this.name,
    this.image,
    this.icon,
    required this.primaryColor,
    required this.secondaryColor,
  });
}
