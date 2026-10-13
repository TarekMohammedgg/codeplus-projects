import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';

class DoctorCategorySection extends StatelessWidget {
  const DoctorCategorySection({
    super.key,
    required this.specialties,
    required this.onSpecialtyTap,
  });

  final List<SpecialtyModel> specialties;
  final ValueChanged<SpecialtyModel> onSpecialtyTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: specialties.length,
        separatorBuilder: (_, _) => 14.horizontalSpace,
        itemBuilder: (context, index) {
          final specialty = specialties[index];
          return DoctorCategoryCard(
            specialty: specialty,
            onTap: () => onSpecialtyTap(specialty),
          );
        },
      ),
    );
  }
}

class DoctorCategoryCard extends StatelessWidget {
  const DoctorCategoryCard({
    super.key,
    required this.specialty,
    required this.onTap,
  });

  final SpecialtyModel specialty;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryLight,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.primary.withValues(alpha: 0.18),
        highlightColor: AppColors.primary.withValues(alpha: 0.08),
        child: SizedBox(
          width: 54,
          height: 54,
          child: Center(
            child: Skeleton.replace(
              width: 26,
              height: 26,
              child: Icon(specialty.icon, color: AppColors.primary, size: 26),
            ),
          ),
        ),
      ),
    );
  }
}
