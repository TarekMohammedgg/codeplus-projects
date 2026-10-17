import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/widgets/favorite_heart_icon.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/formatters.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(color: AppColors.shadowElevated, blurRadius: 20),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: DoctorImage(
                    imageUrl: doctor.imageUrl,
                    width: 82,
                    height: 82,
                    fallback: const DoctorAvatarPlaceholder(
                      size: 82,
                      circle: false,
                    ),
                  ),
                ),
                15.horizontalSpace,
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.medium18TextMain,
                            ),
                          ),
                          GestureDetector(
                            onTap: onFavoriteTap,
                            child: FavoriteHeartIcon(
                              isFavorite: isFavorite,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      4.verticalSpace,
                      Text(
                        doctor.specialty,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.light14TextSecondary,
                      ),
                      10.verticalSpace,
                      Row(
                        children: [
                          DoctorStarRating(rating: doctor.rating, size: 16),
                          const Spacer(),
                          Text.rich(
                            TextSpan(
                              text: doctor.rating.toStringAsFixed(1),
                              style: context.medium16TextMain,
                              children: [
                                TextSpan(
                                  text:
                                      ' (${doctor.reviewsCount} ${context.tr.reviews})',
                                  style: context.regular12TextSecondary
                                      .copyWith(
                                        color: AppColors.textSecondary
                                            .withValues(alpha: 0.8),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatFee(doctor.consultationFee),
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
