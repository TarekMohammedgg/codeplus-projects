import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/widgets/favorite_heart_icon.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/formatters.dart';
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
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.compact = false,
  });

  final DoctorModel doctor;
  final VoidCallback? onBookNow;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: compact
          ? const EdgeInsets.all(10)
          : const EdgeInsets.fromLTRB(19, 18, 19, 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: AppColors.shadowElevated, blurRadius: 20),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(compact ? 4 : 8),
                child: SizedBox(
                  width: compact ? 71 : 92,
                  height: compact ? 68 : 87,
                  child: DoctorImage(
                    imageUrl: doctor.imageUrl,
                    fallback: const DoctorAvatarPlaceholder(circle: false),
                  ),
                ),
              ),
              (compact ? 8 : 12).horizontalSpace,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: compact ? 8 : 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              doctor.name,
                              style: compact
                                  ? context.medium16TextMain
                                  : context.medium18TextMain,
                            ),
                          ),
                          GestureDetector(
                            onTap: onFavoriteToggle,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 4,
                              ),
                              child: FavoriteHeartIcon(
                                isFavorite: isFavorite,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      4.verticalSpace,
                      Text(
                        doctor.specialty,
                        style: compact
                            ? context.light12TextSecondary
                            : context.light14TextSecondary,
                      ),
                      (compact ? 6 : 10).verticalSpace,
                      Row(
                        children: [
                          DoctorStarRating(
                            rating: doctor.rating,
                            size: compact ? 12 : 16,
                          ),
                          if (!compact) ...[
                            const Spacer(),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '$feeCurrencySymbol ',
                                    style: context.medium16Primary,
                                  ),
                                  TextSpan(
                                    text: formatFeeAmount(
                                      doctor.consultationFee,
                                    ),
                                    style: context.light16TextSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (onBookNow != null) ...[
            15.verticalSpace,
            AppPrimaryButton(
              label: tr.bookNow,
              onPressed: onBookNow,
              width: 140,
              height: 32,
              padding: EdgeInsets.zero,
              textStyle: context.medium14White,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ],
      ),
    );
  }
}

class DoctorStarRating extends StatelessWidget {
  const DoctorStarRating({super.key, required this.rating, this.size = 18});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final filled = index < rating.floor();
        final halfFilled = !filled && index < rating;
        return Icon(
          halfFilled ? Icons.star_half_rounded : Icons.star_rounded,
          //CR hardcode color
          // Solved
          color: filled || halfFilled ? AppColors.rating : AppColors.disabled,
          size: size,
        );
      }),
    );
  }
}
