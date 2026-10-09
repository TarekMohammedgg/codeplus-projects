import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_state.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../widgets/doctors_data.dart';
import '../widgets/doctors_is_empty.dart';
import '../widgets/doctors_loading.dart';
import '../widgets/home_load_error.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.user});

  final User? user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeCubit _homeCubit;

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
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppHeaderSection(
                  greeting: _greeting(user),
                  title: tr.findYourDoctor,
                  searchReadOnly: true,
                  onSearchTap: () =>
                      const FindDoctorsRoute(focus: true).push(context),
                  showLanguageToggle: true,
                  showProfile: true,
                  profileImage: user?.photoURL,
                  leading: AppIconButton(
                    icon: Icons.menu_rounded,
                    iconSize: 22,
                    iconColor: AppColors.white,
                    backgroundColor: AppColors.white.withValues(alpha: 0.2),
                    boxShadow: const [],
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).openAppDrawerTooltip,
                    onTap: () => Scaffold.of(context).openDrawer(),
                  ),
                  onProfileTap: () => const ProfileRoute().go(context),
                ),
                switch (state) {
                  HomeInitial() || HomeLoading() => const DoctorsLoading(),
                  HomeFailure() => HomeLoadError(
                    onRetry: () => context.read<HomeCubit>().load(),
                  ),
                  HomeSuccess(:final popularDoctors)
                      when popularDoctors.isEmpty =>
                    const DoctorsIsEmpty(),
                  HomeSuccess() => DoctorsData(
                    popularDoctors: state.popularDoctors,
                    topRatedDoctors: state.topRatedDoctors,
                    specialties: state.specialties,
                  ),
                },
              ],
            ),
          ),
        );
      },
    );
  }
}
