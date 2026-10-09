import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_search_bar.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorite_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorite_doctors_state.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/widgets/find_doctors_widgets.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/apps/core/widgets/app_list_skeleton.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FavoriteDoctorsCubit>().load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FavoriteDoctorsCubit>();
    return BlocBuilder<FavoriteDoctorsCubit, FavoriteDoctorsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                16.verticalSpace,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.tr.tabFavorites,
                          style: context.bold18TextMain,
                        ),
                      ),
                    ],
                  ),
                ),
                16.verticalSpace,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AppSearchBar(
                    controller: _searchController,
                    onChanged: cubit.search,
                  ),
                ),
                14.verticalSpace,
                Expanded(child: _buildContent(context, state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, FavoriteDoctorsState state) {
    return switch (state) {
      FavoriteDoctorsInitial() || FavoriteDoctorsLoading() => AppListSkeleton(
        padding: const EdgeInsets.fromLTRB(24, 6, 24, 32),
        spacing: 14,
        itemBuilder: (_) => FindDoctorCard(
          doctor: DoctorModel.placeholder(),
          isFavorite: false,
          onFavoriteTap: () {},
          onBookNow: () {},
        ),
      ),
      FavoriteDoctorsFailure() => Center(
        child: Text(context.tr.serviceError, style: context.semiBold16TextMain),
      ),
      FavoriteDoctorsSuccess() => _FavoriteDoctorsList(state: state),
    };
  }
}

class _FavoriteDoctorsList extends StatelessWidget {
  const _FavoriteDoctorsList({required this.state});

  final FavoriteDoctorsSuccess state;

  @override
  Widget build(BuildContext context) {
    final favoriteIds = context.watch<FavoritesCubit>().state.doctorIds;
    final doctors = visibleFavoriteDoctors(state, favoriteIds);

    if (doctors.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_border_rounded,
              size: 64,
              color: AppColors.disabled,
            ),
            16.verticalSpace,
            Text(
              context.tr.noFavoritesFound,
              style: context.semiBold16TextMain,
            ),
          ],
        ),
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
