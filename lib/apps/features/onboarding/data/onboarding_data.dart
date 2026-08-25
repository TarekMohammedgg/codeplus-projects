import 'package:doctor_hunt/apps/features/onboarding/data/models/onboarding_model.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

List<OnboardingModel> onboardingPages() {
  return [
    OnboardingModel(
      illustration: Assets.assetsDesignOnboardingImage1,
      title: tr.onboardingTitle1,
      subtitle: tr.onboardingSubtitle1,
      imageAlignment: OnboardingImageAlignment.left,
    ),
    OnboardingModel(
      illustration: Assets.assetsDesignOnboardingImage2,
      title: tr.onboardingTitle2,
      subtitle: tr.onboardingSubtitle2,
      imageAlignment: OnboardingImageAlignment.right,
    ),
    OnboardingModel(
      illustration: Assets.assetsDesignOnboardingImage3,
      title: tr.onboardingTitle3,
      subtitle: tr.onboardingSubtitle3,
      imageAlignment: OnboardingImageAlignment.left,
    ),
  ];
}
