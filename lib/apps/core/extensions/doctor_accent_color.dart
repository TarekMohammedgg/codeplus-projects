import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';

extension DoctorAccentColor on DoctorModel {
  Color get accentColor {
    final cleaned = accentColorHex?.replaceFirst('#', '');
    if (cleaned == null) return AppColors.primary;

    final value = switch (cleaned.length) {
      6 => int.tryParse('FF$cleaned', radix: 16),
      8 => int.tryParse(cleaned, radix: 16),
      _ => null,
    };

    return value == null ? AppColors.primary : Color(value);
  }
}
