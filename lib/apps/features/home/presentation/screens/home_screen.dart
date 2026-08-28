import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/features/home/data/service/home_firestore_service.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/home_doctor_sections_sliver.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/home_header_sliver.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/home_state_slivers.dart';

// Export widgets for clean consumption and tests
export 'package:doctor_hunt/apps/features/home/presentation/widgets/doctor_category_section.dart';
export 'package:doctor_hunt/apps/features/home/presentation/widgets/featured_doctor_section.dart';
export 'package:doctor_hunt/apps/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
export 'package:doctor_hunt/apps/features/home/presentation/widgets/home_doctor_sections_sliver.dart';
export 'package:doctor_hunt/apps/features/home/presentation/widgets/home_header_sliver.dart';
export 'package:doctor_hunt/apps/features/home/presentation/widgets/home_state_slivers.dart';
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
  late Future<List<DoctorModel>> _doctorsFuture;
  int selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _doctorsFuture = fetchHomeDoctors();
  }

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

  void openProfile() {
    const ProfileRoute().push(context);
  }

  void retryLoadingDoctors() {
    setState(() {
      _doctorsFuture = fetchHomeDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<List<DoctorModel>>(
        future: _doctorsFuture,
        builder: (context, snapshot) {
          return CustomScrollView(
            slivers: [
              HomeHeaderSliver(
                searchController: searchController,
                onProfileTap: openProfile,
              ),
              ..._buildDoctorSlivers(snapshot),
            ],
          );
        },
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
        currentIndex: selectedNavIndex,
        onTap: selectNav,
      ),
    );
  }

  List<Widget> _buildDoctorSlivers(AsyncSnapshot<List<DoctorModel>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const [HomeLoadingSliver()];
    }

    if (snapshot.hasError) {
      return [HomeErrorSliver(onRetry: retryLoadingDoctors)];
    }

    final doctors = snapshot.data ?? const [];
    if (doctors.isEmpty) {
      return [
        const HomeEmptySliver(),
        HomeCategoriesSliver(onCategoryTap: openFindDoctors),
      ];
    }

    return [
      HomeDoctorSectionsSliver(
        doctors: doctors,
        onSeeAllDoctors: openFindDoctors,
      ),
    ];
  }
}
