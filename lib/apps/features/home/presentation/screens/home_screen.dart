import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/features/home/data/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/core/services/doctor_service.dart';
import 'package:doctor_hunt/apps/features/specialty/data/models/specialty_model.dart';
import 'package:doctor_hunt/apps/features/specialty/data/service/specialty_service.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/doctor_category_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
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
  final _specialtyService = SpecialtyService();
  late Future<List<DoctorModel>> _doctorsFuture;
  late Future<List<SpecialtyModel>> _specialtiesFuture;
  int selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _doctorsFuture = _doctorService.fetchDoctors();
    _specialtiesFuture = _specialtyService.fetchActiveSpecialties();
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
                                          .fetchDoctors();
                                      _specialtiesFuture = SpecialtyService()
                                          .fetchActiveSpecialties();
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
                      return FutureBuilder<List<SpecialtyModel>>(
                        future: _specialtiesFuture,
                        builder: (context, specialtiesSnapshot) {
                          return DoctorsData(
                            doctors: doctors,
                            specialties: specialtiesSnapshot.data ?? const [],
                          );
                        },
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
    required this.doctors,
    required this.specialties,
  });

  final List<DoctorModel> doctors;
  final List<SpecialtyModel> specialties;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        DoctorCategorySection(
          categories: specialties
              .map(
                (specialty) => DoctorCategoryItem(
                  id: specialty.id,
                  name: specialty.localizedName,
                  icon: specialty.icon,
                  primaryColor: AppColors.primary,
                  secondaryColor: AppColors.primaryLight,
                ),
              )
              .toList(),
          onCategoryTap: (_) => const FindDoctorsRoute().push(context),
        ),
        if (doctors.isNotEmpty) ...[
          const SizedBox(height: 24),
          PopularDoctorSection(
            doctors: doctors,
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
    return const SizedBox(
      height: 360,
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
