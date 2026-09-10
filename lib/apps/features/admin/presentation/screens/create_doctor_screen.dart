import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/validators.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_field.dart';
import 'package:doctor_hunt/apps/features/admin/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/data/service/admin_doctor_service.dart';
import 'package:doctor_hunt/apps/features/admin/data/service/cloudinary_upload_service.dart';
import 'package:doctor_hunt/apps/features/admin/presentation/widgets/create_doctor_widgets.dart';
import 'package:doctor_hunt/apps/features/specialty/data/models/specialty_model.dart';
import 'package:doctor_hunt/apps/features/specialty/data/service/specialty_service.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class CreateDoctorScreen extends StatefulWidget {
  const CreateDoctorScreen({super.key, this.doctor});

  final AdminDoctorModel? doctor;

  @override
  State<CreateDoctorScreen> createState() => CreateDoctorScreenState();
}

class CreateDoctorScreenState extends State<CreateDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameArController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _doctorService = AdminDoctorService();
  final _specialtyService = SpecialtyService();
  final _imagePicker = ImagePicker();
  final _cloudinaryService = CloudinaryUploadService();

  late final Future<List<SpecialtyModel>> _specialtiesFuture;
  SpecialtyModel? _specialty;
  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;
  String? _imageUrl;
  bool _isSaving = false;
  bool _isUploadingImage = false;

  bool get isEditing => widget.doctor != null;

  @override
  void initState() {
    super.initState();
    _specialtiesFuture = _specialtyService.fetchActiveSpecialties();
    if (isEditing) {
      final doctor = widget.doctor!;
      _nameArController.text = doctor.nameAr ?? doctor.name;
      _nameEnController.text = doctor.nameEn ?? doctor.name;
      _imageUrl = doctor.imageUrl;
      _specialtiesFuture.then((specialties) {
        if (!mounted) return;
        final specialtyId = doctor.specialtyId?.trim().toLowerCase();
        setState(() {
          _specialty = specialties.where((item) {
            return (specialtyId != null && specialtyId == item.id) ||
                item.localizedName.toLowerCase() ==
                    doctor.specialty.toLowerCase();
          }).firstOrNull;
        });
      });
    }
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (image == null) return;

      final bytes = await image.readAsBytes();
      if (!mounted) return;
      setState(() {
        _selectedImage = image;
        _selectedImageBytes = bytes;
      });
    } catch (_) {
      if (!mounted) return;
      context.showErrorSnackBar(tr.pickImageError);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _specialty == null) {
      if (_specialty == null) {
        context.showErrorSnackBar(tr.selectSpecialtyError);
      }
      return;
    }
    if (!isEditing && _selectedImage == null) {
      context.showErrorSnackBar(tr.tapToPickImage);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);
    try {
      final fullNameAr = _nameArController.text.trim();
      final fullNameEn = _nameEnController.text.trim();
      var imageUrl = _imageUrl;
      if (_selectedImage != null) {
        setState(() => _isUploadingImage = true);
        try {
          imageUrl = await _cloudinaryService.uploadImage(
            bytes: _selectedImageBytes!,
            fileName: _selectedImage!.name,
          );
          _imageUrl = imageUrl;
        } catch (_) {
          if (!mounted) return;
          context.showErrorSnackBar(tr.uploadImageError);
          return;
        } finally {
          if (mounted) setState(() => _isUploadingImage = false);
        }
      }
      if (isEditing) {
        await _doctorService.updateDoctor(
          id: widget.doctor!.id,
          fullNameAr: fullNameAr,
          fullNameEn: fullNameEn,
          specialtyId: _specialty!.id,
          imageUrl: imageUrl,
        );
      } else {
        await _doctorService.createDoctor(
          fullNameAr: fullNameAr,
          fullNameEn: fullNameEn,
          specialtyId: _specialty!.id,
          imageUrl: imageUrl,
        );
      }

      if (!mounted) return;
      context.showSuccessSnackBar(
        isEditing ? tr.doctorUpdatedSuccess : tr.doctorCreatedSuccess,
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      context.showErrorSnackBar(AppException.from(e).message);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _isUploadingImage = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          AppHeaderSection(
            title: isEditing ? tr.editDoctorTitle : tr.createDoctorTitle,
            onBackTap: () => context.pop(),
            showSearchBar: false,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${tr.doctorNameLabel} (AR)',
                      style: context.semiBold14TextMain,
                    ),
                    8.verticalSpace,
                    AppTextField(
                      controller: _nameArController,
                      hintText: tr.doctorNameHint,
                      prefixIcon: Icons.person_outline_rounded,
                      textInputAction: TextInputAction.next,
                      validator: AppValidators.validateDoctorName,
                    ),
                    20.verticalSpace,
                    Text(
                      '${tr.doctorNameLabel} (EN)',
                      style: context.semiBold14TextMain,
                    ),
                    8.verticalSpace,
                    AppTextField(
                      controller: _nameEnController,
                      hintText: tr.doctorNameHint,
                      prefixIcon: Icons.person_outline_rounded,
                      textInputAction: TextInputAction.next,
                      validator: AppValidators.validateDoctorName,
                    ),
                    20.verticalSpace,
                    Text(tr.specialtyLabel, style: context.semiBold14TextMain),
                    8.verticalSpace,
                    FutureBuilder<List<SpecialtyModel>>(
                      future: _specialtiesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 18),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (snapshot.hasError || snapshot.data!.isEmpty) {
                          return Text(
                            tr.serviceError,
                            style: context.regular14TextSecondary,
                          );
                        }
                        return SpecialtyDropdownField(
                          specialties: snapshot.data!,
                          value: _specialty,
                          onChanged: (value) =>
                              setState(() => _specialty = value),
                          validator: (value) =>
                              value == null ? tr.selectSpecialtyError : null,
                        );
                      },
                    ),
                    20.verticalSpace,
                    Text(
                      tr.doctorImageLabel,
                      style: context.semiBold14TextMain,
                    ),
                    8.verticalSpace,
                    DoctorImagePickerField(
                      imageUrl: _imageUrl,
                      selectedBytes: _selectedImageBytes,
                      isUploading: _isUploadingImage,
                      onPick: _pickImage,
                      onClear: () => setState(() {
                        _selectedImage = null;
                        _selectedImageBytes = null;
                      }),
                    ),
                    32.verticalSpace,
                    AppPrimaryButton(
                      label: isEditing
                          ? tr.updateDoctorButton
                          : tr.createDoctorButton,
                      isLoading: _isSaving,
                      onPressed: _isSaving ? null : _submit,
                      height: 54,
                      fontSize: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
