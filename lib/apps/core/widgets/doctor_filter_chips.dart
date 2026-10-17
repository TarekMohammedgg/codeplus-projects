import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class DoctorFilterChips extends StatelessWidget {
  const DoctorFilterChips({
    super.key,
    required this.specialties,
    required this.selectedSpecialtyId,
    required this.onSpecialtySelected,
    this.counts,
  });

  final List<SpecialtyModel> specialties;
  final String? selectedSpecialtyId;
  final ValueChanged<String?> onSpecialtySelected;

  final Map<String?, int>? counts;

  String _label(BuildContext context, String? specialtyId, String label) {
    final counts = this.counts;
    if (counts == null) return label;
    return context.tr.labelWithCount(
      label: label,
      count: counts[specialtyId] ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(
            label: _label(context, null, context.tr.filterAll),
            selected: selectedSpecialtyId == null,
            onSelected: () => onSpecialtySelected(null),
          ),
          for (final specialty in specialties) ...[
            8.horizontalSpace,
            _FilterChip(
              label: _label(context, specialty.id, specialty.localizedName),
              selected: selectedSpecialtyId == specialty.id,
              onSelected: () => onSpecialtySelected(specialty.id),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.white : AppColors.textSecondary;
    return ChoiceChip(
      label: Text(label),
      showCheckmark: false,
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surface,
      side: BorderSide(color: selected ? AppColors.primary : AppColors.outline),
      labelStyle: context.medium13.copyWith(color: foreground),
    );
  }
}
