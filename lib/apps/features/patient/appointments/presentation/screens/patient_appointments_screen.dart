import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/extensions/app_error_text.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_empty_state.dart';
import 'package:doctor_hunt/apps/core/widgets/app_back_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_confirm_dialog.dart';
import 'package:doctor_hunt/apps/core/widgets/app_segmented_tab_bar.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/presentation/controller/cubit/patient_appointments_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/presentation/widgets/patient_appointment_card.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/apps/core/widgets/app_list_skeleton.dart';
import 'package:doctor_hunt/apps/core/widgets/skeleton_placeholders.dart';

class PatientAppointmentsScreen extends StatefulWidget {
  const PatientAppointmentsScreen({super.key});

  @override
  State<PatientAppointmentsScreen> createState() =>
      _PatientAppointmentsScreenState();
}

class _PatientAppointmentsScreenState extends State<PatientAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _confirmCancel(
    BuildContext context,
    AppointmentModel appointment,
  ) async {
    final confirmed = await showCancelAppointmentDialog(context);

    if (confirmed && context.mounted) {
      try {
        await context.read<PatientAppointmentsCubit>().cancelAppointment(
          appointment,
        );
        if (context.mounted) {
          context.showSuccessSnackBar(context.tr.appointmentCancelledSuccess);
        }
      } catch (e) {
        if (context.mounted) {
          context.showErrorSnackBar(context.errorText(e));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leadingWidth: 50,
        leading: AppBackButton.leading(
          onTap: () =>
              context.canPop() ? context.pop() : const HomeRoute().go(context),
        ),
        titleSpacing: 19,
        title: Text(context.tr.appointments, style: context.medium18TextMain),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(46),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: AppSegmentedTabBar(
              controller: _tabController,
              labels: [
                context.tr.upcoming,
                context.tr.completed,
                context.tr.cancelled,
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<PatientAppointmentsCubit, PatientAppointmentsState>(
        builder: (context, state) {
          if (state is PatientAppointmentsLoading) {
            return AppListSkeleton(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              itemBuilder: (_) =>
                  PatientAppointmentCard(appointment: skeletonAppointment()),
            );
          }

          if (state is PatientAppointmentsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: AppColors.error,
                    ),
                    12.verticalSpace,
                    Text(
                      state.error.localized(context.tr),
                      style: context.medium14TextSecondary,
                      textAlign: TextAlign.center,
                    ),
                    20.verticalSpace,
                    AppPrimaryButton(
                      width: 140,
                      height: 44,
                      fontSize: 14,
                      label: context.tr.retry,
                      onPressed: () =>
                          context.read<PatientAppointmentsCubit>().init(),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is PatientAppointmentsLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _AppointmentsList(
                  key: const Key('upcoming_appointments_list'),
                  appointments: state.grouped.upcoming,
                  specialties: state.specialties,
                  emptyTitle: context.tr.noUpcomingAppointments,
                  emptyAction: AppPrimaryButton(
                    label: context.tr.bookAppointment,
                    width: 200,
                    height: 48,
                    onPressed: () => const FindDoctorsRoute().push(context),
                  ),
                  onCancel: (appt) => _confirmCancel(context, appt),
                ),
                _AppointmentsList(
                  key: const Key('completed_appointments_list'),
                  appointments: state.grouped.completed,
                  specialties: state.specialties,
                  emptyTitle: context.tr.noCompletedAppointments,
                  onRate: (appt) => PatientRateDoctorRoute(appt).push(context),
                ),
                _AppointmentsList(
                  key: const Key('cancelled_appointments_list'),
                  appointments: state.grouped.cancelled,
                  specialties: state.specialties,
                  emptyTitle: context.tr.noCancelledAppointments,
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _AppointmentsList extends StatelessWidget {
  const _AppointmentsList({
    super.key,
    required this.appointments,
    required this.specialties,
    required this.emptyTitle,
    this.emptyAction,
    this.onCancel,
    this.onRate,
  });

  final List<AppointmentModel> appointments;
  final Map<String, SpecialtyModel> specialties;
  final String emptyTitle;
  final Widget? emptyAction;
  final ValueChanged<AppointmentModel>? onCancel;
  final ValueChanged<AppointmentModel>? onRate;

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return AppEmptyState(
        title: emptyTitle,
        subtitle: context.tr.noAppointmentsDescription,
        action: emptyAction,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return PatientAppointmentCard(
          key: Key('patient_appointment_card_${appointment.id}'),
          appointment: appointment,
          specialtyName: specialties[appointment.specialtyId]?.localizedName,
          onViewDetails: () =>
              PatientAppointmentDetailsRoute(appointment).push(context),
          onCancel: onCancel != null ? () => onCancel!(appointment) : null,
          onRate: onRate != null ? () => onRate!(appointment) : null,
        );
      },
    );
  }
}
