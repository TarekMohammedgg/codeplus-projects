import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_button.dart';
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
      icon: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: value != null
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: value != null ? AppColors.primary : AppColors.textSecondary,
          size: 22,
        ),
      ),
      decoration: InputDecoration(
        hintText: tr.selectSpecialtyHint,
        hintStyle: context.regular16TextMain.copyWith(
          color: AppColors.textSecondary.withValues(alpha: 0.7),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: value != null
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : AppColors.outline.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              value?.icon ?? Icons.medical_services_outlined,
              size: 18,
              color: value != null
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 52,
          minHeight: 48,
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
    this.onClear,
    this.isUploading = false,
  });

  final String? imageUrl;
  final Uint8List? selectedBytes;
  final VoidCallback onPick;
  final VoidCallback? onClear;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    final hasImage = selectedBytes != null || (imageUrl?.isNotEmpty ?? false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: isUploading ? null : onPick,
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.outline),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (selectedBytes != null)
                  Image.memory(selectedBytes!, fit: BoxFit.cover)
                else if (imageUrl?.isNotEmpty ?? false)
                  Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const _EmptyDoctorImage(),
                  )
                else
                  const _EmptyDoctorImage(),
                if (isUploading)
                  ColoredBox(
                    color: Colors.black54,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(color: Colors.white),
                          const SizedBox(height: 12),
                          Text(
                            tr.uploadDoctorImageTitle,
                            style: context.semiBold14TextMain.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!isUploading)
                  PositionedDirectional(
                    end: 12,
                    bottom: 12,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          hasImage
                              ? tr.uploadDoctorImageTitle
                              : tr.tapToPickImage,
                          style: context.semiBold12TextMain.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (hasImage && onClear != null && !isUploading)
          Align(
            alignment: AlignmentDirectional.centerEnd,
            //CR use primary widget (any reuse widget)
            // Solved
            child: AppTextButton(
              onPressed: onClear,
              icon: Icons.close_rounded,
              iconSize: 18,
              label: tr.removeImage,
            ),
          ),
      ],
    );
  }
}

class _EmptyDoctorImage extends StatelessWidget {
  const _EmptyDoctorImage();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primaryLight,
      child: Center(
        child: Icon(
          Icons.add_a_photo_outlined,
          size: 44,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
