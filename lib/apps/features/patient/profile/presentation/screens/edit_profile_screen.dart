import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/services/cloudinary_upload_service.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/phone_utils.dart';
import 'package:doctor_hunt/apps/core/utils/validators.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_field.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/repositories/profile_repository.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    this.profile,
    this.profileRepository,
    this.uploadService,
    this.auth,
  });

  final UserProfileModel? profile;
  final ProfileRepository? profileRepository;
  final CloudinaryUploadService? uploadService;
  final FirebaseAuth? auth;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  DateTime? _selectedDob;
  String _selectedGender = 'male';
  String? _currentPhotoUrl;

  Uint8List? _newImageBytes;
  String? _newImageName;

  bool _isSaving = false;

  ProfileRepository get _repository =>
      widget.profileRepository ?? getIt<ProfileRepository>();
  CloudinaryUploadService get _uploadService =>
      widget.uploadService ?? getIt<CloudinaryUploadService>();
  FirebaseAuth get _auth => widget.auth ?? getIt<FirebaseAuth>();

  @override
  void initState() {
    super.initState();
    final profile = widget.profile;
    final currentUser = _auth.currentUser;

    _nameController = TextEditingController(
      text: profile?.name.isNotEmpty == true
          ? profile!.name
          : currentUser?.displayName ?? '',
    );
    _emailController = TextEditingController(
      text: profile?.email.isNotEmpty == true
          ? profile!.email
          : currentUser?.email ?? '',
    );
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _selectedDob = profile?.dob;
    _selectedGender = (profile?.gender != null && profile!.gender!.isNotEmpty)
        ? profile.gender!.toLowerCase()
        : 'male';
    _currentPhotoUrl = profile?.avatarUrl ?? currentUser?.photoURL;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
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
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _newImageBytes = bytes;
          _newImageName = picked.name;
        });
      }
    } catch (_) {
      if (mounted) {
        context.showErrorSnackBar(context.tr.pickImageError);
      }
    }
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final initialDate = _selectedDob ?? DateTime(2000, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(now) ? initialDate : now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _selectedDob = picked);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSaving) return;

    final user = _auth.currentUser;
    final uid = widget.profile?.uid.isNotEmpty == true
        ? widget.profile!.uid
        : user?.uid;
    if (uid == null || uid.isEmpty) return;

    setState(() => _isSaving = true);
    try {
      var photoUrl = _currentPhotoUrl;
      if (_newImageBytes != null) {
        photoUrl = await _uploadService.uploadImage(
          bytes: _newImageBytes!,
          fileName: _newImageName ?? 'profile_$uid.jpg',
        );
      }

      final normalizedPhone = PhoneUtils.normalizePhoneNumber(
        _phoneController.text.trim(),
      );
      final newName = _nameController.text.trim();

      await _repository.updateProfile(
        uid: uid,
        displayName: newName,
        phone: normalizedPhone,
        dob: _selectedDob,
        gender: _selectedGender,
        photoUrl: photoUrl,
      );

      await user?.updateDisplayName(newName);
      if (photoUrl != null && photoUrl.isNotEmpty) {
        await user?.updatePhotoURL(photoUrl);
      }

      if (!mounted) return;
      context.showSuccessSnackBar(context.tr.profileUpdatedSuccess);
      context.pop();
    } catch (e) {
      if (!mounted) return;
      context.showErrorSnackBar(AppException.from(e).message);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.tr.$meta.locale.languageCode;
    final formattedDob = _selectedDob != null
        ? DateFormat.yMMMd(locale).format(_selectedDob!)
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: AppIconButton.back(onTap: () => context.pop()),
        centerTitle: true,
        title: Text(
          context.tr.editProfile,
          style: context.bold18TextMain,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.outline, width: 2),
                      ),
                      child: ClipOval(
                        child: _newImageBytes != null
                            ? Image.memory(
                                _newImageBytes!,
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                              )
                            : DoctorImage(
                                imageUrl: _currentPhotoUrl,
                                fallback: const DoctorAvatarPlaceholder(
                                  circle: true,
                                ),
                              ),
                      ),
                    ),
                    PositionedDirectional(
                      bottom: 0,
                      end: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              28.verticalSpace,
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  context.tr.fullName,
                  style: context.semiBold14TextMain,
                ),
              ),
              8.verticalSpace,
              AppTextField(
                key: const Key('edit_profile_name_field'),
                controller: _nameController,
                hintText: context.tr.enterFullName,
                prefixIcon: Icons.person_outline_rounded,
                validator: AppValidators.validateName,
              ),
              20.verticalSpace,
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  context.tr.email,
                  style: context.semiBold14TextMain,
                ),
              ),
              8.verticalSpace,
              AppTextField(
                key: const Key('edit_profile_email_field'),
                controller: _emailController,
                hintText: context.tr.emailAddress,
                prefixIcon: Icons.email_outlined,
                enabled: false,
                readOnly: true,
              ),
              20.verticalSpace,
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  context.tr.contactNumber,
                  style: context.semiBold14TextMain,
                ),
              ),
              8.verticalSpace,
              AppTextField(
                key: const Key('edit_profile_phone_field'),
                controller: _phoneController,
                hintText: context.tr.enterPhoneNumber,
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: AppValidators.validatePhone,
              ),
              20.verticalSpace,
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  context.tr.dateOfBirth,
                  style: context.semiBold14TextMain,
                ),
              ),
              8.verticalSpace,
              InkWell(
                onTap: _pickDob,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      12.horizontalSpace,
                      Text(
                        formattedDob ?? context.tr.selectDob,
                        style: formattedDob != null
                            ? context.semiBold14TextMain
                            : context.regular14TextSecondary,
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              20.verticalSpace,
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  context.tr.gender,
                  style: context.semiBold14TextMain,
                ),
              ),
              8.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: _GenderOption(
                      label: context.tr.male,
                      icon: Icons.male_rounded,
                      isSelected: _selectedGender == 'male',
                      onTap: () => setState(() => _selectedGender = 'male'),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: _GenderOption(
                      label: context.tr.female,
                      icon: Icons.female_rounded,
                      isSelected: _selectedGender == 'female',
                      onTap: () => setState(() => _selectedGender = 'female'),
                    ),
                  ),
                ],
              ),
              32.verticalSpace,
              AppPrimaryButton(
                key: const Key('edit_profile_save_button'),
                label: context.tr.save,
                height: 52,
                isLoading: _isSaving,
                onPressed: _saveProfile,
              ),
              24.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            8.horizontalSpace,
            Text(
              label,
              style: context.semiBold14TextMain.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textMain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
