import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_button.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_state.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/widgets/admin_doctors_widgets.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AdminDoctorsScreen extends StatefulWidget {
  const AdminDoctorsScreen({super.key});

  @override
  State<AdminDoctorsScreen> createState() => AdminDoctorsScreenState();
}

class AdminDoctorsScreenState extends State<AdminDoctorsScreen> {
  final _searchController = TextEditingController();
  late final AdminDoctorsCubit _adminDoctorsCubit;

  int _selectedNavIndex = 0;
  String _query = '';

  @override
  void initState() {
    super.initState();
    //CR Bad DI: Avoid checking `getIt.isRegistered` with manual fallback instantiations in UI initState.
    // solved
    //CR Use `getIt<Cubit>()` directly or inject via constructor.
    // solved
    //CR Bad DI: Avoid checking `getIt.isRegistered` with manual fallback instantiations in UI initState.
    // solved
    //CR Use `getIt<Cubit>()` directly or inject via constructor.
    // solved
    _adminDoctorsCubit = context.read<AdminDoctorsCubit>();
    _adminDoctorsCubit.load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() => _selectedNavIndex = index);
    if (index == 1) {
      const AdminSettingsRoute().push(context).then((_) {
        if (mounted) setState(() => _selectedNavIndex = 0);
      });
    }
  }

  List<AdminDoctorModel> _filter(List<AdminDoctorModel> doctors) {
    if (_query.trim().isEmpty) return doctors;
    final query = _query.trim().toLowerCase();
    return doctors
        .where(
          (doctor) =>
              doctor.name.toLowerCase().contains(query) ||
              doctor.specialty.toLowerCase().contains(query),
        )
        .toList();
  }

  Future<void> _confirmDeleteDoctor(AdminDoctorModel doctor) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(tr.deleteDoctorTitle, style: context.semiBold16TextMain),
        content: Text(
          tr.deleteDoctorConfirm,
          style: context.regular14TextSecondary,
        ),
        actions: [
          //CR use primary widget (any reuse widget)
          // Solved
          AppTextButton(
            label: tr.cancel,
            onPressed: () => Navigator.of(dialogContext).pop(false),
            textStyle: context.medium14TextSecondary,
          ),
          //CR use primary widget (any reuse widget)
          // Solved
          AppTextButton(
            label: tr.delete,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            foregroundColor: AppColors.error,
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await _adminDoctorsCubit.deleteDoctor(doctor.id);
        if (!mounted) return;
        context.showSuccessSnackBar(tr.doctorDeletedSuccess);
      } catch (e) {
        if (!mounted) return;
        context.showErrorSnackBar(AppException.from(e).message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDoctorsCubit, AdminDoctorsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              AppHeaderSection(
                title: tr.doctorsTitle,
                leading: const Icon(Icons.menu_rounded, color: Colors.white),
                trailing: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                ),
                showSearchBar: true,
                searchController: _searchController,
                searchHintText: tr.searchAdminDoctorsHint,
                onSearchChanged: (value) => setState(() => _query = value),
              ),
              Expanded(child: _buildDoctorsContent(context, state)),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => const CreateDoctorRoute().push(context),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: Text(
              tr.addDoctor,
              style: context.semiBold14Primary.copyWith(color: Colors.white),
            ),
          ),
          bottomNavigationBar: AdminBottomNavigationBar(
            currentIndex: _selectedNavIndex,
            onTap: _onNavTap,
          ),
        );
      },
    );
  }

  Widget _buildDoctorsContent(BuildContext context, AdminDoctorsState state) {
    return switch (state) {
      AdminDoctorsInitial() ||
      AdminDoctorsLoading() => const Center(child: CircularProgressIndicator()),
      AdminDoctorsFailure() => Center(
        child: Text(tr.serviceError, style: context.semiBold16TextMain),
      ),
      AdminDoctorsSuccess(:final doctors) => _buildDoctorsList(
        context,
        doctors,
      ),
    };
  }

  Widget _buildDoctorsList(
    BuildContext context,
    List<AdminDoctorModel> doctors,
  ) {
    final filtered = _filter(doctors);
    final activeCount = doctors.where((doctor) => doctor.isActive).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminStatsRow(totalCount: doctors.length, activeCount: activeCount),
          16.verticalSpace,
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      doctors.isEmpty ? tr.noDoctorsYet : tr.noDoctorsFound,
                      textAlign: TextAlign.center,
                      style: context.regular14TextSecondary,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => 12.verticalSpace,
                    itemBuilder: (context, index) {
                      final doctor = filtered[index];
                      return AdminDoctorListTile(
                        doctor: doctor,
                        onTap: () => DoctorDetailsRoute(
                          doctor.toDoctorModel(),
                        ).push(context),
                        onEdit: () => CreateDoctorRoute(doctor).push(context),
                        onDelete: () => _confirmDeleteDoctor(doctor),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
