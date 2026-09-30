import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/services/cloudinary_upload_service.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/validators.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_field.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/features/admin/profile/data/repositories/admin_profile_repository.dart';
import 'package:doctor_hunt/apps/features/admin/profile/presentation/controller/cubit/admin_profile_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/profile/presentation/controller/cubit/admin_profile_state.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({
    super.key,
    this.cubit,
    this.repository,
    this.uploadService,
    this.auth,
  });

  final AdminProfileCubit? cubit;
  final AdminProfileRepository? repository;
  final CloudinaryUploadService? uploadService;
  final FirebaseAuth? auth;

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return BlocProvider<AdminProfileCubit>.value(
        value: cubit!,
        child: const _AdminProfileView(),
      );
    }

    final effectiveRepo = repository ?? getIt<AdminProfileRepository>();
    final effectiveUpload = uploadService ?? getIt<CloudinaryUploadService>();

    return BlocProvider<AdminProfileCubit>(
      create: (_) {
        final currentUid =
            (auth ?? getIt<FirebaseAuth>()).currentUser?.uid ?? '';
        final c = AdminProfileCubit(
          repository: effectiveRepo,
          uploadService: effectiveUpload,
        );
        if (currentUid.isNotEmpty) {
          c.loadProfile(currentUid);
        }
        return c;
      },
      child: const _AdminProfileView(),
    );
  }
}

class _AdminProfileView extends StatefulWidget {
  const _AdminProfileView();

  @override
  State<_AdminProfileView> createState() => _AdminProfileViewState();
}

