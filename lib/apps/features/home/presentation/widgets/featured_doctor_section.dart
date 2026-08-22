import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/features/doctors/data/doctors_data.dart';
import 'package:doctor_hunt/apps/features/doctors/data/models/doctor_detail_args.dart';
import 'package:doctor_hunt/apps/features/home/data/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/section_header.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class FeaturedDoctorSection extends StatelessWidget {
  const FeaturedDoctorSection({
    super.key,
    required this.doctors,
    required this.onSeeAllPressed,
  });

  final List<FeaturedDoctorItem> doctors;
  final VoidCallback onSeeAllPressed;

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: t.featuredDoctor,
          onSeeAllPressed: onSeeAllPressed,
        ),
        14.verticalSpace,
        SizedBox(
          height: 195,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: doctors.length,
            separatorBuilder: (context, index) => 14.horizontalSpace,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return FeaturedDoctorCard(
                doctor: doctor,
                onTap: () => DoctorDetailsRoute(
                  DoctorDetailArgs(
                    id: doctor.id,
                    name: doctor.name,
                    specialty: doctor.specialty,
                    image: doctor.image,
                    rating: doctor.rating,
                    hourlyRate: doctor.hourlyRate,
                    isFavorite: doctor.isFavorite,
                    services: defaultServices(t),
                  ),
                ).push(context),
              );
            },
          ),
        ),
      ],
    );
  }
}

class FeaturedDoctorCard extends StatelessWidget {
  const FeaturedDoctorCard({super.key, required this.doctor, this.onTap});

  final FeaturedDoctorItem doctor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.6)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFB800),
                      size: 14,
                    ),
                    2.horizontalSpace,
                    Text(
                      doctor.rating.toStringAsFixed(1),
                      style: context.semiBold11TextMain,
                    ),
                  ],
                ),
                Icon(
                  doctor.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: doctor.isFavorite
                      ? AppColors.error
                      : AppColors.disabled,
                  size: 16,
                ),
              ],
            ),
            8.verticalSpace,
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: doctor.accentColor.withValues(alpha: 0.15),
              ),
              child: ClipOval(
                child: doctor.image != null
                    ? Image.asset(
                        doctor.image!,
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                      )
                    : const SizedBox(),
              ),
            ),
            8.verticalSpace,
            Text(
              doctor.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.bold14TextMain.copyWith(fontSize: 13),
            ),
            2.verticalSpace,
            Text(
              doctor.specialty,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.regular11TextSub.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.8),
              ),
            ),
            6.verticalSpace,
            Text(
              '\$${doctor.hourlyRate.toStringAsFixed(2)}${t.perHour}',
              style: context.bold12Primary,
            ),
          ],
        ),
      ),
    );
  }
}
