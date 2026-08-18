import 'package:flutter/material.dart';
import 'package:medora/generated/app_styles.dart';

class IntroductionPage extends StatelessWidget {
  final String illustration;
  final String title;
  final String subtitle;

  const IntroductionPage({
    super.key,
    required this.illustration,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppStyles.pageHorizontalPadding,
      ),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Center(
              child: Image.asset(illustration, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppStyles.pageTitle.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    color: AppStyles.navy,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppStyles.body.copyWith(
                    fontSize: 16,
                    height: 1.45,
                    color: AppStyles.textSecondary,
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
