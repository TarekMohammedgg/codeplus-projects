import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_filter_chips.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_state.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/widgets/admin_doctors_widgets.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:doctor_hunt/apps/core/widgets/app_list_skeleton.dart';

class AdminDoctorsScreen extends StatefulWidget {
  const AdminDoctorsScreen({super.key});

  @override
  State<AdminDoctorsScreen> createState() => AdminDoctorsScreenState();
}

class AdminDoctorsScreenState extends State<AdminDoctorsScreen> {
  final _searchController = TextEditingController();
  late final AdminDoctorsCubit _adminDoctorsCubit;

  String _query = '';

  /// Null = "All".
  String? _specialtyId;

  @override
  void initState() {
    super.initState();
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

  List<AdminDoctorModel> _filter(List<AdminDoctorModel> doctors) {
    final query = _query.trim().toLowerCase();
    return doctors.where((doctor) {
      if (_specialtyId != null && doctor.specialtyId != _specialtyId) {
        return false;
      }
      if (query.isEmpty) return true;
      return [
        doctor.name,
        doctor.nameAr,
        doctor.nameEn,
        doctor.specialty,
      ].any((text) => text?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  Future<void> _confirmToggleActive(AdminDoctorModel doctor) async {
    final activate = !doctor.isActive;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          activate ? tr.activateDoctorTitle : tr.deactivateDoctorTitle,
          style: context.semiBold16TextMain,
        ),
        content: Text(
          activate ? tr.activateDoctorConfirm : tr.deactivateDoctorConfirm,
          style: context.regular14TextSecondary,
        ),
        actions: [
          AppTextButton(
            label: tr.cancel,
            onPressed: () => Navigator.of(dialogContext).pop(false),
            textStyle: context.medium14TextSecondary,
          ),
          AppTextButton(
            label: activate ? tr.activate : tr.deactivate,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            foregroundColor: activate ? AppColors.success : AppColors.error,
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    try {
      await _adminDoctorsCubit.setActive(doctor.id, activate);
      if (!mounted) return;
      context.showSuccessSnackBar(
        activate ? tr.doctorActivatedSuccess : tr.doctorDeactivatedSuccess,
      );
    } catch (e) {
      if (!mounted) return;
      context.showErrorSnackBar(AppException.from(e).message);
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
        );
      },
    );
  }

  Widget _buildDoctorsContent(BuildContext context, AdminDoctorsState state) {
    return switch (state) {
      AdminDoctorsInitial() || AdminDoctorsLoading() => AppListSkeleton(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 88),
        spacing: 12,
        itemBuilder: (_) => AdminDoctorListTile(
          doctor: AdminDoctorModel(
            id: '',
            name: BoneMock.fullName,
            specialty: BoneMock.name,
          ),
        ),
      ),
      AdminDoctorsFailure() => Center(
        child: Text(tr.serviceError, style: context.semiBold16TextMain),
      ),
      AdminDoctorsSuccess() => _buildDoctorsList(context, state),
    };
  }

  Widget _buildDoctorsList(BuildContext context, AdminDoctorsSuccess state) {
    final doctors = state.doctors;
    final filtered = _filter(doctors);
    final activeCount = doctors.where((doctor) => doctor.isActive).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: AdminStatsRow(
            totalCount: doctors.length,
            activeCount: activeCount,
          ),
        ),
        12.verticalSpace,
        DoctorFilterChips(
          specialties: state.specialties,
          selectedSpecialtyId: _specialtyId,
          onSpecialtySelected: (id) => setState(() => _specialtyId = id),
        ),
        12.verticalSpace,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        onTap: () =>
                            AdminDoctorDetailsRoute(doctor).push(context),
                        onEdit: () => CreateDoctorRoute(doctor).push(context),
                        onToggleActive: () => _confirmToggleActive(doctor),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
