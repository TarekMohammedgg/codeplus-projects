import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/widgets/doctor_details_app_bar.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/widgets/doctor_location_map.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/widgets/doctor_services_section.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/widgets/doctor_stats_row.dart';

class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({super.key, required this.doctor});

  final DoctorModel doctor;

  void openFindDoctors(BuildContext context) {
    const FindDoctorsRoute().push(context);
  }

  void openDoctorBooking(BuildContext context) {
    SelectTimeRoute(doctor).push(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DoctorDetailsAppBar(
            onBack: () => context.pop(),
            onSearch: () => openFindDoctors(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.verticalSpace,
                  DoctorProfileCard(
                    doctor: doctor,
                    onBookNow: () => openDoctorBooking(context),
                  ),
                  24.verticalSpace,
                  DoctorStatsRow(
                    runningCount: doctor.runningCount,
                    ongoingCount: doctor.ongoingCount,
                    patientCount: doctor.patientCount,
                  ),
                  24.verticalSpace,
                  DoctorServicesSection(services: doctor.services),
                  24.verticalSpace,
                  DoctorLocationMap(location: doctor.location),
                  24.verticalSpace,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
