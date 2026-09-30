import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/doctor_sort.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

/// "All" + "Favorites" + one chip per specialty.
class DoctorFilterChips extends StatelessWidget {
  const DoctorFilterChips({
    super.key,
    required this.specialties,
    required this.selectedSpecialtyId,
    required this.favoritesOnly,
    required this.onSpecialtySelected,
    required this.onFavoritesToggled,
  });

  final List<SpecialtyModel> specialties;
  final String? selectedSpecialtyId;
  final bool favoritesOnly;
  final ValueChanged<String?> onSpecialtySelected;
  final VoidCallback onFavoritesToggled;

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
          8.horizontalSpace,
          _FilterChip(
            label: context.tr.favorites,
            icon: Icons.favorite_rounded,
            selected: favoritesOnly,
            onSelected: onFavoritesToggled,
          ),
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

class DoctorSortMenu extends StatelessWidget {
  const DoctorSortMenu({
    super.key,
    required this.sort,
    required this.onSelected,
  });

  final DoctorSort sort;
  final ValueChanged<DoctorSort> onSelected;

  String _label(BuildContext context, DoctorSort sort) => switch (sort) {
    DoctorSort.popular => context.tr.sortPopular,
    DoctorSort.topRated => context.tr.sortTopRated,
  };

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<DoctorSort>(
      initialValue: sort,
      onSelected: onSelected,
      itemBuilder: (context) => [
        for (final option in DoctorSort.values)
          CheckedPopupMenuItem(
            value: option,
            checked: option == sort,
            child: Text(_label(context, option)),
          ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.sort_rounded,
            size: 20,
            color: AppColors.textSecondary,
          ),
          4.horizontalSpace,
          Text(_label(context, sort), style: context.medium13TextSecondary),
        ],
      ),
    );
  }
}

class FindDoctorCard extends StatelessWidget {
  const FindDoctorCard({
    super.key,
    required this.doctor,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onBookNow,
    this.onTap,
  });

  final DoctorModel doctor;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onBookNow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowCard,
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: DoctorImage(
                    imageUrl: doctor.imageUrl,
                    width: 90,
                    height: 90,
                    fallback: const DoctorAvatarPlaceholder(
                      size: 90,
                      circle: false,
                    ),
                  ),
                ),
                14.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              doctor.name,
                              style: context.bold16TextMain.copyWith(
                                height: 1.2,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: onFavoriteTap,
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFavorite
                                  ? AppColors.favorite
                                  : AppColors.disabled,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      3.verticalSpace,
                      Text(
                        doctor.specialty,
                        style: context.regular14Primary.copyWith(fontSize: 13),
                      ),
                      8.verticalSpace,
                      Row(
                        children: [
                          DoctorStarRating(rating: doctor.rating),
                          5.horizontalSpace,
                          Text(
                            '${doctor.reviewsCount} ${context.tr.reviews}',
                            style: context.medium11TextSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            14.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${doctor.consultationFee.toStringAsFixed(2)}',
                  style: context.bold16Primary.copyWith(fontSize: 15),
                ),
                AppPrimaryButton(
                  label: context.tr.bookNow,
                  onPressed: onBookNow,
                  width: 112,
                  height: 38,
                  fontSize: 13,
                  borderRadius: BorderRadius.circular(8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
