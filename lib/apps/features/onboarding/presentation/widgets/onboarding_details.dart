import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/features/onboarding/data/models/onboarding_model.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingDetail extends StatelessWidget {
  final OnboardingModel page;
  final PageController controller;
  final int pageCount;

  const OnboardingDetail({
    super.key,
    required this.page,
    required this.controller,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    final imageAlignment = page.imageAlignment == OnboardingImageAlignment.left
        ? Alignment.centerLeft
        : Alignment.centerRight;

    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Align(
              alignment: imageAlignment,
              child: Image.asset(
                page.illustration,
                width: double.infinity,
                alignment: imageAlignment,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 16),
                SmoothPageIndicator(
                  controller: controller,
                  count: pageCount,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 7,
                    dotWidth: 7,
                    spacing: 6,
                    expansionFactor: 3.14,
                    radius: 4,

                    dotColor: AppColors.disabled,
                    activeDotColor: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  page.title,
                  textAlign: TextAlign.center,
                  style: context.bold28TextMain,
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    page.subtitle,
                    textAlign: TextAlign.center,
                    style: context.regular14TextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
