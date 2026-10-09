import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/review_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/apps/core/widgets/clinic_location_map.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

/// "4.7 · 24 Reviews".
class DoctorRatingSummary extends StatelessWidget {
  const DoctorRatingSummary({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, color: AppColors.rating, size: 22),
        6.horizontalSpace,
        Text(
          context.tr.ratingSummary(
            rating: doctor.rating.toStringAsFixed(1),
            count: doctor.reviewsCount,
          ),
          style: context.semiBold16TextMain,
        ),
      ],
    );
  }
}

class RecentReviewsSection extends StatelessWidget {
  const RecentReviewsSection({super.key, required this.reviews});

  final List<ReviewModel> reviews;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr.recentReviews, style: context.medium18TextMain),
        12.verticalSpace,
        if (reviews.isEmpty)
          Text(context.tr.noReviewsYet, style: context.regular14TextSecondary)
        else
          for (final review in reviews) ...[
            _ReviewTile(review: review),
            10.verticalSpace,
          ],
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    final createdAt = review.createdAt;
    final locale = context.localeCode;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.patientName,
                  style: context.semiBold14TextMain,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (createdAt != null)
                Text(
                  DateFormat.yMMMd(locale).format(createdAt),
                  style: context.regular12TextSecondary,
                ),
            ],
          ),
          6.verticalSpace,
          DoctorStarRating(rating: review.rating.toDouble()),
          if (review.comment.isNotEmpty) ...[
            8.verticalSpace,
            Text(review.comment, style: context.regular14TextSecondary),
          ],
        ],
      ),
    );
  }
}

/// The ONE clinic location from `clinic/settings`, the same for every doctor.
class ClinicLocationSection extends StatelessWidget {
  const ClinicLocationSection({super.key, required this.clinic});

  final ClinicModel? clinic;

  @override
  Widget build(BuildContext context) {
    final location = clinic?.location;
    final address = clinic?.localizedAddress ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr.clinicLocation, style: context.medium18TextMain),
        12.verticalSpace,
        if (location == null)
          Text(
            context.tr.clinicLocationNotSet,
            style: context.regular14TextSecondary,
          )
        else ...[
          if (address.isNotEmpty) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
                6.horizontalSpace,
                Expanded(
                  child: Text(address, style: context.regular14TextSecondary),
                ),
              ],
            ),
            12.verticalSpace,
          ],
          ClinicLocationMap(location: location),
        ],
      ],
    );
  }
}
