import 'package:flutter/material.dart';

import 'apps/core/router/app_router.dart';
import 'generated/app_strings.dart';
import 'generated/app_styles.dart';

void main() {
  runApp(const MedoraApp());
}

class MedoraApp extends StatelessWidget {
  const MedoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppStyles.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}


