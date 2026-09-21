import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/features/common/bottom_navigation_bar/presentation/widgets/main_bottom_navigation_bar.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_state.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../widgets/coming_soon_view.dart';
import '../widgets/doctors_data.dart';
import '../widgets/doctors_is_empty.dart';
import '../widgets/doctors_loading.dart';
import '../widgets/home_load_error.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.user});

  /// The signed-in user, if any. Supplied by the route from the auth
  /// repository; this widget only formats display data from it.
  final User? user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  late final HomeCubit _homeCubit;
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    //CR Bad DI: Avoid checking `getIt.isRegistered` with manual fallback instantiations in UI initState.
    // solved
    //CR Use `getIt<Cubit>()` directly or inject via constructor.
    // solved
    //CR Bad DI: Avoid checking `getIt.isRegistered` with manual fallback instantiations in UI initState.
    // solved
    //CR Use `getIt<Cubit>()` directly or inject via constructor.
    // solved
    //CR Bad DI: Avoid checking `getIt.isRegistered` with manual fallback instantiations in UI initState.
    // solved
    //CR Use `getIt<Cubit>()` directly or inject via constructor.
    // solved
    _homeCubit = context.read<HomeCubit>();
    _homeCubit.load();
  }

  @override
  void dispose() {
    searchController.dispose();
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

  String _greeting(User? user) {
    final rawName = user?.displayName?.trim();
    final name = (rawName != null && rawName.isNotEmpty)
        ? rawName.split(' ').first
        : user?.email?.split('@').firstOrNull;
    return (name != null && name.isNotEmpty)
        ? tr.greetingWithName(name: name)
        : tr.greetingGeneric;
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return BlocBuilder<HomeCubit, HomeState>(
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
                        greeting: _greeting(user),
                        title: tr.findYourDoctor,
                        searchController: searchController,
                        showLanguageToggle: true,
                        showProfile: true,
                        profileImage: user?.photoURL,
                        onProfileTap: () => const ProfileRoute().push(context),
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
    );
  }
}
