import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/features/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/home/data/doctors_categories.dart';
import 'package:doctor_hunt/apps/features/home/data/service/home_firestore_service.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/doctor_category_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/featured_doctor_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/live_doctor_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/popular_doctor_section.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

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
  final _authService = AuthService();
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

  void _onNavTap(int index) {
    setState(() => selectedNavIndex = index);
    if (index == 1) {
      try {
        const FavouriteDoctorsRoute().push(context).then((_) {
          if (mounted) setState(() => selectedNavIndex = 0);
        });
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppHeaderSection(
              greeting: _authService.getUserGreeting(context),
              title: tr.findYourDoctor,
              searchController: searchController,
              showLanguageToggle: true,
              showProfile: true,
              profileImage: user?.photoURL,
              onProfileTap: () => const ProfileRoute().push(context),
            ),
            FutureBuilder<List<DoctorModel>>(
              future: _doctorsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return DoctorsLoading();
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tr.serviceError,
                            textAlign: TextAlign.center,
                            style: context.semiBold16TextMain,
                          ),
                          const SizedBox(height: 12),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _doctorsFuture = fetchHomeDoctors();
                              });
                            },
                            icon: const Icon(
                              Icons.refresh_rounded,
                              size: 28,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final doctors = snapshot.data ?? [];
                if (doctors.isEmpty) {
                  return DoctorsIsEmpty();
                }

                final liveDoctors = doctors.where((d) => d.isLive).toList()
                  ..sort((a, b) => a.liveOrder.compareTo(b.liveOrder));
                final popularDoctors =
                    doctors.where((d) => d.isPopular).toList()..sort(
                      (a, b) => a.popularOrder.compareTo(b.popularOrder),
                    );
                final featuredDoctors =
                    doctors.where((d) => d.isFeatured).toList()..sort(
                      (a, b) => a.featuredOrder.compareTo(b.featuredOrder),
                    );

                return DoctorsData(
                  liveDoctors: liveDoctors,
                  popularDoctors: popularDoctors,
                  featuredDoctors: featuredDoctors,
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
        currentIndex: selectedNavIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class DoctorsData extends StatelessWidget {
  const DoctorsData({
    super.key,
    required this.liveDoctors,
    required this.popularDoctors,
    required this.featuredDoctors,
  });

  final List<DoctorModel> liveDoctors;
  final List<DoctorModel> popularDoctors;
  final List<DoctorModel> featuredDoctors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (liveDoctors.isNotEmpty) ...[
          const SizedBox(height: 24),
          LiveDoctorSection(
            liveDoctors: liveDoctors,
            onSeeAllPressed: () => const FindDoctorsRoute().push(context),
          ),
        ],
        const SizedBox(height: 24),
        DoctorCategorySection(
          categories: categories(),
          onCategoryTap: (_) => const FindDoctorsRoute().push(context),
        ),
        if (popularDoctors.isNotEmpty) ...[
          const SizedBox(height: 24),
          PopularDoctorSection(
            doctors: popularDoctors,
            onSeeAllPressed: () => const FindDoctorsRoute().push(context),
          ),
        ],
        if (featuredDoctors.isNotEmpty) ...[
          const SizedBox(height: 24),
          FeaturedDoctorSection(
            doctors: featuredDoctors,
            onSeeAllPressed: () => const FindDoctorsRoute().push(context),
          ),
          const SizedBox(height: 32),
        ],
      ],
    );
  }
}

class DoctorsLoading extends StatelessWidget {
  const DoctorsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }
}

class DoctorsIsEmpty extends StatelessWidget {
  const DoctorsIsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Center(
        child: Text(tr.noDoctorsFound, style: context.regular14TextSecondary),
      ),
    );
  }
}
