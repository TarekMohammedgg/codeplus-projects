import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
import 'package:doctor_hunt/apps/core/services/supabase_storage_service.dart';
import 'package:doctor_hunt/apps/features/admin/data/specialty_options.dart';
import 'package:doctor_hunt/apps/features/admin/presentation/widgets/create_doctor_widgets.dart';
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
  final _nameController = TextEditingController();
  final _doctorService = AdminDoctorService();
  final _imageService = SupabaseStorageService.instance;

  SpecialtyOption? _specialty;
  File? _pickedImage;
  String? _existingImageUrl;
  bool _isSaving = false;

  bool get isEditing => widget.doctor != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final doc = widget.doctor!;
      _nameController.text = doc.name;
      _existingImageUrl = doc.imageUrl;

      final options = specialtyOptions();
      final key = doc.specialtyKey?.trim().toLowerCase();
      final spec = doc.specialty.trim().toLowerCase();

      _specialty =
          options
              .where(
                (opt) =>
                    (key != null &&
                        key.isNotEmpty &&
                        opt.key.toLowerCase() == key) ||
                    opt.label.trim().toLowerCase() == spec,
              )
              .firstOrNull ??
          (doc.specialty.trim().isNotEmpty
              ? SpecialtyOption(
                  key: (key != null && key.isNotEmpty)
                      ? key
                      : doc.specialty.trim().toLowerCase().replaceAll(' ', '_'),
                  label: doc.specialty.trim(),
                )
              : null);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final image = await _imageService.pickImage();
      if (image == null) return;
      setState(() => _pickedImage = image);
    } catch (e) {
      if (!mounted) return;
      context.showErrorSnackBar(tr.pickImageError);
    }
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid || _specialty == null) {
      if (_specialty == null) {
        context.showErrorSnackBar(tr.selectSpecialtyError);
      }
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);
    try {
      String? imageUrl = _existingImageUrl;
      if (_pickedImage != null) {
        try {
          imageUrl = await _imageService.upload(_pickedImage!);
        } catch (_) {
          if (!mounted) return;
          context.showErrorSnackBar(tr.uploadImageError);
          setState(() => _isSaving = false);
          return;
        }
      }

      if (isEditing) {
        await _doctorService.updateDoctor(
          id: widget.doctor!.id,
          name: _nameController.text,
          specialty: _specialty!.label,
          specialtyKey: _specialty!.key,
          imageUrl: imageUrl,
        );

        if (!mounted) return;
        context.showSuccessSnackBar(tr.doctorUpdatedSuccess);
      } else {
        await _doctorService.createDoctor(
          name: _nameController.text,
          specialty: _specialty!.label,
          specialtyKey: _specialty!.key,
          imageUrl: imageUrl,
        );

        if (!mounted) return;
        context.showSuccessSnackBar(tr.doctorCreatedSuccess);
      }

      context.pop();
    } catch (e) {
      if (!mounted) return;
      context.showErrorSnackBar(AppException.from(e).message);
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
                    Text(tr.doctorNameLabel, style: context.semiBold14TextMain),
                    8.verticalSpace,
                    AppTextField(
                      controller: _nameController,
                      hintText: tr.doctorNameHint,
                      prefixIcon: Icons.person_outline_rounded,
                      textInputAction: TextInputAction.next,
                      validator: AppValidators.validateDoctorName,
                    ),
                    20.verticalSpace,
                    Text(tr.specialtyLabel, style: context.semiBold14TextMain),
                    8.verticalSpace,
                    SpecialtyDropdownField(
                      value: _specialty,
                      onChanged: (value) => setState(() => _specialty = value),
                      validator: (value) =>
                          value == null ? tr.selectSpecialtyError : null,
                    ),
                    20.verticalSpace,
                    Text(
                      tr.doctorImageLabel,
                      style: context.semiBold14TextMain,
                    ),
                    8.verticalSpace,
                    ImagePickerTile(
                      image: _pickedImage,
                      existingImageUrl: _existingImageUrl,
                      onTap: _pickImage,
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
