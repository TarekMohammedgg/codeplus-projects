import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/models/booking_draft.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/controller/cubit/booking_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/controller/cubit/booking_state.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/booking_success_dialog.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/widgets/clinic_location_map.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

/// Step 3 (review) + step 4 (confirm). Pops `true` when the slot was taken
/// meanwhile, so the slot screen reloads.
class BookingReviewScreen extends StatefulWidget {
  const BookingReviewScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<BookingReviewScreen> createState() => _BookingReviewScreenState();
}

class _BookingReviewScreenState extends State<BookingReviewScreen> {
  late final Stream<ClinicModel?> _clinic = context
      .read<BookingCubit>()
      .watchClinic();

  void _onBookingState(BuildContext context, BookingState state) {
    switch (state) {
      case BookingConfirmed(:final draft):
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => BookingSuccessDialog(
            draft: draft,
            onDone: () {
              Navigator.of(dialogContext).pop();
              const PatientAppointmentsRoute().go(context);
            },
          ),
        );
      case BookingConfirmFailure(code: BookingFailureCode.slotAlreadyBooked):
        context.showErrorSnackBar(context.tr.slotAlreadyBooked);
        context.pop(true);
      case BookingConfirmFailure():
        context.showErrorSnackBar(context.tr.serviceError);
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    final doctor = draft.doctor;
    final locale = context.tr.$meta.locale.languageCode;
    final formattedDate = DateFormat.yMMMEd(locale).format(draft.startAt);
    final formattedTime = DateFormat.jm(locale).format(draft.startAt);

    final isConfirming = context.select<BookingCubit, bool>(
      (cubit) => cubit.state is BookingSubmitting,
    );

    return BlocListener<BookingCubit, BookingState>(
      listener: _onBookingState,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: AppIconButton.back(onTap: () => context.pop()),
          centerTitle: true,
          title: Text(context.tr.bookingReview, style: context.bold18TextMain),
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
                    DoctorProfileCard(doctor: doctor),
                    20.verticalSpace,
                    _BookingInfoCard(
                      date: formattedDate,
                      time: formattedTime,
                      fee: '\$${doctor.consultationFee.toStringAsFixed(2)}',
                    ),
                    20.verticalSpace,
                    _ClinicLocationCard(clinicStream: _clinic),
                    24.verticalSpace,
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: AppPrimaryButton(
                  label: context.tr.confirmBooking,
                  height: 52,
                  isLoading: isConfirming,
                  onPressed: isConfirming
                      ? null
                      : () => context.read<BookingCubit>().confirm(draft),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingInfoCard extends StatelessWidget {
  const _BookingInfoCard({
    required this.date,
    required this.time,
    required this.fee,
  });

  final String date;
  final String time;
  final String fee;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: context.tr.appointmentDate,
            value: date,
          ),
          12.verticalSpace,
          const Divider(height: 1, color: AppColors.outline),
          12.verticalSpace,
          _InfoRow(
            icon: Icons.access_time_rounded,
            label: context.tr.appointmentTime,
            value: time,
          ),
          12.verticalSpace,
          const Divider(height: 1, color: AppColors.outline),
          12.verticalSpace,
          _InfoRow(
            icon: Icons.payments_outlined,
            label: context.tr.consultationFee,
            value: fee,
            valueColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        10.horizontalSpace,
        Text(label, style: context.regular14TextSecondary),
        const Spacer(),
        Text(
          value,
          style: context.semiBold14TextMain.copyWith(
            color: valueColor ?? AppColors.textMain,
          ),
        ),
      ],
    );
  }
}

class _ClinicLocationCard extends StatelessWidget {
  const _ClinicLocationCard({required this.clinicStream});

  final Stream<ClinicModel?> clinicStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ClinicModel?>(
      stream: clinicStream,
      builder: (context, snapshot) {
        final clinic = snapshot.data;
        final address = clinic?.localizedAddress ?? '';
        final location = clinic?.location;

        return Container(
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
                  const Icon(
                    Icons.location_on_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  8.horizontalSpace,
                  Text(
                    context.tr.clinicLocation,
                    style: context.bold16TextMain,
                  ),
                ],
              ),
              12.verticalSpace,
              if (address.isEmpty && location == null)
                Text(
                  context.tr.clinicLocationNotSet,
                  style: context.regular14TextSecondary,
                )
              else ...[
                if (address.isNotEmpty) ...[
                  Text(address, style: context.regular14TextSecondary),
                  if (location != null) 12.verticalSpace,
                ],
                if (location != null) ClinicLocationMap(location: location),
              ],
            ],
          ),
        );
      },
    );
  }
}
