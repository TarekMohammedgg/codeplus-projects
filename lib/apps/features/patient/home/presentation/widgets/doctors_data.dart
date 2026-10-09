import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/doctor_sort.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/widgets/doctor_category_section.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/widgets/popular_doctor_section.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class DoctorsData extends StatelessWidget {
  const DoctorsData({
    super.key,
    required this.popularDoctors,
    required this.topRatedDoctors,
    required this.specialties,
  });

  final List<DoctorModel> popularDoctors;
  final List<DoctorModel> topRatedDoctors;
  final List<SpecialtyModel> specialties;

  @override
  Widget build(BuildContext context) {
    final favoriteIds = context.watch<FavoritesCubit>().state.doctorIds;
    void toggleFavorite(DoctorModel doctor) =>
        context.read<FavoritesCubit>().toggle(doctor.id);

    return Column(
      children: [
        const SizedBox(height: 24),
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
          onCategoryTap: (category) =>
              FindDoctorsRoute(specialtyId: category.id).push(context),
        ),
        const SizedBox(height: 24),
        DoctorsSection(
          title: tr.popularDoctor,
          doctors: popularDoctors,
          favoriteIds: favoriteIds,
          onFavoriteTap: toggleFavorite,
          onSeeAllPressed: () =>
              const FindDoctorsRoute(sort: DoctorSort.popular).push(context),
        ),
        const SizedBox(height: 24),
        DoctorsSection(
          title: tr.topRatedDoctors,
          doctors: topRatedDoctors,
          favoriteIds: favoriteIds,
          onFavoriteTap: toggleFavorite,
          onSeeAllPressed: () =>
              const FindDoctorsRoute(sort: DoctorSort.topRated).push(context),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
