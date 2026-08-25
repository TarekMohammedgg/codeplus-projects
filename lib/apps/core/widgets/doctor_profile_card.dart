import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/features/doctors/data/models/doctor_detail_args.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class DoctorProfileCard extends StatelessWidget {
  const DoctorProfileCard({
    super.key,
    required this.doctor,
    this.onBookNow,
    this.onFavoriteToggle,
  });

  final DoctorDetailArgs doctor;
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
            color: Color(0x0C000000),
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
                  child: doctor.image != null
                      ? Image.asset(
                          doctor.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const DoctorAvatarPlaceholder(circle: false),
                        )
                      : const DoctorAvatarPlaceholder(circle: false),
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
                                  ? const Color(0xFFFF003A)
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
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onBookNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  tr.bookNow,
                  style: context.semiBold16White.copyWith(fontSize: 15),
                ),
              ),
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
          color: const Color(0xFFFFB800),
          size: 18,
        );
      }),
    );
  }
}
