import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_search_bar.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/core/data/doctors_data.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import 'package:doctor_hunt/generated/style_atoms.dart';

class FindDoctorsScreen extends StatelessWidget {
  const FindDoctorsScreen({super.key});

  void onBookDoctor(BuildContext context, DoctorModel doctor) {
    SelectTimeRoute(doctor).push(context);
  }

  void onDoctorTap(BuildContext context, DoctorModel doctor) {
    DoctorDetailsRoute(doctor).push(context);
  }

  @override
  Widget build(BuildContext context) {
    final doctorsList = doctors();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          48.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FindDoctorsTopBar(onBackPressed: () => context.pop()),
          ),
          18.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: const AppSearchBar(),
          ),
          16.verticalSpace,
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 6,
                bottom: 32,
              ),
              itemCount: doctorsList.length,
              separatorBuilder: (context, index) => 14.verticalSpace,
              itemBuilder: (context, index) {
                final doctor = doctorsList[index];
                return FindDoctorCard(
                  doctor: doctor,
                  onBookNow: () => onBookDoctor(context, doctor),
                  onTap: () => onDoctorTap(context, doctor),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FindDoctorsTopBar extends StatelessWidget {
  const FindDoctorsTopBar({super.key, required this.onBackPressed});

  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppIconButton(
          onTap: onBackPressed,
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color: AppColors.textSecondary,
          ),
        ),
        16.horizontalSpace,
        Text(tr.findDoctors, style: context.bold18TextMain),
      ],
    );
  }
}

class FindDoctorCard extends StatelessWidget {
  const FindDoctorCard({
    super.key,
    required this.doctor,
    required this.onBookNow,
    this.onTap,
  });

  final DoctorModel doctor;
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
              color: Color(0x0C000000),
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
                          Icon(
                            doctor.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: doctor.isFavorite
                                ? const Color(0xFFFF003A)
                                : AppColors.disabled,
                            size: 20,
                          ),
                        ],
                      ),
                      3.verticalSpace,
                      Text(
                        doctor.specialty,
                        style: context.regular14Primary.copyWith(fontSize: 13),
                      ),
                      4.verticalSpace,
                      Text(
                        '${doctor.experienceYears} ${tr.yearsExperienceSuffix}',
                        style: context.regular12TextSecondary.copyWith(
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                        ),
                      ),
                      8.verticalSpace,
                      Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                            color: AppColors.primary,
                          ),
                          5.horizontalSpace,
                          Text(
                            '${doctor.ratingPercent}%',
                            style: context.medium11TextSecondary,
                          ),
                          14.horizontalSpace,
                          const Icon(
                            Icons.circle,
                            size: 8,
                            color: AppColors.primary,
                          ),
                          5.horizontalSpace,
                          Text(
                            '${doctor.patientStoriesCount} ${tr.patientStories}',
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr.nextAvailable,
                      style: context.semiBold14Primary.copyWith(fontSize: 13),
                    ),
                    3.verticalSpace,
                    Text(
                      doctor.nextAvailableTime,
                      style: context.semiBold12TextMain,
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: onBookNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(112, 38),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    tr.bookNow,
                    style: context.semiBold14White.copyWith(fontSize: 13),
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
