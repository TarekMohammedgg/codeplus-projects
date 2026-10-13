import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
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

class AdminAppointmentDetailsScreen extends StatefulWidget {
  const AdminAppointmentDetailsScreen({super.key, required this.appointment});

  final AppointmentModel appointment;

  @override
  State<AdminAppointmentDetailsScreen> createState() =>
      _AdminAppointmentDetailsScreenState();
}

class _AdminAppointmentDetailsScreenState
    extends State<AdminAppointmentDetailsScreen> {
  bool _isCancelling = false;
  bool _isMarkingCompleted = false;

  Future<void> _confirmMarkCompleted() async {
    final cubit = context.read<AppointmentDetailsCubit>();
    final confirmed = await showMarkCompletedDialog(context);
    if (!confirmed || !mounted) return;

    setState(() => _isMarkingCompleted = true);
    try {
      await cubit.markCompleted(widget.appointment.id);
    } catch (e) {
      if (!mounted) return;
      context.showErrorSnackBar(AppException.from(e).message);
      return;
    } finally {
      if (mounted) setState(() => _isMarkingCompleted = false);
    }
    if (!mounted) return;
    context.showSuccessSnackBar(context.tr.appointmentMarkedCompletedSuccess);
    Navigator.of(context).maybePop();
  }

  Future<void> _confirmCancel() async {
    final cubit = context.read<AppointmentDetailsCubit>();
    final confirmed = await showCancelAppointmentDialog(context);
    if (!confirmed || !mounted) return;

    setState(() => _isCancelling = true);
    try {
      await cubit.cancel(widget.appointment, CancelledBy.admin);
    } catch (e) {
      if (!mounted) return;
      context.showErrorSnackBar(AppException.from(e).message);
      return;
    } finally {
      if (mounted) setState(() => _isCancelling = false);
    }
    if (!mounted) return;
    context.showSuccessSnackBar(context.tr.appointmentCancelledSuccess);
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;
    final state = context.watch<AppointmentDetailsCubit>().state;
    final isBusy = _isMarkingCompleted || _isCancelling;

    return Scaffold(
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                          value: appointment.cancelledBy == CancelledBy.patient
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
                    AppPrimaryButton(
                      key: const Key('admin_mark_completed_button'),
                      label: context.tr.markCompleted,
                      icon: Icons.check_circle_outline_rounded,
                      isLoading: _isMarkingCompleted,
                      onPressed: isBusy ? null : _confirmMarkCompleted,
                    ),
                    12.verticalSpace,
                    AppPrimaryButton.outlined(
                      key: const Key('admin_cancel_appointment_button'),
                      label: context.tr.cancelAppointment,
                      foregroundColor: AppColors.error,
                      borderColor: AppColors.error,
                      isLoading: _isCancelling,
                      onPressed: isBusy ? null : _confirmCancel,
                    ),
                  ],
                ),
              ),
            ),
        ],
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
