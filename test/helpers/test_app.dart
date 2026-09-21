import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class _FakeFirebaseAuth extends Fake implements FirebaseAuth {
  @override
  User? get currentUser => null;
}

class _FakeFirebaseFirestore extends Fake implements FirebaseFirestore {}

// Widget tests call [buildTestApp]/[buildTestRouterApp] synchronously from
// many `testWidgets` bodies, and other test files reset `getIt` in their
// own setUp/tearDown, so this checks the live registry each call rather
// than a module-level flag that could go stale. This is test bootstrapping,
// not the production isRegistered fallback-instantiation pattern the //CR
// comments flag.
void _ensureTestServiceLocator() {
  if (getIt.isRegistered<AuthService>()) return;
  // Registers everything, including the real FirebaseAuth/FirebaseFirestore
  // singletons — but nothing under test resolves them yet (they're lazy),
  // so overriding them with fakes below is safe.
  setupServiceLocator();
  getIt.allowReassignment = true;
  getIt.registerLazySingleton<FirebaseAuth>(() => _FakeFirebaseAuth());
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => _FakeFirebaseFirestore(),
  );
  getIt.allowReassignment = false;
}

Widget buildTestApp(Widget child) {
  LocaleSettings.setLocaleSync(AppLocale.en);
  _ensureTestServiceLocator();
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
  _ensureTestServiceLocator();
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
