import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class FavouriteDoctorCard extends StatelessWidget {
  const FavouriteDoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
    this.onFavoriteToggle,
  });

  final DoctorModel doctor;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: GestureDetector(
                onTap: onFavoriteToggle,
                child: Icon(
                  doctor.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: doctor.isFavorite
                      ? AppColors.error
                      : AppColors.disabled,
                  size: 20,
                ),
              ),
            ),
            2.verticalSpace,
            _DoctorAvatar(imageUrl: doctor.imageUrl),
            8.verticalSpace,
            Text(
              doctor.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.bold16TextMain.copyWith(fontSize: 14),
            ),
            2.verticalSpace,
            Text(
              doctor.specialty,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.regular14Primary.copyWith(fontSize: 12),
            ),
            6.verticalSpace,
            _RatingRow(
              rating: doctor.rating,
              reviewsCount: doctor.reviewsCount,
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorAvatar extends StatelessWidget {
  const _DoctorAvatar({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 70,
        height: 70,
        child: DoctorImage(
          imageUrl: imageUrl,
          fallback: const DoctorAvatarPlaceholder(size: 70),
        ),
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.rating, required this.reviewsCount});

  final double rating;
  final int reviewsCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 15),
        4.horizontalSpace,
        Text(
          rating.toStringAsFixed(1),
          style: context.semiBold12TextMain.copyWith(fontSize: 11),
        ),
        4.horizontalSpace,
        Text(
          '($reviewsCount)',
          style: context.regular12TextSecondary.copyWith(
            color: AppColors.textSecondary.withValues(alpha: 0.7),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
