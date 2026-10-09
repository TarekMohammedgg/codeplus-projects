import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/formatters.dart';
import 'package:doctor_hunt/apps/core/widgets/app_back_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/appointment_summary_card.dart';
import 'package:doctor_hunt/apps/core/widgets/clinic_location_card.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/models/booking_draft.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/controller/cubit/booking_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/controller/cubit/booking_state.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/booking_success_dialog.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

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
    final formattedDate = formatDate(draft.startAt, context.localeCode);
    final formattedTime = formatTime(draft.startAt, context.localeCode);

    final isConfirming = context.select<BookingCubit, bool>(
      (cubit) => cubit.state is BookingSubmitting,
    );

    return BlocListener<BookingCubit, BookingState>(
      listener: _onBookingState,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: AppBackButton.leading(onTap: () => context.pop()),
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
                    AppointmentSummaryCard(
                      date: formattedDate,
                      time: formattedTime,
                      fee: formatFee(doctor.consultationFee),
                    ),
                    20.verticalSpace,
                    StreamBuilder<ClinicModel?>(
                      stream: _clinic,
                      builder: (context, snapshot) =>
                          ClinicLocationCard(clinic: snapshot.data),
                    ),
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
