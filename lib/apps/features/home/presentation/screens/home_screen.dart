import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:doctor_hunt/apps/features/home/data/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/features/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/home/data/doctors_categories.dart';
import 'package:doctor_hunt/apps/features/home/data/skeleton_dummy_data.dart';
import 'package:doctor_hunt/apps/core/services/doctor_service.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/doctor_category_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/featured_doctor_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/live_doctor_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/popular_doctor_section.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  final _authService = AuthService();
  final _doctorService = DoctorService();
  late Future<List<DoctorModel>> _doctorsFuture;
  int selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _doctorsFuture = _doctorService.fetchHomeDoctors();
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
        const FavouriteDoctorsRoute().push<int>(context).then((selected) {
          if (mounted) {
            setState(() => selectedNavIndex = selected ?? 0);
          }
        });
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: (selectedNavIndex == 2 || selectedNavIndex == 3)
          ? const ComingSoonView()
          : SingleChildScrollView(
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
                        return const DoctorsLoading();
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
                                      _doctorsFuture = DoctorService()
                                          .fetchHomeDoctors();
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

                      final liveDoctors =
                          doctors.where((d) => d.isLive).toList()..sort(
                            (a, b) => a.liveOrder.compareTo(b.liveOrder),
                          );
                      final popularDoctors =
                          doctors.where((d) => d.isPopular).toList()..sort(
                            (a, b) => a.popularOrder.compareTo(b.popularOrder),
                          );
                      final featuredDoctors =
                          doctors.where((d) => d.isFeatured).toList()..sort(
                            (a, b) =>
                                a.featuredOrder.compareTo(b.featuredOrder),
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
    this.categoriesList,
  });

  final List<DoctorModel> liveDoctors;
  final List<DoctorModel> popularDoctors;
  final List<DoctorModel> featuredDoctors;
  final List<DoctorCategoryItem>? categoriesList;

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
          categories: categoriesList ?? categories(),
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
    return const Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: Color(0xFFD6D9DE),
        highlightColor: Color(0xFFF5F6F8),
        duration: Duration(milliseconds: 1400),
      ),
      containersColor: Color(0xFFE4E7EB),
      child: DoctorsData(
        liveDoctors: dummySkeletonDoctors,
        popularDoctors: dummySkeletonDoctors,
        featuredDoctors: dummySkeletonDoctors,
        categoriesList: dummySkeletonCategories,
      ),
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

class ComingSoonView extends StatelessWidget {
  const ComingSoonView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: AppColors.white,
        child: Center(
          child: Text(tr.comingSoon, style: context.semiBold18TextMain),
        ),
      ),
    );
  }
}
