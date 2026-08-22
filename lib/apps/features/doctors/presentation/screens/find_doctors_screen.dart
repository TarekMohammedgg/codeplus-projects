import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_search_bar.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/features/doctors/data/doctors_data.dart';
import 'package:doctor_hunt/apps/features/doctors/data/models/doctor_detail_args.dart';
import 'package:doctor_hunt/apps/features/doctors/data/models/find_doctor_model.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class FindDoctorsScreen extends StatelessWidget {
  const FindDoctorsScreen({super.key});

  void onBookDoctor(BuildContext context, FindDoctorItem doctor) {
    context.showSuccessSnackBar(context.t.bookingMessage(name: doctor.name));
  }

  void onDoctorTap(BuildContext context, FindDoctorItem doctor) {
    DoctorDetailsRoute(
      DoctorDetailArgs(
        id: doctor.id,
        name: doctor.name,
        specialty: doctor.specialty,
        image: doctor.image,
        isFavorite: doctor.isFavorite,
        services: defaultServices(context.t),
      ),
    ).push(context);
  }

  @override
  Widget build(BuildContext context) {
    final doctorsList = doctors(context.t);

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
        Text(context.t.findDoctors, style: context.bold18TextMain),
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

  final FindDoctorItem doctor;
  final VoidCallback onBookNow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.t;

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
                  child: doctor.image != null
                      ? Image.asset(
                          doctor.image!,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const DoctorAvatarPlaceholder(
                                size: 90,
                                circle: false,
                              ),
                        )
                      : const DoctorAvatarPlaceholder(size: 90, circle: false),
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
                        '${doctor.experienceYears} ${t.yearsExperienceSuffix}',
                        style: context.regular12TextSub.copyWith(
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                        ),
                      ),
                      8.verticalSpace,
                      Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                            color: AppColors.primaryGreen,
                          ),
                          5.horizontalSpace,
                          Text(
                            '${doctor.ratingPercent}%',
                            style: context.medium11TextSub,
                          ),
                          14.horizontalSpace,
                          const Icon(
                            Icons.circle,
                            size: 8,
                            color: AppColors.primaryGreen,
                          ),
                          5.horizontalSpace,
                          Text(
                            '${doctor.patientStoriesCount} ${t.patientStories}',
                            style: context.medium11TextSub,
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
                      t.nextAvailable,
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
                    backgroundColor: AppColors.primaryGreen,
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
                    t.bookNow,
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
