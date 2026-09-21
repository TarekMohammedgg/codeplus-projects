import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class DoctorProfileCard extends StatelessWidget {
  const DoctorProfileCard({
    super.key,
    required this.doctor,
    this.onBookNow,
    this.onFavoriteToggle,
  });

  final DoctorModel doctor;
  final VoidCallback? onBookNow;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            //CR hardcode color
            // Solved
            color: AppColors.shadowCard,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: DoctorImage(
                    imageUrl: doctor.imageUrl,
                    fallback: const DoctorAvatarPlaceholder(circle: false),
                  ),
                ),
              ),
              16.horizontalSpace,
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
                            style: context.bold18TextMain.copyWith(
                              fontSize: 17,
                              height: 1.2,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onFavoriteToggle,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              doctor.isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: doctor.isFavorite
                                  //CR hardcode color
                                  // Solved
                                  ? AppColors.favorite
                                  : AppColors.disabled,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    4.verticalSpace,
                    Text(
                      doctor.specialty,
                      style: context.regular14TextSecondary.copyWith(
                        fontSize: 13,
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                    8.verticalSpace,
                    DoctorStarRating(rating: doctor.rating),
                    8.verticalSpace,
                    Text(
                      '\$${doctor.hourlyRate.toStringAsFixed(2)}${tr.perHour}',
                      style: context.bold16Primary.copyWith(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (onBookNow != null) ...[
            16.verticalSpace,
            AppPrimaryButton(
              label: tr.bookNow,
              onPressed: onBookNow,
              height: 48,
              fontSize: 15,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ],
      ),
    );
  }
}

class DoctorStarRating extends StatelessWidget {
  const DoctorStarRating({super.key, required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final filled = index < rating.floor();
        final halfFilled = !filled && index < rating;
        return Icon(
          filled
              ? Icons.star_rounded
              : halfFilled
              ? Icons.star_half_rounded
              : Icons.star_border_rounded,
          //CR hardcode color
          // Solved
          color: AppColors.rating,
          size: 18,
        );
      }),
    );
  }
}
