import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/features/home/data/doctors_categories.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/doctor_category_section.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class HomeLoadingSliver extends StatelessWidget {
  const HomeLoadingSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }
}

class HomeErrorSliver extends StatelessWidget {
  const HomeErrorSliver({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tr.serviceError,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              IconButton(
                onPressed: onRetry,
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 32,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeCategoriesSliver extends StatelessWidget {
  const HomeCategoriesSliver({super.key, required this.onCategoryTap});

  final VoidCallback onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: DoctorCategorySection(
          categories: categories(),
          onCategoryTap: (_) => onCategoryTap(),
        ),
      ),
    );
  }
}

class HomeEmptySliver extends StatelessWidget {
  const HomeEmptySliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
        child: Center(child: Text(tr.noDoctorsFound)),
      ),
    );
  }
}
