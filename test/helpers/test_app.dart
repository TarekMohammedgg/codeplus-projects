import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class _FakeFirebaseAuth extends Fake implements FirebaseAuth {
  @override
  User? get currentUser => null;

  @override
  Stream<User?> authStateChanges() => Stream<User?>.value(null);
}

class _FakeFirebaseFirestore extends Fake implements FirebaseFirestore {}

// Widget tests call [buildTestApp]/[buildTestRouterApp] synchronously from
// many `testWidgets` bodies, and other test files reset `getIt` in their
// own setUp/tearDown, so this checks the live registry each call rather
// than a module-level flag that could go stale. This is test bootstrapping,
// not the production isRegistered fallback-instantiation pattern the //CR
// comments flag.
void ensureTestServiceLocator() {
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
  ensureTestServiceLocator();
  initializeDateFormatting('en', null);
  return TranslationProvider(
    child: Builder(
      builder: (context) {
        final locale = context.tr.$meta.locale;
        return _withAppProviders(
          MaterialApp(
            key: ValueKey(locale),
            locale: locale.flutterLocale,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            supportedLocales: AppLocaleUtils.supportedLocales,
            home: child,
          ),
        );
      },
    ),
  );
}

Widget buildTestRouterApp(GoRouter router) {
  LocaleSettings.setLocaleSync(AppLocale.en);
  ensureTestServiceLocator();
  initializeDateFormatting('en', null);
  return TranslationProvider(
    child: Builder(
      builder: (context) {
        final locale = context.tr.$meta.locale;
        return _withAppProviders(
          MaterialApp.router(
            key: ValueKey(locale),
            locale: locale.flutterLocale,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            supportedLocales: AppLocaleUtils.supportedLocales,
            routerConfig: router,
          ),
        );
      },
    ),
  );
}

/// Mirrors the app-wide providers `DoctorHuntApp` puts above the router.
Widget _withAppProviders(Widget app) {
  return BlocProvider<FavoritesCubit>(
    create: (_) => getIt<FavoritesCubit>(),
    child: app,
  );
}
