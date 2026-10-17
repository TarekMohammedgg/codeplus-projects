import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_card.dart';
import 'package:doctor_hunt/apps/core/utils/formatters.dart';
import 'package:doctor_hunt/apps/core/widgets/app_back_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_status_pill.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/apps/features/admin/doctor_details/presentation/controller/cubit/admin_doctor_details_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/widgets/admin_doctors_widgets.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AdminDoctorDetails extends StatelessWidget {
  const AdminDoctorDetails({super.key});

  Future<void> _confirmToggleStatus(
    BuildContext context,
    AdminDoctorDetailsCubit cubit,
    bool activate,
  ) async {
    final confirmed = await showToggleDoctorActiveDialog(
      context,
      activate: activate,
    );
    if (!confirmed || !context.mounted) return;

    final toggled = await cubit.toggleActive(activate);
    if (toggled && context.mounted) {
      context.showSuccessSnackBar(
        activate
            ? context.tr.doctorActivatedSuccess
            : context.tr.doctorDeactivatedSuccess,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminDoctorDetailsCubit, AdminDoctorDetailsState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          context.showErrorSnackBar(state.errorMessage!);
        }
      },
      builder: (context, state) {
        final doctor = state.doctor;
        final cubit = context.read<AdminDoctorDetailsCubit>();
        final availabilityText = doctor.availability != null
            ? doctor.availability!.formatSummary(locale: context.localeCode)
            : context.tr.notSet;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: AppBackButton.leading(),
            centerTitle: true,
            title: Text(
              context.tr.doctorDetails,
              style: context.bold18TextMain,
            ),
            actions: [
              if (state.isTogglingActive)
                const Padding(
                  padding: EdgeInsetsDirectional.only(end: 16),
                  child: SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                PopupMenuButton<bool>(
                  key: const Key('admin_doctor_status_menu'),
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.textMain,
                  ),
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  onSelected: (targetActive) =>
                      _confirmToggleStatus(context, cubit, targetActive),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: !doctor.isActive,
                      child: Text(
                        doctor.isActive
                            ? context.tr.deactivateDoctorTitle
                            : context.tr.activateDoctorTitle,
                        style: context.medium14TextMain.copyWith(
                          color: doctor.isActive
                              ? AppColors.error
                              : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: _DoctorAvatar(doctor: doctor)),
                  16.verticalSpace,
                  Text(
                    doctor.name,
                    style: context.bold24TextMain,
                    textAlign: TextAlign.center,
                  ),
                  12.verticalSpace,
                  Center(
                    child: AppStatusPill(
                      label: doctor.isActive
                          ? context.tr.activeLabel
                          : context.tr.inactiveLabel,
                      color: doctor.isActive
                          ? AppColors.primary
                          : AppColors.error,
                      backgroundColor: doctor.isActive
                          ? AppColors.primaryLight
                          : AppColors.errorLight,
                      textStyle: context.semiBold13,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  _DoctorInfoCard(
                    doctor: doctor,
                    availabilityText: availabilityText,
                  ),
                  40.verticalSpace,
                  AppPrimaryButton(
                    key: const Key('admin_doctor_edit_button'),
                    label: context.tr.editDoctorTitle,
                    icon: Icons.edit_outlined,
                    onPressed: () => CreateDoctorRoute(doctor).push(context),
                  ),
                  12.verticalSpace,
                  AppPrimaryButton.outlined(
                    key: const Key('admin_doctor_availability_button'),
                    label: context.tr.manageAvailability,
                    icon: Icons.event_available_outlined,
                    height: 44,
                    fontSize: 14,
                    backgroundColor: AppColors.surface,
                    borderColor: AppColors.outline,
                    onPressed: () =>
                        DoctorAvailabilityRoute(doctor).push(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DoctorAvatar extends StatelessWidget {
  const _DoctorAvatar({required this.doctor});

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipOval(
          child: DoctorImage(
            imageUrl: doctor.imageUrl,
            width: 112,
            height: 112,
            fallback: const DoctorAvatarPlaceholder(size: 112),
          ),
        ),
        if (doctor.isActive)
          PositionedDirectional(
            end: 0,
            bottom: 0,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
              ),
              child: const Icon(
                Icons.verified_rounded,
                size: 18,
                color: AppColors.white,
              ),
            ),
          ),
      ],
    );
  }
}

class _DoctorInfoCard extends StatelessWidget {
  const _DoctorInfoCard({required this.doctor, required this.availabilityText});

  final DoctorModel doctor;
  final String availabilityText;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _InfoRow(
        icon: Icons.medical_services_outlined,
        label: context.tr.specialtyLabel,
        child: Text(doctor.specialty, style: context.bold16TextMain),
      ),
      _InfoRow(
        icon: Icons.star_outline_rounded,
        label: context.tr.rating,
        child: Row(
          children: [
            DoctorStarRating(rating: doctor.rating, size: 12),
            6.horizontalSpace,
            Flexible(
              child: Text(
                context.tr.ratingSummary(
                  rating: doctor.rating.toStringAsFixed(1),
                  count: doctor.reviewsCount,
                ),
                style: context.regular10TextSecondary,
              ),
            ),
          ],
        ),
      ),
      _InfoRow(
        icon: Icons.monetization_on_outlined,
        label: context.tr.consultationFee,
        child: Text(
          formatFee(doctor.consultationFee),
          style: context.bold16TextMain,
        ),
      ),
      _InfoRow(
        icon: Icons.calendar_month_outlined,
        label: context.tr.availability,
        child: Text(availabilityText, style: context.semiBold14TextMain),
      ),
    ];

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          for (final (index, row) in rows.indexed) ...[
            if (index > 0) const Divider(height: 1, color: AppColors.outline),
            row,
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.child,
  });

  final IconData icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.regular12TextSecondary),
                4.verticalSpace,
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
