import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/featured_doctor_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/home_state_slivers.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/live_doctor_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/popular_doctor_section.dart';

class HomeDoctorSectionsSliver extends StatelessWidget {
  const HomeDoctorSectionsSliver({
    super.key,
    required this.doctors,
    required this.onSeeAllDoctors,
  });

  final List<DoctorModel> doctors;
  final VoidCallback onSeeAllDoctors;

  @override
  Widget build(BuildContext context) {
    final liveDoctors = [...doctors.where((doctor) => doctor.isLive)]
      ..sort((a, b) => a.liveOrder.compareTo(b.liveOrder));
    final popularDoctors = [...doctors.where((doctor) => doctor.isPopular)]
      ..sort((a, b) => a.popularOrder.compareTo(b.popularOrder));
    final featuredDoctors = [...doctors.where((doctor) => doctor.isFeatured)]
      ..sort((a, b) => a.featuredOrder.compareTo(b.featuredOrder));

    return SliverMainAxisGroup(
      slivers: [
        if (liveDoctors.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: LiveDoctorSection(
                liveDoctors: liveDoctors,
                onSeeAllPressed: onSeeAllDoctors,
              ),
            ),
          ),
        HomeCategoriesSliver(onCategoryTap: onSeeAllDoctors),
        if (popularDoctors.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: PopularDoctorSection(
                doctors: popularDoctors,
                onSeeAllPressed: onSeeAllDoctors,
              ),
            ),
          ),
        if (featuredDoctors.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 32),
              child: FeaturedDoctorSection(
                doctors: featuredDoctors,
                onSeeAllPressed: onSeeAllDoctors,
              ),
            ),
          ),
      ],
    );
  }
}
