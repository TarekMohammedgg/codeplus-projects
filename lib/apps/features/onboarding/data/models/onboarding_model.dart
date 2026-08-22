enum OnboardingImageAlignment { left, right }

class OnboardingModel {
  final String illustration;
  final String title;
  final String subtitle;
  final OnboardingImageAlignment imageAlignment;

  const OnboardingModel({
    required this.illustration,
    required this.title,
    required this.subtitle,
    required this.imageAlignment,
  });
}
