import 'package:flutter/material.dart';

import 'package:doctor_hunt/generated/style_atoms.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: 2,
            style: context.bold26TextMain,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: 2,
            style: context.regular14TextSecondary.copyWith(height: 1.45),
          ),
        ),
      ],
    );
  }
}
