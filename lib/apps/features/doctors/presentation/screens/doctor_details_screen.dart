import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/features/doctors/data/models/doctor_detail_args.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({super.key, required this.doctor});

  final DoctorDetailArgs doctor;

  void openFindDoctors(BuildContext context) {
    const FindDoctorsRoute().push(context);
  }

  void showBookingMessage(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.t.bookingComingSoon)));
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
                    onBookNow: () => showBookingMessage(context),
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
                  const DoctorLocationMap(),
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
    final t = context.t;

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
          Text(t.doctorDetails, style: context.bold18TextMain),
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

class DoctorProfileCard extends StatelessWidget {
  const DoctorProfileCard({
    super.key,
    required this.doctor,
    required this.onBookNow,
  });

  final DoctorDetailArgs doctor;
  final VoidCallback onBookNow;

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: doctor.image != null
                      ? Image.asset(doctor.image!, fit: BoxFit.cover)
                      : const DoctorAvatarPlaceholder(circle: false),
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            doctor.name,
                            style: context.bold18TextMain.copyWith(
                              fontSize: 17,
                              height: 1.2,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            doctor.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: doctor.isFavorite
                                ? const Color(0xFFFF003A)
                                : AppColors.disabled,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    4.verticalSpace,
                    Text(
                      doctor.specialty,
                      style: context.regular14TextSub.copyWith(
                        fontSize: 13,
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                    8.verticalSpace,
                    DoctorStarRating(rating: doctor.rating),
                    8.verticalSpace,
                    Text(
                      '\$${doctor.hourlyRate.toStringAsFixed(2)}${t.perHour}',
                      style: context.bold16Primary.copyWith(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.verticalSpace,
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onBookNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                t.bookNow,
                style: context.semiBold16White.copyWith(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorStarRating extends StatelessWidget {
  const DoctorStarRating({super.key, required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final filled = index < rating.floor();
        final halfFilled = !filled && index < rating;
        return Icon(
          filled
              ? Icons.star_rounded
              : halfFilled
              ? Icons.star_half_rounded
              : Icons.star_border_rounded,
          color: const Color(0xFFFFB800),
          size: 18,
        );
      }),
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
    final t = context.t;

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
              child: DoctorStatItem(count: runningCount, label: t.statRunning),
            ),
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: AppColors.outline,
            ),
            Expanded(
              child: DoctorStatItem(count: ongoingCount, label: t.statOngoing),
            ),
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: AppColors.outline,
            ),
            Expanded(
              child: DoctorStatItem(count: patientCount, label: t.statPatient),
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
          style: context.regular14TextSub.copyWith(
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
        Text(t.services, style: context.bold18TextMain),
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
                    color: AppColors.primaryGreen.withValues(alpha: 0.12),
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
                    style: context.regular14TextSub.copyWith(
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
  const DoctorLocationMap({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        Assets.assetsDummyMap,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 180,
          width: double.infinity,
          color: const Color(0xFFE2EAF0),
          child: const Center(
            child: Icon(
              Icons.map_rounded,
              size: 40,
              color: AppColors.primaryGreen,
            ),
          ),
        ),
      ),
    );
  }
}
