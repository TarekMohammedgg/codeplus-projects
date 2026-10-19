import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/extensions/app_error_text.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_empty_state.dart';
import 'package:doctor_hunt/apps/core/widgets/app_profile_avatar.dart';
import 'package:doctor_hunt/apps/core/widgets/app_search_bar.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_filter_chips.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_state.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/widgets/admin_doctors_widgets.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/apps/core/widgets/skeleton_placeholders.dart';
import 'package:doctor_hunt/apps/core/widgets/app_list_skeleton.dart';

class AdminDoctorsScreen extends StatefulWidget {
  const AdminDoctorsScreen({super.key, this.adminPhotoUrl});

  final String? adminPhotoUrl;

  @override
  State<AdminDoctorsScreen> createState() => AdminDoctorsScreenState();
}

class AdminDoctorsScreenState extends State<AdminDoctorsScreen> {
  final _searchController = TextEditingController();
  late final AdminDoctorsCubit _adminDoctorsCubit;

  String _query = '';

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

  List<DoctorModel> _filter(List<DoctorModel> doctors) {
    final query = _query.trim().toLowerCase();
    return doctors.where((doctor) {
      if (_specialtyId != null && doctor.specialtyId != _specialtyId) {
        return false;
      }
      return doctor.nameContains(query) ||
          doctor.specialty.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _confirmToggleActive(DoctorModel doctor) async {
    final activate = !doctor.isActive;
    final confirmed = await showToggleDoctorActiveDialog(
      context,
      activate: activate,
    );

    if (!confirmed || !mounted) return;
    try {
      await _adminDoctorsCubit.setActive(doctor.id, activate);
      if (!mounted) return;
      context.showSuccessSnackBar(
        activate ? tr.doctorActivatedSuccess : tr.doctorDeactivatedSuccess,
      );
    } catch (e) {
      if (!mounted) return;
      context.showErrorSnackBar(context.errorText(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDoctorsCubit, AdminDoctorsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                Expanded(child: _buildDoctorsContent(context, state)),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => const CreateDoctorRoute().push(context),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: const StadiumBorder(),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(tr.addDoctor, style: context.regular12White),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(tr.doctorsTitle, style: context.bold18TextMain)),
          AppProfileAvatar(
            imageUrl: widget.adminPhotoUrl,
            onTap: () => const AdminProfileRoute().push(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AppSearchBar(
        controller: _searchController,
        hintText: tr.searchAdminDoctorsHint,
        height: 44,
        borderRadius: BorderRadius.circular(12),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.textMuted,
          size: 18,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
        onChanged: (value) => setState(() => _query = value),
      ),
    );
  }

  Widget _buildDoctorsContent(BuildContext context, AdminDoctorsState state) {
    return switch (state) {
      AdminDoctorsInitial() || AdminDoctorsLoading() => AppListSkeleton(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 88),
        spacing: 12,
        itemBuilder: (_) => AdminDoctorListTile(doctor: skeletonDoctor()),
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
    final counts = <String?, int>{null: doctors.length};
    for (final doctor in doctors) {
      counts.update(doctor.specialtyId, (n) => n + 1, ifAbsent: () => 1);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: AdminStatsRow(
            totalCount: doctors.length,
            activeCount: activeCount,
          ),
        ),
        _buildSearchBar(),
        if (doctors.isEmpty)
          Expanded(
            child: AppEmptyState(
              image: const _NoDoctorsIcon(),
              title: tr.noDoctorsFound,
              titleStyle: context.bold16TextMain,
              subtitle: tr.noDoctorsYet,
            ),
          )
        else ...[
          14.verticalSpace,
          DoctorFilterChips(
            specialties: state.specialties,
            selectedSpecialtyId: _specialtyId,
            counts: counts,
            onSpecialtySelected: (id) => setState(() => _specialtyId = id),
          ),
          16.verticalSpace,
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      tr.noDoctorsFound,
                      textAlign: TextAlign.center,
                      style: context.regular14TextSecondary,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 88),
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
        ],
      ],
    );
  }
}

class _NoDoctorsIcon extends StatelessWidget {
  const _NoDoctorsIcon();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryLight),
          ),
          child: const Icon(
            Icons.medical_services_outlined,
            size: 40,
            color: AppColors.primary,
          ),
        ),
        PositionedDirectional(
          end: -4,
          bottom: -4,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 2),
            ),
            child: const Icon(
              Icons.add_rounded,
              size: 16,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
