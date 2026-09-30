import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_button.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/presentation/controller/cubit/patient_appointments_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/presentation/widgets/patient_appointment_card.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          context.tr.cancelAppointmentTitle,
          style: context.semiBold16TextMain,
        ),
        content: Text(
          context.tr.cancelAppointmentMessage,
          style: context.regular14TextSecondary,
        ),
        actions: [
          AppTextButton(
            label: context.tr.cancel,
            onPressed: () => Navigator.of(dialogContext).pop(false),
            textStyle: context.medium14TextSecondary,
          ),
          AppTextButton(
            label: context.tr.confirm,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            foregroundColor: AppColors.error,
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await context.read<PatientAppointmentsCubit>().cancelAppointment(
          appointment,
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr.appointmentCancelledSuccess),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          final appEx = AppException.from(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(appEx.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
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
        automaticallyImplyLeading: false, // Shell tab: no back button
        centerTitle: true,
        title: Text(context.tr.appointments, style: context.bold18TextMain),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: AppColors.surface,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: context.semiBold14TextMain,
              unselectedLabelStyle: context.regular14TextSecondary,
              tabs: [
                Tab(text: context.tr.upcoming),
                Tab(text: context.tr.completed),
                Tab(text: context.tr.cancelled),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<PatientAppointmentsCubit, PatientAppointmentsState>(
        builder: (context, state) {
          if (state is PatientAppointmentsLoading) {
            return const Center(child: CircularProgressIndicator());
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
                      state.message,
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
                  emptyIcon: Icons.event_available_rounded,
                  onCancel: (appt) => _confirmCancel(context, appt),
                ),
                _AppointmentsList(
                  key: const Key('completed_appointments_list'),
                  appointments: state.grouped.completed,
                  specialties: state.specialties,
                  emptyTitle: context.tr.noCompletedAppointments,
                  emptyIcon: Icons.event_note_rounded,
                  onRate: (appt) => PatientRateDoctorRoute(appt).push(context),
                ),
                _AppointmentsList(
                  key: const Key('cancelled_appointments_list'),
                  appointments: state.grouped.cancelled,
                  specialties: state.specialties,
                  emptyTitle: context.tr.noCancelledAppointments,
                  emptyIcon: Icons.event_busy_rounded,
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
    required this.emptyIcon,
    this.onCancel,
    this.onRate,
  });

  final List<AppointmentModel> appointments;
  final Map<String, dynamic> specialties;
  final String emptyTitle;
  final IconData emptyIcon;
  final ValueChanged<AppointmentModel>? onCancel;
  final ValueChanged<AppointmentModel>? onRate;

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(emptyIcon, size: 40, color: AppColors.primary),
              ),
              16.verticalSpace,
              Text(
                emptyTitle,
                style: context.semiBold16TextMain,
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,
              Text(
                context.tr.noAppointmentsDescription,
                style: context.regular12TextSecondary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        final specialty = specialties[appointment.specialtyId];
        final specialtyName = specialty != null
            ? (specialty.localizedName as String? ?? '')
            : null;

        return PatientAppointmentCard(
          key: Key('patient_appointment_card_${appointment.id}'),
          appointment: appointment,
          specialtyName: specialtyName,
          onTap: () =>
              PatientAppointmentDetailsRoute(appointment).push(context),
          onCancel: onCancel != null ? () => onCancel!(appointment) : null,
          onRate: onRate != null ? () => onRate!(appointment) : null,
        );
      },
    );
  }
}
