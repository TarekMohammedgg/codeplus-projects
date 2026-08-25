import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/features/home/data/doctors_home_data.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/doctor_category_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/featured_doctor_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/live_doctor_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/popular_doctor_section.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

// Export section widgets for clean consumption and tests
export 'package:doctor_hunt/apps/features/home/presentation/widgets/doctor_category_section.dart';
export 'package:doctor_hunt/apps/features/home/presentation/widgets/featured_doctor_section.dart';
export 'package:doctor_hunt/apps/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
export 'package:doctor_hunt/apps/features/home/presentation/widgets/live_doctor_section.dart';
export 'package:doctor_hunt/apps/features/home/presentation/widgets/popular_doctor_section.dart';
export 'package:doctor_hunt/apps/features/home/presentation/widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  int selectedNavIndex = 0;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void selectNav(int index) {
    setState(() {
      selectedNavIndex = index;
    });
    if (index == 1) {
      try {
        const FavouriteDoctorsRoute().push(context).then((_) {
          if (mounted) {
            setState(() {
              selectedNavIndex = 0;
            });
          }
        });
      } catch (_) {}
    }
  }

  void openFindDoctors() {
    searchController.clear();
    FocusManager.instance.primaryFocus?.unfocus();

    const FindDoctorsRoute().push(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AppHeaderSection(
              greeting: tr.hiSteven,
              title: tr.findYourDoctor,
              searchController: searchController,
              showLanguageToggle: true,
              profileImage: Assets.assetsDummyProfileImage,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: LiveDoctorSection(
                liveDoctors: liveDoctors(),
                onSeeAllPressed: openFindDoctors,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: DoctorCategorySection(
                categories: categories(),
                onCategoryTap: (_) => openFindDoctors(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: PopularDoctorSection(
                doctors: popularDoctors(),
                onSeeAllPressed: openFindDoctors,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 32),
              child: FeaturedDoctorSection(
                doctors: featuredDoctors(),
                onSeeAllPressed: openFindDoctors,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
        currentIndex: selectedNavIndex,
        onTap: selectNav,
      ),
    );
  }
}
