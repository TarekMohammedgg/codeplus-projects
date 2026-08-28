import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/apps/core/data/doctors_data.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_search_bar.dart';
import 'package:doctor_hunt/apps/features/favourite_doctors/presentation/widgets/favourite_doctor_card.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/featured_doctor_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class FavouriteDoctorsScreen extends StatelessWidget {
  const FavouriteDoctorsScreen({super.key});

  void _openDoctorDetails(BuildContext context, DoctorModel doctor) {
    DoctorDetailsRoute(doctor).push(context);
  }

  void _openFindDoctors(BuildContext context) {
    const FindDoctorsRoute().push(context);
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == 0) {
      if (context.canPop()) {
        context.pop();
      } else {
        const HomeRoute().go(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctors = favouriteDoctors();

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
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.70,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final doctor = doctors[index];
                return FavouriteDoctorCard(
                  doctor: doctor,
                  onTap: () => _openDoctorDetails(context, doctor),
                );
              }, childCount: doctors.length),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: FeaturedDoctorSection(
                doctors: featuredDoctors(),
                onSeeAllPressed: () => _openFindDoctors(context),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }
}
