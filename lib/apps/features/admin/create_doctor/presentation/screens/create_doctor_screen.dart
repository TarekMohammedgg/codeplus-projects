import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:doctor_hunt/apps/features/admin/doctors/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/controller/cubit/create_doctor_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/controller/cubit/create_doctor_state.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/widgets/create_doctor_widgets.dart';
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
  final _imagePicker = ImagePicker();
  late final CreateDoctorCubit _createDoctorCubit;

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
    //CR Bad DI: Avoid checking `getIt.isRegistered` with manual fallback instantiations in UI initState.
    // solved
    //CR Use `getIt<Cubit>()` directly or inject via constructor.
    // solved
    //CR Bad DI: Avoid checking `getIt.isRegistered` with manual fallback instantiations in UI initState.
    // solved
    //CR Use `getIt<Cubit>()` directly or inject via constructor.
    // solved
    _createDoctorCubit = context.read<CreateDoctorCubit>();
    _createDoctorCubit.loadSpecialties();
    if (isEditing) {
      final doctor = widget.doctor!;
      _nameArController.text = doctor.nameAr ?? doctor.name;
      _nameEnController.text = doctor.nameEn ?? doctor.name;
      _imageUrl = doctor.imageUrl;
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
          imageUrl = await _createDoctorCubit.uploadImage(
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
        await _createDoctorCubit.updateDoctor(
          id: widget.doctor!.id,
          fullNameAr: fullNameAr,
          fullNameEn: fullNameEn,
          specialtyId: _specialty!.id,
          imageUrl: imageUrl,
        );
      } else {
        await _createDoctorCubit.createDoctor(
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
    return BlocConsumer<CreateDoctorCubit, CreateDoctorState>(
      listener: (context, state) {
        switch (state) {
          case CreateDoctorFailure(:final errorMessage):
            context.showErrorSnackBar(errorMessage);
          case CreateDoctorSuccess(:final specialties):
            _selectEditingSpecialty(specialties);
          default:
            break;
        }
      },
      builder: (context, state) {
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
                        Text(
                          tr.specialtyLabel,
                          style: context.semiBold14TextMain,
                        ),
                        8.verticalSpace,
                        _buildSpecialtyField(context, state),
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
      },
    );
  }

  Widget _buildSpecialtyField(BuildContext context, CreateDoctorState state) {
    return switch (state) {
      CreateDoctorInitial() || CreateDoctorLoading() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 18),
        child: Center(child: CircularProgressIndicator()),
      ),
      CreateDoctorFailure() => Text(
        tr.serviceError,
        style: context.regular14TextSecondary,
      ),
      CreateDoctorSuccess(:final specialties) when specialties.isEmpty => Text(
        tr.serviceError,
        style: context.regular14TextSecondary,
      ),
      CreateDoctorSuccess(:final specialties) => SpecialtyDropdownField(
        specialties: specialties,
        value: _specialty,
        onChanged: (value) => setState(() => _specialty = value),
        validator: (value) => value == null ? tr.selectSpecialtyError : null,
      ),
    };
  }

  void _selectEditingSpecialty(List<SpecialtyModel> specialties) {
    if (!isEditing || _specialty != null || !mounted) return;

    final doctor = widget.doctor!;
    final specialtyId = doctor.specialtyId?.trim().toLowerCase();
    final selected = specialties.where((item) {
      return (specialtyId != null && specialtyId == item.id) ||
          item.localizedName.toLowerCase() == doctor.specialty.toLowerCase();
    }).firstOrNull;

    if (selected != null) setState(() => _specialty = selected);
  }
}
