import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/features/home/data/models/doctor_model.dart';

class DoctorCategorySection extends StatelessWidget {
  const DoctorCategorySection({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  final List<DoctorCategoryItem> categories;
  final ValueChanged<DoctorCategoryItem>? onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => 14.horizontalSpace,
        itemBuilder: (context, index) {
          final category = categories[index];
          return DoctorCategoryCard(
            category: category,
            onTap: () => onCategoryTap?.call(category),
          );
        },
      ),
    );
  }
}

class DoctorCategoryCard extends StatelessWidget {
  const DoctorCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  final DoctorCategoryItem category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: category.secondaryColor,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: category.primaryColor.withValues(alpha: 0.18),
        highlightColor: category.primaryColor.withValues(alpha: 0.08),
        child: SizedBox(
          width: 54,
          height: 54,
          child: Center(
            child: Skeleton.replace(
              width: 26,
              height: 26,
              child: category.image != null
                  ? Image.asset(
                      category.image!,
                      width: 26,
                      height: 26,
                      color: category.primaryColor,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        category.icon ?? Icons.category_rounded,
                        color: category.primaryColor,
                        size: 26,
                      ),
                    )
                  : Icon(
                      category.icon ?? Icons.category_rounded,
                      color: category.primaryColor,
                      size: 26,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
