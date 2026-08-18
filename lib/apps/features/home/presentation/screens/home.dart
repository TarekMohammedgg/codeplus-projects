import 'package:flutter/material.dart';

import 'package:medora/generated/app_strings.dart';
import 'package:medora/generated/app_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppStyles.canvas,
      body: Center(
        child: Text(
          AppStrings.homePage,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppStyles.navy,
          ),
        ),
      ),
    );
  }
}
