import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/data/repositories/admin_appointments_repository.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/presentation/controller/cubit/admin_appointments_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/presentation/controller/cubit/admin_appointments_state.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/presentation/widgets/admin_appointment_card.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AdminAppointmentsScreen extends StatefulWidget {
  const AdminAppointmentsScreen({super.key, this.cubit, this.repository});

  final AdminAppointmentsCubit? cubit;
  final AdminAppointmentsRepository? repository;

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
    if (widget.cubit != null) {
      return BlocProvider<AdminAppointmentsCubit>.value(
        value: widget.cubit!,
        child: _AdminAppointmentsView(tabController: _tabController),
      );
    }

    final repo = widget.repository ?? getIt<AdminAppointmentsRepository>();

    return BlocProvider<AdminAppointmentsCubit>(
      create: (_) => AdminAppointmentsCubit(repository: repo)..init(),
      child: _AdminAppointmentsView(tabController: _tabController),
    );
  }
}

class _AdminAppointmentsView extends StatelessWidget {
  const _AdminAppointmentsView({required this.tabController});

  final TabController tabController;

  String _emptyMessageForTab(BuildContext context, AdminAppointmentTab tab) {
    return switch (tab) {
      AdminAppointmentTab.all => context.tr.noAppointmentsFound,
      AdminAppointmentTab.upcoming => context.tr.noUpcomingAppointments,
      AdminAppointmentTab.completed => context.tr.noCompletedAppointments,
      AdminAppointmentTab.cancelled => context.tr.noCancelledAppointments,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Text(
                    context.tr.tabAppointments,
                    style: context.bold20TextMain,
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: tabController,
                onTap: (index) {
                  context.read<AdminAppointmentsCubit>().selectTab(
                    AdminAppointmentTab.values[index],
                  );
                },
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: AppColors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: context.semiBold14TextMain,
                unselectedLabelStyle: context.regular14TextSecondary,
                padding: const EdgeInsets.all(4),
                tabs: [
                  Tab(text: context.tr.all),
                  Tab(text: context.tr.upcoming),
                  Tab(text: context.tr.completed),
                  Tab(text: context.tr.cancelled),
                ],
              ),
            ),

            16.verticalSpace,

            // Content
            Expanded(
              child:
                  BlocBuilder<AdminAppointmentsCubit, AdminAppointmentsState>(
                    builder: (context, state) {
                      if (state.status == AdminAppointmentsStatus.loading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
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
                                  state.errorMessage ??
                                      'Failed to load appointments',
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
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 36,
                                    color: AppColors.primary,
                                  ),
                                ),
                                20.verticalSpace,
                                Text(
                                  _emptyMessageForTab(
                                    context,
                                    state.selectedTab,
                                  ),
                                  style: context.semiBold16TextMain,
                                  textAlign: TextAlign.center,
                                ),
                                8.verticalSpace,
                                Text(
                                  context.tr.noAppointmentsDescription,
                                  style: context.regular14TextSecondary,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          final appt = appointments[index];
                          final specialty = state.specialties[appt.specialtyId];

                          return AdminAppointmentCard(
                            appointment: appt,
                            specialty: specialty,
                            onTap: () {
                              AdminAppointmentDetailsRoute(appt).push(context);
                            },
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
