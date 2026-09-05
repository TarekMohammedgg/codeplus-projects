import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_search_bar.dart';
import 'package:doctor_hunt/apps/features/favourite_doctors/presentation/widgets/favourite_doctor_card.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/featured_doctor_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:doctor_hunt/apps/core/services/doctor_service.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class FavouriteDoctorsScreen extends StatefulWidget {
  const FavouriteDoctorsScreen({
    super.key,
    this.doctorService,
    this.initialFavouriteDoctors,
    this.initialFeaturedDoctors,
  });

  final DoctorService? doctorService;
  final List<DoctorModel>? initialFavouriteDoctors;
  final List<DoctorModel>? initialFeaturedDoctors;

  @override
  State<FavouriteDoctorsScreen> createState() => _FavouriteDoctorsScreenState();
}

class _FavouriteDoctorsScreenState extends State<FavouriteDoctorsScreen> {
  late final DoctorService _doctorService;
  late Future<List<DoctorModel>> _favouriteFuture;
  late Future<List<DoctorModel>> _featuredFuture;
  late Future<List<List<DoctorModel>>> _loadFuture;

  @override
  void initState() {
    super.initState();
    _doctorService = widget.doctorService ?? DoctorService();
    _favouriteFuture = widget.initialFavouriteDoctors != null
        ? Future.value(widget.initialFavouriteDoctors!)
        : _doctorService.fetchFavouriteDoctors();
    _featuredFuture = widget.initialFeaturedDoctors != null
        ? Future.value(widget.initialFeaturedDoctors!)
        : _doctorService.fetchFeaturedDoctors();
    _loadFuture = Future.wait([_favouriteFuture, _featuredFuture]);
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<List<List<DoctorModel>>>(
        future: _loadFuture,
        builder: (context, snapshot) {
          final favourites = snapshot.data?[0] ?? const [];
          final featured = snapshot.data?[1] ?? const [];

          return CustomScrollView(
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
              if (favourites.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        tr.noDoctorsFound,
                        style: context.semiBold16TextMain,
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.70,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final doctor = favourites[index];
                      return FavouriteDoctorCard(
                        doctor: doctor,
                        onTap: () => _openDoctorDetails(context, doctor),
                      );
                    }, childCount: favourites.length),
                  ),
                ),
              if (featured.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: FeaturedDoctorSection(
                      doctors: featured,
                      onSeeAllPressed: () => _openFindDoctors(context),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }
}
