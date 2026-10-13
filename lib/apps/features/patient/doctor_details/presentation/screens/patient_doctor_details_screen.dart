import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/controller/cubit/doctor_details_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/controller/cubit/doctor_details_state.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/widgets/doctor_details_app_bar.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/widgets/doctor_details_sections.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:doctor_hunt/apps/core/widgets/skeleton_placeholders.dart';

class DoctorDetailsScreen extends StatefulWidget {
  const DoctorDetailsScreen({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorDetailsCubit>().load(widget.doctor.id);
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
    final isFavorite = context.select<FavoritesCubit, bool>(
      (cubit) => cubit.state.isFavorite(doctor.id),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          DoctorDetailsAppBar(
            onBack: () => context.pop(),
            onSearch: () => const FindDoctorsRoute().go(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoctorProfileCard(
                    doctor: doctor,
                    isFavorite: isFavorite,
                    onFavoriteToggle: () =>
                        context.read<FavoritesCubit>().toggle(doctor.id),
                    onBookNow: () => SelectTimeRoute(doctor).push(context),
                  ),
                  20.verticalSpace,
                  DoctorRatingSummary(doctor: doctor),
                  24.verticalSpace,
                  BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
                    builder: (context, state) => switch (state) {
                      DoctorDetailsInitial() ||
                      DoctorDetailsLoading() => Skeletonizer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RecentReviewsSection(
                              reviews: [skeletonReview(), skeletonReview()],
                            ),
                            24.verticalSpace,
                            const ClinicLocationSection(clinic: null),
                          ],
                        ),
                      ),
                      DoctorDetailsFailure() => Center(
                        child: Text(
                          context.tr.serviceError,
                          style: context.regular14TextSecondary,
                        ),
                      ),
                      DoctorDetailsSuccess(:final reviews, :final clinic) =>
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RecentReviewsSection(reviews: reviews),
                            24.verticalSpace,
                            ClinicLocationSection(clinic: clinic),
                          ],
                        ),
                    },
                  ),
                  AvailableSlotsSection(doctor: doctor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
