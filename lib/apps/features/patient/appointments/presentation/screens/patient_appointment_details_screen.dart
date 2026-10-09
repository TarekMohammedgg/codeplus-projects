import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/formatters.dart';
import 'package:doctor_hunt/apps/core/widgets/app_back_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_confirm_dialog.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/appointment_detail_row.dart';
import 'package:doctor_hunt/apps/core/widgets/appointment_summary_card.dart';
import 'package:doctor_hunt/apps/core/widgets/clinic_location_card.dart';
import 'package:doctor_hunt/apps/features/common/appointment_details/presentation/controller/cubit/appointment_details_cubit.dart';
import 'package:doctor_hunt/apps/features/common/appointment_details/presentation/widgets/appointment_doctor_card.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

/// Needs an [AppointmentDetailsCubit] above it (provided by the route).
class PatientAppointmentDetailsScreen extends StatefulWidget {
  const PatientAppointmentDetailsScreen({super.key, required this.appointment});

  final AppointmentModel appointment;

  @override
  State<PatientAppointmentDetailsScreen> createState() =>
      _PatientAppointmentDetailsScreenState();
}

class _PatientAppointmentDetailsScreenState
    extends State<PatientAppointmentDetailsScreen> {
  bool _isCancelling = false;

  Future<void> _confirmCancel() async {
    final cubit = context.read<AppointmentDetailsCubit>();
    final confirmed = await showAppConfirmDialog(
      context,
      title: context.tr.cancelAppointmentTitle,
      message: context.tr.cancelAppointmentMessage,
      confirmLabel: context.tr.confirm,
      confirmColor: AppColors.error,
    );
    if (!confirmed || !mounted) return;

    setState(() => _isCancelling = true);
    try {
      await cubit.cancel(widget.appointment, CancelledBy.patient);
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
                              ? context.tr.cancelledByYou
                              : context.tr.cancelledByClinic,
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
                child: AppPrimaryButton.outlined(
                  key: const Key('details_cancel_button'),
                  label: context.tr.cancelAppointment,
                  foregroundColor: AppColors.error,
                  borderColor: AppColors.error,
                  isLoading: _isCancelling,
                  onPressed: _isCancelling ? null : _confirmCancel,
                ),
              ),
            )
          else if (appointment.status == AppointmentStatus.completed)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: !appointment.isReviewed
                    ? AppPrimaryButton(
                        key: const Key('details_rate_doctor_button'),
                        label: context.tr.rateDoctor,
                        icon: Icons.star_rounded,
                        onPressed: () =>
                            PatientRateDoctorRoute(appointment).push(context),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          8.horizontalSpace,
                          Text(
                            context.tr.reviewed,
                            style: context.semiBold16TextMain.copyWith(
                              color: AppColors.primary,
                            ),
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
