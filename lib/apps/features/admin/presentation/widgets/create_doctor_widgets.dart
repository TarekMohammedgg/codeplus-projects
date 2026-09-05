import 'dart:io';

import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/features/admin/data/specialty_options.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class SpecialtyDropdownField extends StatelessWidget {
  const SpecialtyDropdownField({
    super.key,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  final SpecialtyOption? value;
  final ValueChanged<SpecialtyOption?> onChanged;
  final FormFieldValidator<SpecialtyOption>? validator;

  @override
  Widget build(BuildContext context) {
    final baseOptions = specialtyOptions();
    final options = [
      ...baseOptions,
      if (value != null && !baseOptions.any((o) => o.key == value!.key)) value!,
    ];

    return DropdownButtonFormField<SpecialtyOption>(
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
        return options.map((option) {
          return Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              option.label,
              style: context.semiBold16TextMain,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList();
      },
      items: options.map((option) {
        final isSelected = option.key == value?.key;
        return DropdownMenuItem<SpecialtyOption>(
          value: option,
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
                  option.icon,
                  size: 18,
                  color: isSelected ? AppColors.primary : AppColors.primaryDark,
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  option.label,
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

class ImagePickerTile extends StatelessWidget {
  const ImagePickerTile({
    super.key,
    required this.image,
    this.existingImageUrl,
    required this.onTap,
  });

  final File? image;
  final String? existingImageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (image != null) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.file(
          image!,
          width: double.infinity,
          height: 160,
          fit: BoxFit.cover,
        ),
      );
    } else if (existingImageUrl != null &&
        existingImageUrl!.trim().isNotEmpty) {
      content = Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DoctorImage(
              imageUrl: existingImageUrl!,
              width: double.infinity,
              height: 160,
              fallback: const Center(child: DoctorAvatarPlaceholder(size: 64)),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.camera_alt_outlined,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    tr.changeImage,
                    style: context.medium12TextSecondary.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      content = Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            const Icon(
              Icons.image_outlined,
              size: 36,
              color: AppColors.textSecondary,
            ),
            10.verticalSpace,
            Text(tr.uploadDoctorImageTitle, style: context.semiBold14TextMain),
            4.verticalSpace,
            Text(tr.tapToPickImage, style: context.regular12TextSecondary),
          ],
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: ImageUploadBox(child: content),
    );
  }
}

class ImageUploadBox extends StatelessWidget {
  const ImageUploadBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline, width: 1.4),
      ),
      child: Center(child: child),
    );
  }
}
