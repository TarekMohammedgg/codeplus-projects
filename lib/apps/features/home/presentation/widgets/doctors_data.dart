import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/features/home/data/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/doctor_category_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/featured_doctor_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/live_doctor_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/popular_doctor_section.dart';
import 'package:doctor_hunt/apps/features/specialty/data/models/specialty_model.dart';
import 'package:flutter/material.dart';

class DoctorsData extends StatelessWidget {
  const DoctorsData({
    super.key,
    required this.doctors,
    required this.specialties,
  });

  final List<DoctorModel> doctors;
  final List<SpecialtyModel> specialties;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        if (doctors.isNotEmpty) ...[
          LiveDoctorSection(
            liveDoctors: doctors,
            onSeeAllPressed: () => const FindDoctorsRoute().push(context),
          ),
          const SizedBox(height: 24),
        ],
        DoctorCategorySection(
          categories: specialties
              .map(
                (specialty) => DoctorCategoryItem(
                  id: specialty.id,
                  name: specialty.localizedName,
                  icon: specialty.icon,
                  primaryColor: AppColors.primary,
                  secondaryColor: AppColors.primaryLight,
                ),
              )
              .toList(),
          onCategoryTap: (_) => const FindDoctorsRoute().push(context),
        ),
        if (doctors.isNotEmpty) ...[
          const SizedBox(height: 24),
          PopularDoctorSection(
            doctors: doctors,
            onSeeAllPressed: () => const FindDoctorsRoute().push(context),
          ),
          const SizedBox(height: 24),
          FeaturedDoctorSection(
            doctors: doctors,
            onSeeAllPressed: () => const FindDoctorsRoute().push(context),
          ),
          const SizedBox(height: 32),
        ],
      ],
    );
  }
}
