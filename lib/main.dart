import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'apps/core/router/app_router.dart';
import 'apps/core/theme/app_theme.dart';
import 'generated/i18n/translations.g.dart';

import 'package:firebase_core/firebase_core.dart';
import 'apps/features/auth/data/service/auth_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AuthService.initialize();

  LocaleSettings.useDeviceLocale();
  runApp(TranslationProvider(child: const DoctorHuntApp()));
}

class DoctorHuntApp extends StatelessWidget {
  const DoctorHuntApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.tr.$meta.locale;
    return MaterialApp.router(
      key: ValueKey(locale),
      title: tr.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: locale.flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: AppRouter.router,
    );
  }
}
