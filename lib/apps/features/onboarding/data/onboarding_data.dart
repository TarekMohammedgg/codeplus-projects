import 'package:doctor_hunt/apps/features/onboarding/data/models/onboarding_model.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

List<OnboardingModel> onboardingPages(Translations t) => [
  OnboardingModel(
    illustration: Assets.assetsDesignOnboardingImage1,
    title: t.onboardingTitle1,
    subtitle: t.onboardingSubtitle1,
    imageAlignment: OnboardingImageAlignment.left,
  ),
  OnboardingModel(
    illustration: Assets.assetsDesignOnboardingImage2,
    title: t.onboardingTitle2,
    subtitle: t.onboardingSubtitle2,
    imageAlignment: OnboardingImageAlignment.right,
  ),
  OnboardingModel(
    illustration: Assets.assetsDesignOnboardingImage3,
    title: t.onboardingTitle3,
    subtitle: t.onboardingSubtitle3,
    imageAlignment: OnboardingImageAlignment.left,
  ),
];
