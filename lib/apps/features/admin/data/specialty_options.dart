import 'package:flutter/material.dart';

import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class SpecialtyOption {
  const SpecialtyOption({
    required this.key,
    required this.label,
    this.icon = Icons.medical_services_outlined,
  });

  final String key;
  final String label;
  final IconData icon;

  @override
  bool operator ==(Object other) =>
      other is SpecialtyOption && other.key == key;

  @override
  int get hashCode => key.hashCode;
}

List<SpecialtyOption> specialtyOptions() => [
  SpecialtyOption(
    key: 'cardiologist',
    label: tr.specialtyCardiologist,
    icon: Icons.favorite_rounded,
  ),
  SpecialtyOption(
    key: 'orthopedic',
    label: tr.specialtyOrthopedic,
    icon: Icons.accessibility_new_rounded,
  ),
  SpecialtyOption(
    key: 'dentist',
    label: tr.specialtyDentist,
    icon: Icons.medical_services_rounded,
  ),
  SpecialtyOption(
    key: 'pediatrician',
    label: tr.specialtyPediatrician,
    icon: Icons.child_care_rounded,
  ),
  SpecialtyOption(
    key: 'dermatologist',
    label: tr.specialtyDermatologist,
    icon: Icons.face_rounded,
  ),
  SpecialtyOption(
    key: 'neurologist',
    label: tr.specialtyNeurologist,
    icon: Icons.psychology_rounded,
  ),
  SpecialtyOption(
    key: 'eye_specialist',
    label: tr.specialtyEyeSpecialist,
    icon: Icons.remove_red_eye_rounded,
  ),
  SpecialtyOption(
    key: 'medicine_specialist',
    label: tr.specialtyMedicineSpecialist,
    icon: Icons.medication_rounded,
  ),
  SpecialtyOption(
    key: 'general_surgeon',
    label: tr.specialtyGeneralSurgeon,
    icon: Icons.healing_rounded,
  ),
];
