import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/generated/i18n/translations.g.dart';

Widget buildTestApp(Widget child) {
  LocaleSettings.setLocaleSync(AppLocale.en);
  return TranslationProvider(child: MaterialApp(home: child));
}

Widget buildTestRouterApp(GoRouter router) {
  LocaleSettings.setLocaleSync(AppLocale.en);
  return TranslationProvider(child: MaterialApp.router(routerConfig: router));
}
