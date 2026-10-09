import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/widgets/app_confirm_dialog.dart';
import 'package:doctor_hunt/apps/core/widgets/app_profile_avatar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_empty_state.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/presentation/controller/cubit/admin_appointments_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/presentation/controller/cubit/admin_appointments_state.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/presentation/widgets/admin_appointment_card.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/apps/core/widgets/app_list_skeleton.dart';
import 'package:doctor_hunt/apps/core/widgets/skeleton_placeholders.dart';

class AdminAppointmentsScreen extends StatefulWidget {
  const AdminAppointmentsScreen({super.key, this.adminPhotoUrl});

  final String? adminPhotoUrl;

  @override
  State<AdminAppointmentsScreen> createState() =>
      _AdminAppointmentsScreenState();
}

class _AdminAppointmentsScreenState extends State<AdminAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AdminAppointmentsView(
      tabController: _tabController,
      adminPhotoUrl: widget.adminPhotoUrl,
    );
  }
}

class _AdminAppointmentsView extends StatelessWidget {
  const _AdminAppointmentsView({
    required this.tabController,
    required this.adminPhotoUrl,
  });

  final TabController tabController;
  final String? adminPhotoUrl;

  String _emptyMessageForTab(BuildContext context, AdminAppointmentTab tab) {
    return switch (tab) {
      AdminAppointmentTab.all => context.tr.noAppointmentsFound,
      AdminAppointmentTab.upcoming => context.tr.noUpcomingAppointments,
      AdminAppointmentTab.completed => context.tr.noCompletedAppointments,
      AdminAppointmentTab.cancelled => context.tr.noCancelledAppointments,
    };
  }

  Future<void> _cancel(BuildContext context, AppointmentModel appt) async {
    final cubit = context.read<AdminAppointmentsCubit>();
    final confirmed = await showAppConfirmDialog(
      context,
      title: context.tr.cancelAppointmentTitle,
      message: context.tr.cancelAppointmentMessage,
      confirmLabel: context.tr.confirm,
      confirmColor: AppColors.error,
    );
    if (!confirmed || !context.mounted) return;
    try {
      await cubit.cancel(appt);
      if (!context.mounted) return;
      context.showSuccessSnackBar(context.tr.appointmentCancelledSuccess);
    } catch (e) {
      if (!context.mounted) return;
      context.showErrorSnackBar(AppException.from(e).message);
    }
  }

  Future<void> _markCompleted(
    BuildContext context,
    AppointmentModel appt,
  ) async {
    final cubit = context.read<AdminAppointmentsCubit>();
    final confirmed = await showAppConfirmDialog(
      context,
      title: context.tr.markCompletedTitle,
      message: context.tr.markCompletedMessage,
      confirmLabel: context.tr.confirm,
    );
    if (!confirmed || !context.mounted) return;
    try {
      await cubit.markCompleted(appt.id);
      if (!context.mounted) return;
      context.showSuccessSnackBar(context.tr.appointmentMarkedCompletedSuccess);
    } catch (e) {
      if (!context.mounted) return;
      context.showErrorSnackBar(AppException.from(e).message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr.tabAppointments,
                      style: context.bold20TextMain,
                    ),
                  ),
                  AppProfileAvatar(
                    imageUrl: adminPhotoUrl,
                    onTap: () => const AdminProfileRoute().push(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListenableBuilder(
                listenable: tabController,
                builder: (context, _) => Row(
                  spacing: 8,
                  children: [
                    for (final (index, label) in [
                      context.tr.all,
                      context.tr.upcoming,
                      context.tr.completed,
                      context.tr.cancelled,
                    ].indexed)
                      Expanded(
                        child: AppPrimaryButton(
                          label: label,
                          height: 38,
                          padding: EdgeInsets.zero,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          backgroundColor: tabController.index == index
                              ? AppColors.primary
                              : AppColors.primaryLight,
                          foregroundColor: tabController.index == index
                              ? AppColors.white
                              : AppColors.primary,
                          textStyle: tabController.index == index
                              ? context.medium12White
                              : context.regular12Primary,
                          onPressed: () {
                            tabController.animateTo(index);
                            context.read<AdminAppointmentsCubit>().selectTab(
                              AdminAppointmentTab.values[index],
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
            16.verticalSpace,
            Expanded(
              child:
                  BlocBuilder<AdminAppointmentsCubit, AdminAppointmentsState>(
                    builder: (context, state) {
                      if (state.status == AdminAppointmentsStatus.loading) {
                        return AppListSkeleton(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemBuilder: (_) => AdminAppointmentCard(
                            appointment: skeletonAppointment(),
                          ),
                        );
                      }

                      if (state.status == AdminAppointmentsStatus.failure) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.errorMessage ?? context.tr.serviceError,
                                  style: context.medium14TextSecondary,
                                  textAlign: TextAlign.center,
                                ),
                                16.verticalSpace,
                                AppPrimaryButton(
                                  label: context.tr.retry,
                                  onPressed: () => context
                                      .read<AdminAppointmentsCubit>()
                                      .init(),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final appointments = state.currentAppointments;

                      if (appointments.isEmpty) {
                        return AppEmptyState(
                          title: _emptyMessageForTab(
                            context,
                            state.selectedTab,
                          ),
                          subtitle: context.tr.noAppointmentsDescription,
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          final appt = appointments[index];

                          return AdminAppointmentCard(
                            appointment: appt,
                            specialty: state.specialties[appt.specialtyId],
                            onTap: () => AdminAppointmentDetailsRoute(
                              appt,
                            ).push(context),
                            onCancel: () => _cancel(context, appt),
                            onMarkCompleted: () =>
                                _markCompleted(context, appt),
                          );
                        },
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
