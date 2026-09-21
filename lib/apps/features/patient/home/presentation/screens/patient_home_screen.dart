import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/service/home_service.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/common/bottom_navigation_bar/presentation/widgets/main_bottom_navigation_bar.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/repositories/home_repository.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_state.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../widgets/coming_soon_view.dart';
import '../widgets/doctors_data.dart';
import '../widgets/doctors_is_empty.dart';
import '../widgets/doctors_loading.dart';
import '../widgets/home_load_error.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.repository});

  final HomeRepository? repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  late final AuthService _authService;
  late final HomeCubit _homeCubit;
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    //CR Bad DI: Avoid checking `getIt.isRegistered` with manual fallback instantiations in UI initState.
    //CR Use `getIt<Cubit>()` directly or inject via constructor.
    _authService = getIt.isRegistered<AuthService>()
        ? getIt<AuthService>()
        : AuthService();
    _homeCubit = widget.repository != null
        ? HomeCubit(repository: widget.repository!)
    //CR Bad DI: Avoid checking `getIt.isRegistered` with manual fallback instantiations in UI initState.
    //CR Use `getIt<Cubit>()` directly or inject via constructor.
        : (getIt.isRegistered<HomeCubit>()
              ? getIt<HomeCubit>()
              : HomeCubit(
    //CR Bad DI: Avoid checking `getIt.isRegistered` with manual fallback instantiations in UI initState.
    //CR Use `getIt<Cubit>()` directly or inject via constructor.
                  repository: getIt.isRegistered<HomeRepository>()
                      ? getIt<HomeRepository>()
                      : FirebaseHomeRepository(
                          homeService: HomeService(),
                          specialtyService: SpecialtyService(),
                        ),
                ));
    _homeCubit.load();
  }

  @override
  void dispose() {
    searchController.dispose();
    _homeCubit.close();
    super.dispose();
  }

  void _onNavTap(BuildContext context, int index) {
    setState(() => _selectedNavIndex = index);
    if (index == 1) {
      const FavouriteDoctorsRoute().push<int>(context).then((selected) {
        if (mounted) {
          setState(() => _selectedNavIndex = selected ?? 0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return BlocProvider.value(
      value: _homeCubit,
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: (_selectedNavIndex == 2 || _selectedNavIndex == 3)
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
                          onProfileTap: () =>
                              const ProfileRoute().push(context),
                        ),
                        switch (state) {
                          HomeInitial() ||
                          HomeLoading() => const DoctorsLoading(),
                          HomeFailure() => HomeLoadError(
                            onRetry: () => context.read<HomeCubit>().load(),
                          ),
                          HomeSuccess(:final doctors) when doctors.isEmpty =>
                            const DoctorsIsEmpty(),
                          HomeSuccess(:final doctors, :final specialties) =>
                            DoctorsData(
                              doctors: doctors,
                              specialties: specialties,
                            ),
                        },
                      ],
                    ),
                  ),
            bottomNavigationBar: MainBottomNavigationBar(
              currentIndex: _selectedNavIndex,
              onTap: (index) => _onNavTap(context, index),
            ),
          );
        },
      ),
    );
  }
}
