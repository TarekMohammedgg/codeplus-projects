import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class _FakeFirebaseAuth extends Fake implements FirebaseAuth {
  @override
  User? get currentUser => null;
}

class _FakeFirebaseFirestore extends Fake implements FirebaseFirestore {}

void _registerTestFirebase() {
  if (!getIt.isRegistered<FirebaseAuth>()) {
    getIt.registerLazySingleton<FirebaseAuth>(() => _FakeFirebaseAuth());
  }
  if (!getIt.isRegistered<FirebaseFirestore>()) {
    getIt.registerLazySingleton<FirebaseFirestore>(
      () => _FakeFirebaseFirestore(),
    );
  }
}

Widget buildTestApp(Widget child) {
  LocaleSettings.setLocaleSync(AppLocale.en);
  _registerTestFirebase();
  setupServiceLocator();
  return TranslationProvider(
    child: Builder(
      builder: (context) {
        final locale = context.tr.$meta.locale;
        return MaterialApp(
          key: ValueKey(locale),
          locale: locale.flutterLocale,
          home: child,
        );
      },
    ),
  );
}

Widget buildTestRouterApp(GoRouter router) {
  LocaleSettings.setLocaleSync(AppLocale.en);
  _registerTestFirebase();
  setupServiceLocator();
  return TranslationProvider(
    child: Builder(
      builder: (context) {
        final locale = context.tr.$meta.locale;
        return MaterialApp.router(
          key: ValueKey(locale),
          locale: locale.flutterLocale,
          routerConfig: router,
        );
      },
    ),
  );
}
