import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_search_bar.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/presentation/widgets/favourite_doctor_card.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/widgets/featured_doctor_section.dart';
import 'package:doctor_hunt/apps/features/common/bottom_navigation_bar/presentation/widgets/main_bottom_navigation_bar.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/data/service/favourite_doctors_service.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/data/repositories/favourite_doctors_repository.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/presentation/controller/cubit/favourite_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/presentation/controller/cubit/favourite_doctors_state.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class FavouriteDoctorsScreen extends StatefulWidget {
  const FavouriteDoctorsScreen({
    super.key,
    this.doctorService,
    this.repository,
    this.initialFavouriteDoctors,
    this.initialFeaturedDoctors,
  });

  final FavouriteDoctorsService? doctorService;
  final FavouriteDoctorsRepository? repository;
  final List<DoctorModel>? initialFavouriteDoctors;
  final List<DoctorModel>? initialFeaturedDoctors;

  @override
  State<FavouriteDoctorsScreen> createState() => _FavouriteDoctorsScreenState();
}

class _FavouriteDoctorsScreenState extends State<FavouriteDoctorsScreen> {
  late final FavouriteDoctorsCubit _favouriteDoctorsCubit;

  @override
  void initState() {
    super.initState();
    _favouriteDoctorsCubit =
        (widget.repository != null || widget.doctorService != null)
        ? FavouriteDoctorsCubit(
            repository:
                widget.repository ??
                FirebaseFavouriteDoctorsRepository(
                  favouriteDoctorsService:
                      widget.doctorService ?? FavouriteDoctorsService(),
                ),
          )
    //CR Bad DI: Avoid checking `getIt.isRegistered` with manual fallback instantiations in UI initState.
    //CR Use `getIt<Cubit>()` directly or inject via constructor.
        : (getIt.isRegistered<FavouriteDoctorsCubit>()
              ? getIt<FavouriteDoctorsCubit>()
              : FavouriteDoctorsCubit(
    //CR Bad DI: Avoid checking `getIt.isRegistered` with manual fallback instantiations in UI initState.
    //CR Use `getIt<Cubit>()` directly or inject via constructor.
                  repository: getIt.isRegistered<FavouriteDoctorsRepository>()
                      ? getIt<FavouriteDoctorsRepository>()
                      : FirebaseFavouriteDoctorsRepository(
                          favouriteDoctorsService: FavouriteDoctorsService(),
                        ),
                ));
    _favouriteDoctorsCubit.load(
      initialFavouriteDoctors: widget.initialFavouriteDoctors,
      initialFeaturedDoctors: widget.initialFeaturedDoctors,
    );
  }

  @override
  void dispose() {
    _favouriteDoctorsCubit.close();
    super.dispose();
  }

  void _openDoctorDetails(BuildContext context, DoctorModel doctor) {
    DoctorDetailsRoute(doctor).push(context);
  }

  void _openFindDoctors(BuildContext context) {
    const FindDoctorsRoute().push(context);
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == 0 || index == 2 || index == 3) {
      if (context.canPop()) {
        context.pop(index);
      } else {
        const HomeRoute().go(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _favouriteDoctorsCubit,
      child: BlocBuilder<FavouriteDoctorsCubit, FavouriteDoctorsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
                    child: Row(
                      children: [
                        AppIconButton(
                          onTap: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              const HomeRoute().go(context);
                            }
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        16.horizontalSpace,
                        Expanded(
                          child: Text(
                            tr.favouriteDoctors,
                            style: context.bold18TextMain,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: AppSearchBar(),
                  ),
                ),
                ..._buildContentSlivers(context, state),
              ],
            ),
            bottomNavigationBar: MainBottomNavigationBar(
              currentIndex: 1,
              onTap: (index) => _onNavTap(context, index),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildContentSlivers(
    BuildContext context,
    FavouriteDoctorsState state,
  ) {
    switch (state) {
      case FavouriteDoctorsInitial():
      case FavouriteDoctorsLoading():
        return [
          SliverSkeletonizer(
            child: SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.70,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, _) => DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: Bone.circle(size: 20),
                          ),
                          SizedBox(height: 10),
                          Bone.circle(size: 70),
                          SizedBox(height: 12),
                          Bone.text(words: 2),
                          SizedBox(height: 8),
                          Bone.text(words: 2),
                          SizedBox(height: 10),
                          Bone.text(words: 1),
                        ],
                      ),
                    ),
                  ),
                  childCount: 4,
                ),
              ),
            ),
          ),
        ];
      case FavouriteDoctorsFailure():
        return [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(tr.serviceError, style: context.semiBold16TextMain),
            ),
          ),
        ];
      case FavouriteDoctorsSuccess(
        :final favouriteDoctors,
        :final featuredDoctors,
      ):
        return _buildSuccessSlivers(
          context,
          favouriteDoctors: favouriteDoctors,
          featuredDoctors: featuredDoctors,
        );
    }
  }

  List<Widget> _buildSuccessSlivers(
    BuildContext context, {
    required List<DoctorModel> favouriteDoctors,
    required List<DoctorModel> featuredDoctors,
  }) {
    return [
      if (favouriteDoctors.isEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(tr.noDoctorsFound, style: context.semiBold16TextMain),
            ),
          ),
        )
      else
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.70,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final doctor = favouriteDoctors[index];
                return FavouriteDoctorCard(
                  doctor: doctor,
                  onTap: () => _openDoctorDetails(context, doctor),
                );
              },
              childCount: favouriteDoctors.length > 4
                  ? 4
                  : favouriteDoctors.length,
            ),
          ),
        ),
      if (featuredDoctors.isNotEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: FeaturedDoctorSection(
              doctors: featuredDoctors,
              onSeeAllPressed: () => _openFindDoctors(context),
            ),
          ),
        ),
    ];
  }
}
