import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/doctor_sort.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_search_bar.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_filter_chips.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_state.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/widgets/find_doctors_widgets.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/apps/core/widgets/app_list_skeleton.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';

class FindDoctorsScreen extends StatefulWidget {
  const FindDoctorsScreen({super.key, this.query, this.specialtyId, this.sort});

  /// Initial filters from the route query (e.g. Home's search, chips, See All).
  final String? query;
  final String? specialtyId;
  final DoctorSort? sort;

  @override
  State<FindDoctorsScreen> createState() => _FindDoctorsScreenState();
}

class _FindDoctorsScreenState extends State<FindDoctorsScreen> {
  late final TextEditingController _searchController = TextEditingController(
    text: widget.query,
  );

  @override
  void initState() {
    super.initState();
    context.read<FindDoctorsCubit>().load(
      query: widget.query,
      specialtyId: widget.specialtyId,
      sort: widget.sort,
    );
  }

  @override
  void didUpdateWidget(covariant FindDoctorsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The tab stays alive, so new route params arrive here, not in initState.
    if (widget.query != oldWidget.query ||
        widget.specialtyId != oldWidget.specialtyId ||
        widget.sort != oldWidget.sort) {
      _searchController.text = widget.query ?? '';
      context.read<FindDoctorsCubit>().applyRouteFilters(
        query: widget.query,
        specialtyId: widget.specialtyId,
        sort: widget.sort,
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      const HomeRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FindDoctorsCubit>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBack(context);
      },
      child: BlocBuilder<FindDoctorsCubit, FindDoctorsState>(
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
                        AppIconButton.back(onTap: () => _handleBack(context)),
                        12.horizontalSpace,
                        Expanded(
                          child: Text(
                            context.tr.findDoctors,
                            style: context.bold18TextMain,
                          ),
                        ),
                        if (state is FindDoctorsSuccess)
                          DoctorSortMenu(
                            sort: state.sort,
                            onSelected: cubit.sortBy,
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
                  if (state is FindDoctorsSuccess) ...[
                    14.verticalSpace,
                    DoctorFilterChips(
                      specialties: state.specialties,
                      selectedSpecialtyId: state.specialtyId,
                      onSpecialtySelected: cubit.selectSpecialty,
                    ),
                  ],
                  14.verticalSpace,
                  Expanded(child: _buildDoctorsContent(context, state)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctorsContent(BuildContext context, FindDoctorsState state) {
    return switch (state) {
      FindDoctorsInitial() || FindDoctorsLoading() => AppListSkeleton(
        padding: const EdgeInsets.fromLTRB(24, 6, 24, 32),
        spacing: 14,
        itemBuilder: (_) => FindDoctorCard(
          doctor: DoctorModel.placeholder(),
          isFavorite: false,
          onFavoriteTap: () {},
          onBookNow: () {},
        ),
      ),
      FindDoctorsFailure() => Center(
        child: Text(context.tr.serviceError, style: context.semiBold16TextMain),
      ),
      FindDoctorsSuccess() => _DoctorsList(state: state),
    };
  }
}

class _DoctorsList extends StatelessWidget {
  const _DoctorsList({required this.state});

  final FindDoctorsSuccess state;

  @override
  Widget build(BuildContext context) {
    final favoriteIds = context.watch<FavoritesCubit>().state.doctorIds;
    final doctors = visibleDoctors(state, favoriteIds);
    if (doctors.isEmpty) {
      return Center(
        child: Text(
          context.tr.noDoctorsFound,
          style: context.semiBold16TextMain,
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
          isFavorite: favoriteIds.contains(doctor.id),
          onFavoriteTap: () => context.read<FavoritesCubit>().toggle(doctor.id),
          onBookNow: () => SelectTimeRoute(doctor).push(context),
          onTap: () => DoctorDetailsRoute(doctor).push(context),
        );
      },
    );
  }
}
