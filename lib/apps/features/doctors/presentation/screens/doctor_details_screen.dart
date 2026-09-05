import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';

import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({super.key, required this.doctor});

  final DoctorModel doctor;

  void openFindDoctors(BuildContext context) {
    const FindDoctorsRoute().push(context);
  }

  void openSelectTime(BuildContext context) {
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
                    onBookNow: () => openSelectTime(context),
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

class DoctorDetailsAppBar extends StatelessWidget {
  const DoctorDetailsAppBar({
    super.key,
    required this.onBack,
    required this.onSearch,
  });

  final VoidCallback onBack;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppIconButton(
            onTap: onBack,
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ),
          Text(tr.doctorDetails, style: context.bold18TextMain),
          AppIconButton(
            onTap: onSearch,
            child: const Icon(
              Icons.search_rounded,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorStatsRow extends StatelessWidget {
  const DoctorStatsRow({
    super.key,
    required this.runningCount,
    required this.ongoingCount,
    required this.patientCount,
  });

  final int runningCount;
  final int ongoingCount;
  final int patientCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: DoctorStatItem(count: runningCount, label: tr.statRunning),
            ),
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: AppColors.outline,
            ),
            Expanded(
              child: DoctorStatItem(count: ongoingCount, label: tr.statOngoing),
            ),
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: AppColors.outline,
            ),
            Expanded(
              child: DoctorStatItem(count: patientCount, label: tr.statPatient),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorStatItem extends StatelessWidget {
  const DoctorStatItem({super.key, required this.count, required this.label});

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(count.toString(), style: context.bold20TextMain),
        4.verticalSpace,
        Text(
          label,
          style: context.regular14TextSecondary.copyWith(
            fontSize: 13,
            color: AppColors.textSecondary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class DoctorServicesSection extends StatelessWidget {
  const DoctorServicesSection({super.key, required this.services});

  final List<String> services;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr.services, style: context.bold18TextMain),
        16.verticalSpace,
        ...List.generate(services.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text('${index + 1}', style: context.bold12Primary),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Text(
                    services[index],
                    style: context.regular14TextSecondary.copyWith(
                      color: AppColors.textSecondary.withValues(alpha: 0.9),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class DoctorLocationMap extends StatelessWidget {
  const DoctorLocationMap({super.key, this.location});

  final LatLng? location;

  @override
  Widget build(BuildContext context) {
    final targetLocation = location ?? DoctorModel.defaultLocation;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 180,
        width: double.infinity,
        color: const Color(0xFFE2EAF0),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: targetLocation,
            initialZoom: 14.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'doctor_hunt',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: targetLocation,
                  width: 44,
                  height: 44,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
