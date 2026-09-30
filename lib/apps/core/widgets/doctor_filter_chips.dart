import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

/// "All" + optional "Favorites" + one chip per specialty. Shared by the
/// patient Doctors tab and the admin Doctors list.
class DoctorFilterChips extends StatelessWidget {
  const DoctorFilterChips({
    super.key,
    required this.specialties,
    required this.selectedSpecialtyId,
    required this.onSpecialtySelected,
    this.favoritesOnly = false,
    this.onFavoritesToggled,
  });

  final List<SpecialtyModel> specialties;
  final String? selectedSpecialtyId;
  final bool favoritesOnly;
  final ValueChanged<String?> onSpecialtySelected;

  /// Null hides the Favorites chip.
  final VoidCallback? onFavoritesToggled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(
            label: context.tr.filterAll,
            selected: selectedSpecialtyId == null,
            onSelected: () => onSpecialtySelected(null),
          ),
          if (onFavoritesToggled case final onFavoritesToggled?) ...[
            8.horizontalSpace,
            _FilterChip(
              label: context.tr.favorites,
              icon: Icons.favorite_rounded,
              selected: favoritesOnly,
              onSelected: onFavoritesToggled,
            ),
          ],
          for (final specialty in specialties) ...[
            8.horizontalSpace,
            _FilterChip(
              label: specialty.localizedName,
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
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.white : AppColors.textSecondary;
    return ChoiceChip(
      label: Text(label),
      avatar: icon == null
          ? null
          : Icon(
              icon,
              size: 16,
              color: selected ? AppColors.white : AppColors.favorite,
            ),
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
