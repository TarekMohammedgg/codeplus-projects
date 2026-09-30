import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/doctor_sort.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

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
