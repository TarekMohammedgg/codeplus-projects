import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/section_header.dart';

import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class PopularDoctorSection extends StatelessWidget {
  const PopularDoctorSection({
    super.key,
    required this.doctors,
    this.onSeeAllPressed,
  });

  final List<DoctorModel> doctors;
  final VoidCallback? onSeeAllPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: tr.popularDoctor,
          onSeeAllPressed:
              onSeeAllPressed ?? () => const FindDoctorsRoute().push(context),
        ),
        14.verticalSpace,
        SizedBox(
          height: 240,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: doctors.length,
            separatorBuilder: (context, index) => 14.horizontalSpace,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return PopularDoctorCard(
                doctor: doctor,
                onTap: () => DoctorDetailsRoute(doctor).push(context),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PopularDoctorCard extends StatelessWidget {
  const PopularDoctorCard({super.key, required this.doctor, this.onTap});

  final DoctorModel doctor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 190,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.6)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 125,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: doctor.accentColor.withValues(alpha: 0.12),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: DoctorImage(
                      imageUrl: doctor.imageUrl,
                      width: double.infinity,
                      height: 125,
                      alignment: Alignment.topCenter,
                      fallback: const SizedBox.expand(),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x18000000),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      doctor.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: doctor.isFavorite
                          ? AppColors.error
                          : AppColors.disabled,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.bold16TextMain.copyWith(fontSize: 15),
                  ),
                  4.verticalSpace,
                  Text(
                    doctor.specialty,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.regular12TextSecondary.copyWith(
                      color: AppColors.textSecondary.withValues(alpha: 0.8),
                    ),
                  ),
                  8.verticalSpace,
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFB800),
                        size: 16,
                      ),
                      4.horizontalSpace,
                      Text(
                        doctor.rating.toStringAsFixed(1),
                        style: context.semiBold12TextMain,
                      ),
                      6.horizontalSpace,
                      Flexible(
                        child: Text(
                          '(${doctor.reviewsCount} ${tr.reviews})',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.regular11TextSecondary.copyWith(
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
