import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:medora/apps/core/router/routes.dart';
import 'package:medora/generated/app_strings.dart';
import 'package:medora/generated/app_styles.dart';
import 'package:medora/generated/image_assets.dart';
import '../../data/models/onboarding_model.dart';
import '../widgets/onboarding_screen_details.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final PageController controller = PageController();
  int currentIndex = 0;

  static const List<OnboardingModel> pages = [
    OnboardingModel(
      illustration: Assets.assets02OnboardingWelcomeIllustration,
      title: AppStrings.onboardingTitle1,
      subtitle: AppStrings.onboardingSubtitle1,
    ),
    OnboardingModel(
      illustration: Assets.assets03OnboardingConsultationIllustration,
      title: AppStrings.onboardingTitle2,
      subtitle: AppStrings.onboardingSubtitle2,
    ),
    OnboardingModel(
      illustration: Assets.assets04OnboardingRecordsIllustration,
      title: AppStrings.onboardingTitle3,
      subtitle: AppStrings.onboardingSubtitle3,
    ),
  ];

  final int counter = pages.length;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onSkip() {
    context.go(Routes.login);
  }

  void onNext() {
    if (currentIndex < counter - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(Routes.login);
    }
  }

  void onPrevious() {
    if (currentIndex > 0) {
      controller.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.canvas,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip action
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppStyles.pageHorizontalPadding,
                vertical: 8,
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: onSkip,
                  child: Text(
                    AppStrings.skip,
                    style: AppStyles.action.copyWith(
                      color: AppStyles.primaryBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // PageView Content
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: counter,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return IntroductionPage(
                    illustration: page.illustration,
                    title: page.title,
                    subtitle: page.subtitle,
                  );
                },
              ),
            ),

            // Bottom Navigation Controls
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppStyles.pageHorizontalPadding,
                vertical: 24,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Circular Button
                  currentIndex > 0
                      ? GestureDetector(
                          onTap: onPrevious,
                          child: Container(
                            width: 58,
                            height: 58,
                            decoration: AppStyles.circularActionDecoration(
                              primary: false,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: AppStyles.primaryBlue,
                              size: 24,
                            ),
                          ),
                        )
                      : const SizedBox(width: 58, height: 58),

                  // Smooth Page Indicator
                  SmoothPageIndicator(
                    controller: controller,
                    count: counter,
                    effect: const ExpandingDotsEffect(
                      dotColor: AppStyles.disabled,
                      activeDotColor: AppStyles.primaryBlue,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3.5,
                      spacing: 6,
                    ),
                  ),

                  // Next / Done Circular Button
                  GestureDetector(
                    onTap: onNext,
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: AppStyles.circularActionDecoration(
                        primary: true,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
