import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/features/onboarding/data/onboarding_data.dart';
import 'package:doctor_hunt/apps/features/onboarding/data/models/onboarding_model.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onSkip() {
    const LoginRoute().go(context);
  }

  void onNext() {
    if (currentIndex == onboardingPages(context.t).length - 1) {
      const LoginRoute().go(context);
      return;
    }

    controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = onboardingPages(context.t);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: pages.length,
              onPageChanged: (index) => setState(() => currentIndex = index),
              itemBuilder: (context, index) {
                final page = pages[index];
                return OnboardingDetailPage(
                  page: page,
                  controller: controller,
                  pageCount: pages.length,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 12, 32, 28),
            child: Row(
              children: [
                TextButton(onPressed: onSkip, child: Text(t.skip)),
                const Spacer(),
                IconButton(
                  onPressed: onNext,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    fixedSize: const Size(58, 58),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingDetailPage extends StatelessWidget {
  final OnboardingModel page;
  final PageController controller;
  final int pageCount;

  const OnboardingDetailPage({
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
                    activeDotColor: AppColors.primaryGreen,
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
                    style: context.regular14TextSub,
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
