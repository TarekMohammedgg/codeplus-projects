import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/image_pick.dart';
import 'package:doctor_hunt/apps/core/utils/validators.dart';
import 'package:doctor_hunt/apps/core/widgets/app_field_label.dart';
import 'package:doctor_hunt/apps/core/widgets/app_back_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_field.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/controller/cubit/create_doctor_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/controller/cubit/create_doctor_state.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/widgets/create_doctor_widgets.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CreateDoctorScreen extends StatefulWidget {
  const CreateDoctorScreen({super.key, this.doctor});

  final DoctorModel? doctor;

  @override
  State<CreateDoctorScreen> createState() => CreateDoctorScreenState();
}

class CreateDoctorScreenState extends State<CreateDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameArController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _feeController = TextEditingController();
  late final CreateDoctorCubit _createDoctorCubit;

  SpecialtyModel? _specialty;
  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;
  String? _imageUrl;

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
      _nameArController.text = doctor.nameAr;
      _nameEnController.text = doctor.nameEn;
      if (doctor.consultationFee > 0) {
        _feeController.text = _formatFee(doctor.consultationFee);
      }
      _imageUrl = doctor.imageUrl;
    }
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  static String _formatFee(double fee) =>
      fee == fee.roundToDouble() ? fee.toStringAsFixed(0) : fee.toString();

  Future<void> _pickImage() async {
    try {
      final image = await pickGalleryImage(maxWidth: 1600, maxHeight: null);
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

  void _submit() {
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
    _createDoctorCubit.submit(
      doctorId: widget.doctor?.id,
      fullNameAr: _nameArController.text.trim(),
      fullNameEn: _nameEnController.text.trim(),
      specialtyId: _specialty!.id,
      consultationFee: double.parse(_feeController.text.trim()),
      imageUrl: _imageUrl,
      imageBytes: _selectedImageBytes,
      imageName: _selectedImage?.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateDoctorCubit, CreateDoctorState>(
      listener: (context, state) {
        switch (state) {
          case CreateDoctorFailure(:final errorMessage):
            context.showErrorSnackBar(errorMessage);
          case CreateDoctorSuccess(submit: CreateDoctorSubmit.saved):
            context.showSuccessSnackBar(
              isEditing ? tr.doctorUpdatedSuccess : tr.doctorCreatedSuccess,
            );
            context.pop();
          case CreateDoctorSuccess(
            submit: CreateDoctorSubmit.failed,
            :final submitError,
          ):
            context.showErrorSnackBar(submitError ?? tr.serviceError);
          case CreateDoctorSuccess(:final specialties):
            _selectEditingSpecialty(specialties);
          default:
            break;
        }
      },
      builder: (context, state) {
        final submit = state is CreateDoctorSuccess
            ? state.submit
            : CreateDoctorSubmit.idle;
        final isSaving = state is CreateDoctorSuccess && state.isSubmitting;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: AppBackButton.leading(onTap: () => context.pop()),
            centerTitle: true,
            title: Text(
              isEditing ? tr.editDoctorTitle : tr.createDoctorTitle,
              style: context.bold18TextMain,
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: DoctorImagePickerField(
                      imageUrl: _imageUrl,
                      selectedBytes: _selectedImageBytes,
                      isUploading: submit == CreateDoctorSubmit.uploadingImage,
                      onPick: _pickImage,
                    ),
                  ),
                  24.verticalSpace,
                  AppFieldLabel(tr.doctorNameArLabel),
                  AppTextField(
                    controller: _nameArController,
                    hintText: tr.doctorNameHint,
                    prefixIcon: Icons.person_outline_rounded,
                    textInputAction: TextInputAction.next,
                    validator: AppValidators.validateDoctorName,
                  ),
                  16.verticalSpace,
                  AppFieldLabel(tr.doctorNameEnLabel),
                  AppTextField(
                    controller: _nameEnController,
                    hintText: tr.doctorNameHint,
                    prefixIcon: Icons.person_outline_rounded,
                    textInputAction: TextInputAction.next,
                    validator: AppValidators.validateDoctorName,
                  ),
                  16.verticalSpace,
                  AppFieldLabel(tr.specialtyLabel),
                  _buildSpecialtyField(context, state),
                  16.verticalSpace,
                  AppFieldLabel(tr.doctorFeeLabel),
                  AppTextField(
                    controller: _feeController,
                    hintText: tr.doctorFeeHint,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
                    ],
                    textInputAction: TextInputAction.done,
                    validator: AppValidators.validateFee,
                  ),
                  32.verticalSpace,
                  AppPrimaryButton(
                    label: isEditing ? tr.saveChanges : tr.createDoctorButton,
                    isLoading: isSaving,
                    onPressed: isSaving ? null : _submit,
                    height: 52,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpecialtyField(BuildContext context, CreateDoctorState state) {
    return switch (state) {
      CreateDoctorInitial() || CreateDoctorLoading() => Skeletonizer(
        child: SpecialtyDropdownField(
          specialties: const [],
          value: null,
          onChanged: (_) {},
        ),
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

    final selected = specialties
        .where((item) => item.id == widget.doctor!.specialtyId)
        .firstOrNull;

    if (selected != null) setState(() => _specialty = selected);
  }
}
