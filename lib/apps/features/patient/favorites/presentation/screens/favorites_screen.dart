import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_empty_state.dart';
import 'package:doctor_hunt/apps/core/widgets/app_list_skeleton.dart';
import 'package:doctor_hunt/apps/core/widgets/app_search_bar.dart';
import 'package:doctor_hunt/apps/core/widgets/skeleton_placeholders.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_state.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/widgets/find_doctors_widgets.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            16.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                context.tr.tabFavorites,
                style: context.bold18TextMain,
              ),
            ),
            16.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AppSearchBar(
                onChanged: context.read<FindDoctorsCubit>().search,
              ),
            ),
            14.verticalSpace,
            Expanded(
              child: BlocBuilder<FindDoctorsCubit, FindDoctorsState>(
                builder: (context, state) => switch (state) {
                  FindDoctorsInitial() ||
                  FindDoctorsLoading() => AppListSkeleton(
                    padding: const EdgeInsets.fromLTRB(24, 6, 24, 32),
                    spacing: 14,
                    itemBuilder: (_) => FindDoctorCard(
                      doctor: skeletonDoctor(),
                      isFavorite: false,
                      onFavoriteTap: () {},
                      onBookNow: () {},
                    ),
                  ),
                  FindDoctorsFailure() => Center(
                    child: Text(
                      context.tr.serviceError,
                      style: context.semiBold16TextMain,
                    ),
                  ),
                  FindDoctorsSuccess() => _FavoriteDoctorsList(state: state),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteDoctorsList extends StatelessWidget {
  const _FavoriteDoctorsList({required this.state});

  final FindDoctorsSuccess state;

  @override
  Widget build(BuildContext context) {
    final favoriteIds = context.watch<FavoritesCubit>().state.doctorIds;
    final doctors = visibleDoctors(state, favoriteIds);

    if (doctors.isEmpty) {
      return AppEmptyState(
        image: const Icon(
          Icons.favorite_border_rounded,
          size: 64,
          color: AppColors.disabled,
        ),
        title: context.tr.noFavoritesFound,
        titleStyle: context.semiBold16TextMain,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 6, 24, 32),
      itemCount: doctors.length,
      separatorBuilder: (_, _) => 14.verticalSpace,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return FindDoctorCard(
          doctor: doctor,
          isFavorite: true,
          onFavoriteTap: () => context.read<FavoritesCubit>().toggle(doctor.id),
          onBookNow: () => SelectTimeRoute(doctor).push(context),
          onTap: () => DoctorDetailsRoute(doctor).push(context),
        );
      },
    );
  }
}
