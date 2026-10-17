import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class SpecialtyDropdownField extends StatelessWidget {
  const SpecialtyDropdownField({
    super.key,
    required this.specialties,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  final List<SpecialtyModel> specialties;
  final SpecialtyModel? value;
  final ValueChanged<SpecialtyModel?> onChanged;
  final FormFieldValidator<SpecialtyModel>? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<SpecialtyModel>(
      initialValue: value,
      isExpanded: true,
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      dropdownColor: AppColors.surface,
      menuMaxHeight: 320,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.textMain,
        size: 22,
      ),
      decoration: InputDecoration(
        hintText: tr.selectSpecialtyHint,
        hintStyle: context.regular16TextMain.copyWith(
          color: AppColors.textSecondary.withValues(alpha: 0.7),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      style: context.regular16TextMain,
      selectedItemBuilder: (context) {
        return specialties.map((specialty) {
          return Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              specialty.localizedName,
              style: context.semiBold16TextMain,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList();
      },
      items: specialties.map((specialty) {
        final isSelected = specialty.id == value?.id;
        return DropdownMenuItem<SpecialtyModel>(
          value: specialty,
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  specialty.icon,
                  size: 18,
                  color: isSelected ? AppColors.primary : AppColors.primaryDark,
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  specialty.localizedName,
                  style: isSelected
                      ? context.semiBold14Primary
                      : context.medium14TextMain,
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}

class DoctorImagePickerField extends StatelessWidget {
  const DoctorImagePickerField({
    super.key,
    required this.imageUrl,
    required this.selectedBytes,
    required this.onPick,
    this.isUploading = false,
  });

  final String? imageUrl;
  final Uint8List? selectedBytes;
  final VoidCallback onPick;
  final bool isUploading;

  static const double _size = 112;

  @override
  Widget build(BuildContext context) {
    final hasImage = selectedBytes != null || (imageUrl?.isNotEmpty ?? false);

    return GestureDetector(
      onTap: isUploading ? null : onPick,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: _size,
                height: _size,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: hasImage
                      ? null
                      : Border.all(color: AppColors.disabled, width: 2),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (selectedBytes != null)
                      Image.memory(selectedBytes!, fit: BoxFit.cover)
                    else if (hasImage)
                      DoctorImage(
                        imageUrl: imageUrl,
                        width: _size,
                        height: _size,
                        fallback: const DoctorAvatarPlaceholder(size: _size),
                      )
                    else
                      const Icon(
                        Icons.photo_camera_outlined,
                        size: 32,
                        color: AppColors.textSecondary,
                      ),
                    if (isUploading)
                      const ColoredBox(
                        color: AppColors.shadowStrong,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (hasImage)
                PositionedDirectional(
                  end: 0,
                  bottom: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.photo_camera_outlined,
                      size: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),
            ],
          ),
          12.verticalSpace,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasImage) ...[
                const Icon(
                  Icons.photo_camera_outlined,
                  size: 14,
                  color: AppColors.primary,
                ),
                4.horizontalSpace,
              ],
              Text(
                hasImage ? tr.tapPhotoToChange : tr.addPhoto,
                style: context.medium12Primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
