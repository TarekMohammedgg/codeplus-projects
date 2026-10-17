import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/extensions/app_error_text.dart';
import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/formatters.dart';
import 'package:doctor_hunt/apps/core/widgets/app_back_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_card.dart';
import 'package:doctor_hunt/apps/core/widgets/app_confirm_dialog.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/appointment_detail_row.dart';
import 'package:doctor_hunt/apps/core/widgets/appointment_summary_card.dart';
import 'package:doctor_hunt/apps/core/widgets/clinic_location_card.dart';
import 'package:doctor_hunt/apps/features/common/appointment_details/presentation/controller/cubit/appointment_details_cubit.dart';
import 'package:doctor_hunt/apps/features/common/appointment_details/presentation/widgets/appointment_doctor_card.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AdminAppointmentDetailsScreen extends StatelessWidget {
  const AdminAppointmentDetailsScreen({super.key});

  Future<void> _confirmMarkCompleted(BuildContext context) async {
    final cubit = context.read<AppointmentDetailsCubit>();
    if (await showMarkCompletedDialog(context)) await cubit.markCompleted();
  }

  Future<void> _confirmCancel(BuildContext context) async {
    final cubit = context.read<AppointmentDetailsCubit>();
    if (await showCancelAppointmentDialog(context)) {
      await cubit.cancel(CancelledBy.admin);
    }
  }

  void _onActionChanged(BuildContext context, AppointmentDetailsState state) {
    switch (state.action) {
      case AppointmentActionStatus.completed:
        context.showSuccessSnackBar(
          context.tr.appointmentMarkedCompletedSuccess,
        );
        Navigator.of(context).maybePop();
      case AppointmentActionStatus.cancelled:
        context.showSuccessSnackBar(context.tr.appointmentCancelledSuccess);
        Navigator.of(context).maybePop();
      case AppointmentActionStatus.failed:
        context.showErrorSnackBar(
          (state.error ?? AppErrorCode.service).localized(context.tr),
        );
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppointmentDetailsCubit>().state;
    final appointment = state.appointment;

    return BlocListener<AppointmentDetailsCubit, AppointmentDetailsState>(
      listenWhen: (previous, current) => previous.action != current.action,
      listener: _onActionChanged,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: const AppBackButton.leading(),
          centerTitle: true,
          title: Text(
            context.tr.appointmentDetails,
            style: context.bold18TextMain,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppointmentDoctorCard(
                      appointment: appointment,
                      specialtyName: state.specialtyName,
                    ),
                    20.verticalSpace,
                    _PatientInfoCard(appointment: appointment),
                    20.verticalSpace,
                    AppointmentSummaryCard(
                      date: formatDate(appointment.startAt, context.localeCode),
                      time: formatTime(appointment.startAt, context.localeCode),
                      fee: formatFee(appointment.fee),
                      extraRows: [
                        if (appointment.status == AppointmentStatus.cancelled)
                          AppointmentDetailRow(
                            icon: Icons.cancel_outlined,
                            label: context.tr.statusCancelled,
                            value:
                                appointment.cancelledBy == CancelledBy.patient
                                ? context.tr.cancelledByPatient
                                : context.tr.cancelledByAdmin,
                            valueColor: AppColors.error,
                          ),
                      ],
                    ),
                    20.verticalSpace,
                    ClinicLocationCard(clinic: state.clinic),
                    24.verticalSpace,
                  ],
                ),
              ),
            ),
            if (appointment.status == AppointmentStatus.upcoming)
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (appointment.hasStarted) ...[
                        AppPrimaryButton(
                          key: const Key('admin_mark_completed_button'),
                          label: context.tr.markCompleted,
                          icon: Icons.check_circle_outline_rounded,
                          isLoading:
                              state.action ==
                              AppointmentActionStatus.completing,
                          onPressed: state.isBusy
                              ? null
                              : () => _confirmMarkCompleted(context),
                        ),
                        12.verticalSpace,
                      ],
                      AppPrimaryButton.outlined(
                        key: const Key('admin_cancel_appointment_button'),
                        label: context.tr.cancelAppointment,
                        foregroundColor: AppColors.error,
                        borderColor: AppColors.error,
                        isLoading:
                            state.action == AppointmentActionStatus.cancelling,
                        onPressed: state.isBusy
                            ? null
                            : () => _confirmCancel(context),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PatientInfoCard extends StatelessWidget {
  const _PatientInfoCard({required this.appointment});

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    String orNotSet(String value) =>
        value.isNotEmpty ? value : context.tr.notSet;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person_rounded,
                size: 20,
                color: AppColors.primary,
              ),
              8.horizontalSpace,
              Text(context.tr.patientInfo, style: context.bold16TextMain),
            ],
          ),
          14.verticalSpace,
          AppointmentDetailRow(
            icon: Icons.badge_outlined,
            label: context.tr.patientName,
            value: appointment.patientName,
          ),
          12.verticalSpace,
          const Divider(height: 1, color: AppColors.outline),
          12.verticalSpace,
          AppointmentDetailRow(
            icon: Icons.phone_outlined,
            label: context.tr.patientPhone,
            value: orNotSet(appointment.patientPhone),
          ),
          12.verticalSpace,
          const Divider(height: 1, color: AppColors.outline),
          12.verticalSpace,
          AppointmentDetailRow(
            icon: Icons.email_outlined,
            label: context.tr.patientEmail,
            value: orNotSet(appointment.patientEmail),
          ),
        ],
      ),
    );
  }
}
