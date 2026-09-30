import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/features/admin/doctor_details/presentation/controller/cubit/admin_doctor_details_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/service/admin_doctor_service.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AdminDoctorDetails extends StatelessWidget {
  const AdminDoctorDetails({
    super.key,
    required this.doctor,
    this.cubit,
    this.doctorService,
  });

  final AdminDoctorModel doctor;
  final AdminDoctorDetailsCubit? cubit;
  final AdminDoctorService? doctorService;

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return BlocProvider<AdminDoctorDetailsCubit>.value(
        value: cubit!,
        child: const _AdminDoctorDetailsView(),
      );
    }

    return BlocProvider<AdminDoctorDetailsCubit>(
      create: (_) => AdminDoctorDetailsCubit(
        initialDoctor: doctor,
        doctorService: doctorService ?? getIt<AdminDoctorService>(),
      ),
      child: const _AdminDoctorDetailsView(),
    );
  }
}

class _AdminDoctorDetailsView extends StatelessWidget {
  const _AdminDoctorDetailsView();

  void _popScreen(BuildContext context) {
    try {
      if (context.canPop()) {
        context.pop();
        return;
      }
    } catch (_) {}
    Navigator.of(context).maybePop();
  }

  Future<void> _confirmToggleStatus(
    BuildContext context,
    AdminDoctorDetailsCubit cubit,
    bool targetActive,
  ) async {
    final title = targetActive
        ? context.tr.activateDoctorTitle
        : context.tr.deactivateDoctorTitle;
    final message = targetActive
        ? context.tr.confirmActivateDoctor
        : context.tr.confirmDeactivateDoctor;
    final actionLabel = targetActive
        ? context.tr.activateDoctorTitle
        : context.tr.deactivateDoctorTitle;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: context.semiBold16TextMain),
        content: Text(message, style: context.regular14TextSecondary),
        actions: [
          AppTextButton(
            label: context.tr.cancel,
            onPressed: () => Navigator.of(dialogContext).pop(false),
            textStyle: context.medium14TextSecondary,
          ),
          AppTextButton(
            label: actionLabel,
            foregroundColor: targetActive ? AppColors.primary : AppColors.error,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await cubit.toggleActive(targetActive);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr.doctorStatusUpdated),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: AppIconButton.back(onTap: () => _popScreen(context)),
        centerTitle: true,
        title: Text(context.tr.doctorDetails, style: context.bold18TextMain),
      ),
      body: BlocConsumer<AdminDoctorDetailsCubit, AdminDoctorDetailsState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final doctor = state.doctor;
          final cubit = context.read<AdminDoctorDetailsCubit>();
          final availabilityText = doctor.availability != null
              ? doctor.availability!.formatSummary(
                  locale: LocaleSettings.currentLocale.languageCode,
                )
              : context.tr.notSet;

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      children: [
                        // Profile Overview Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadowCard,
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: SizedBox(
                                  width: 96,
                                  height: 96,
                                  child: DoctorImage(
                                    imageUrl: doctor.imageUrl,
                                    fallback: const DoctorAvatarPlaceholder(
                                      circle: false,
                                    ),
                                  ),
                                ),
                              ),
                              16.verticalSpace,
                              Text(
                                doctor.name,
                                style: context.bold18TextMain,
                                textAlign: TextAlign.center,
                              ),
                              4.verticalSpace,
                              Text(
                                doctor.specialty,
                                style: context.regular14TextSecondary,
                                textAlign: TextAlign.center,
                              ),
                              12.verticalSpace,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Status Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: doctor.isActive
                                          ? AppColors.primary.withValues(
                                              alpha: 0.12,
                                            )
                                          : AppColors.error.withValues(
                                              alpha: 0.12,
                                            ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      doctor.isActive
                                          ? context.tr.activeLabel
                                          : context.tr.inactiveLabel,
                                      style: context.semiBold12Primary.copyWith(
                                        color: doctor.isActive
                                            ? AppColors.primary
                                            : AppColors.error,
                                      ),
                                    ),
                                  ),
                                  12.horizontalSpace,
                                  // Rating & Count
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        size: 18,
                                        color: AppColors.warning,
                                      ),
                                      4.horizontalSpace,
                                      Text(
                                        doctor.rating.toStringAsFixed(1),
                                        style: context.semiBold14TextMain,
                                      ),
                                      4.horizontalSpace,
                                      Text(
                                        '(${doctor.reviewsCount} ${context.tr.reviews})',
                                        style: context.regular12TextSecondary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        16.verticalSpace,

                        // Consultation Fee Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadowCard,
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.payments_outlined,
                                  color: AppColors.primary,
                                  size: 22,
                                ),
                              ),
                              14.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.tr.consultationFee,
                                      style: context.regular12TextSecondary,
                                    ),
                                    4.verticalSpace,
                                    Text(
                                      '\$${doctor.consultationFee.toStringAsFixed(0)}',
                                      style: context.bold16Primary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        16.verticalSpace,

                        // Availability Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadowCard,
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.calendar_month_outlined,
                                      color: AppColors.primary,
                                      size: 22,
                                    ),
                                  ),
                                  14.horizontalSpace,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          context.tr.availability,
                                          style: context.regular12TextSecondary,
                                        ),
                                        4.verticalSpace,
                                        Text(
                                          availabilityText,
                                          style: context.semiBold14TextMain,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              14.verticalSpace,
                              SizedBox(
                                width: double.infinity,
                                child: AppPrimaryButton.outlined(
                                  key: const Key(
                                    'admin_doctor_availability_button',
                                  ),
                                  label: context.tr.availability,
                                  icon: Icons.access_time_rounded,
                                  onPressed: () => DoctorAvailabilityRoute(
                                    doctor,
                                  ).push(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        16.verticalSpace,

                        // Status Switch Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadowCard,
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: doctor.isActive
                                      ? AppColors.primary.withValues(alpha: 0.1)
                                      : AppColors.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  doctor.isActive
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.highlight_off_rounded,
                                  color: doctor.isActive
                                      ? AppColors.primary
                                      : AppColors.error,
                                  size: 22,
                                ),
                              ),
                              14.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doctor.isActive
                                          ? context.tr.activeLabel
                                          : context.tr.inactiveLabel,
                                      style: context.semiBold16TextMain,
                                    ),
                                  ],
                                ),
                              ),
                              if (state.isTogglingActive)
                                const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              else
                                Switch.adaptive(
                                  key: const Key('admin_doctor_status_switch'),
                                  value: doctor.isActive,
                                  activeTrackColor: AppColors.primary,
                                  onChanged: (newValue) => _confirmToggleStatus(
                                    context,
                                    cubit,
                                    newValue,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        24.verticalSpace,
                      ],
                    ),
                  ),
                ),

                // Bottom Action: Edit Doctor
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: AppPrimaryButton(
                    key: const Key('admin_doctor_edit_button'),
                    label: context.tr.editDoctorTitle,
                    icon: Icons.edit_outlined,
                    onPressed: () => CreateDoctorRoute(doctor).push(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