class _AdminProfileViewState extends State<_AdminProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressArController;
  late final TextEditingController _addressEnController;

  LatLng? _selectedLocation;
  Uint8List? _newImageBytes;
  String? _newImageName;
  bool _initialized = false;

  static const LatLng _defaultLocation = LatLng(30.0444, 31.2357);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _addressArController = TextEditingController();
    _addressEnController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressArController.dispose();
    _addressEnController.dispose();
    super.dispose();
  }

  void _populateFromState(AdminProfileState state) {
    if (_initialized) return;
    if (state.status == AdminProfileStatus.loaded ||
        state.displayName.isNotEmpty ||
        state.addressAr.isNotEmpty ||
        state.addressEn.isNotEmpty) {
      _nameController.text = state.displayName;
      _emailController.text = state.email;
      _addressArController.text = state.addressAr;
      _addressEnController.text = state.addressEn;
      _selectedLocation = state.location ?? _defaultLocation;
      _initialized = true;
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      if (!mounted) return;
      setState(() {
        _newImageBytes = bytes;
        _newImageName = picked.name;
      });
    } catch (_) {}
  }

  void _popScreen(BuildContext context) {
    try {
      if (context.canPop()) {
        context.pop();
        return;
      }
    } catch (_) {}
    Navigator.of(context).maybePop();
  }

  void _save(BuildContext context, AdminProfileState state) {
    if (!_formKey.currentState!.validate()) return;

    final location = _selectedLocation ?? state.location ?? _defaultLocation;

    final auth = getIt.isRegistered<FirebaseAuth>()
        ? getIt<FirebaseAuth>()
        : FirebaseAuth.instance;
    final uid = auth.currentUser?.uid ?? 'admin';

    context.read<AdminProfileCubit>().saveProfileAndClinic(
      uid: uid,
      displayName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      addressAr: _addressArController.text.trim(),
      addressEn: _addressEnController.text.trim(),
      location: location,
      newImageBytes: _newImageBytes,
      newImageName: _newImageName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminProfileCubit, AdminProfileState>(
      listener: (context, state) {
        _populateFromState(state);

        if (state.status == AdminProfileStatus.success) {
          final message = state.emailVerificationSent
              ? context.tr.emailVerificationSent(email: _emailController.text)
              : context.tr.adminProfileUpdatedSuccess;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
          _popScreen(context);
        } else if (state.status == AdminProfileStatus.failure) {
          final message = state.errorMessage == 'requires-recent-login'
              ? context.tr.requiresRecentLogin
              : (state.errorMessage ?? 'Error');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        _populateFromState(state);

        final activeLocation =
            _selectedLocation ?? state.location ?? _defaultLocation;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Top App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      AppIconButton.back(onTap: () => _popScreen(context)),
                      12.horizontalSpace,
                      Expanded(
                        child: Text(
                          context.tr.adminProfile,
                          style: context.bold18TextMain,
                        ),
                      ),
                    ],
                  ),
                ),

                if (state.status == AdminProfileStatus.loading && !_initialized)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            12.verticalSpace,

                            // Avatar Picker
                            Center(
                              child: Stack(
                                children: [
                                  ClipOval(
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: _newImageBytes != null
                                          ? Image.memory(
                                              _newImageBytes!,
                                              fit: BoxFit.cover,
                                            )
                                          : (state.currentPhotoUrl != null &&
                                                    state
                                                        .currentPhotoUrl!
                                                        .isNotEmpty
                                                ? DoctorImage(
                                                    imageUrl:
                                                        state.currentPhotoUrl!,
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                    fallback:
                                                        const DoctorAvatarPlaceholder(
                                                          size: 100,
                                                        ),
                                                  )
                                                : const DoctorAvatarPlaceholder(
                                                    size: 100,
                                                  )),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      key: const Key(
                                        'admin_profile_change_photo',
                                      ),
                                      onTap: _pickImage,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.white,
                                            width: 2,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: AppColors.shadowControl,
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt_rounded,
                                          size: 16,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            24.verticalSpace,

                            // Full Name
                            AppTextField(
                              key: const Key('admin_profile_name_field'),
                              controller: _nameController,
                              labelText: context.tr.personalInformation,
                              hintText: context.tr.enterFullName,
                              prefixIcon: Icons.person_outline_rounded,
                              validator: AppValidators.validateName,
                            ),

                            16.verticalSpace,

                            // Email
                            AppTextField(
                              key: const Key('admin_profile_email_field'),
                              controller: _emailController,
                              labelText: context.tr.email,
                              hintText: context.tr.enterEmailAddress,
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: AppValidators.validateEmail,
                            ),

                            28.verticalSpace,

                            // Clinic Information Section Header
                            Text(
                              context.tr.clinicLocation,
                              style: context.bold16TextMain,
                            ),
                            6.verticalSpace,
                            Text(
                              context.tr.tapMapToSetLocation,
                              style: context.regular12TextSecondary,
                            ),

                            14.verticalSpace,

                            // Clinic Address Arabic
                            AppTextField(
                              key: const Key('admin_profile_address_ar_field'),
                              controller: _addressArController,
                              labelText: context.tr.clinicAddressAr,
                              hintText: context.tr.clinicAddressAr,
                              prefixIcon: Icons.location_city_outlined,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return context.tr.clinicAddressArRequired;
                                }
                                return null;
                              },
                            ),

                            16.verticalSpace,

                            // Clinic Address English
                            AppTextField(
                              key: const Key('admin_profile_address_en_field'),
                              controller: _addressEnController,
                              labelText: context.tr.clinicAddressEn,
                              hintText: context.tr.clinicAddressEn,
                              prefixIcon: Icons.location_city_outlined,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return context.tr.clinicAddressEnRequired;
                                }
                                return null;
                              },
                            ),

                            20.verticalSpace,

                            // FlutterMap Location Picker
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                key: const Key('admin_profile_map'),
                                height: 220,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.mapPlaceholder,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.outline),
                                ),
                                child: FlutterMap(
                                  options: MapOptions(
                                    initialCenter: activeLocation,
                                    initialZoom: 14.0,
                                    onTap: (tapPosition, point) {
                                      setState(() {
                                        _selectedLocation = point;
                                      });
                                      context
                                          .read<AdminProfileCubit>()
                                          .setLocation(point);
                                    },
                                    interactionOptions:
                                        const InteractionOptions(
                                          flags:
                                              InteractiveFlag.all &
                                              ~InteractiveFlag.rotate,
                                        ),
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName: 'doctor_hunt',
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          key: const Key(
                                            'admin_profile_location_marker',
                                          ),
                                          point: activeLocation,
                                          width: 44,
                                          height: 44,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.primary
                                                      .withValues(alpha: 0.35),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.location_on_rounded,
                                              color: AppColors.white,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            8.verticalSpace,
                            Row(
                              children: [
                                const Icon(
                                  Icons.pin_drop_outlined,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                6.horizontalSpace,
                                Text(
                                  '${activeLocation.latitude.toStringAsFixed(4)}, ${activeLocation.longitude.toStringAsFixed(4)}',
                                  style: context.regular12TextSecondary,
                                ),
                              ],
                            ),

                            32.verticalSpace,

                            // Save Button
                            SizedBox(
                              width: double.infinity,
                              child: AppPrimaryButton(
                                key: const Key('admin_profile_save_button'),
                                label: context.tr.save,
                                isLoading:
                                    state.status == AdminProfileStatus.saving,
                                onPressed: () => _save(context, state),
                              ),
                            ),

                            32.verticalSpace,
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
