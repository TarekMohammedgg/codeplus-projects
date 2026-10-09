import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'apps/core/di/injection.dart';
import 'apps/core/router/app_router.dart';
import 'apps/core/theme/app_theme.dart';
import 'generated/i18n/translations.g.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'apps/features/common/auth/data/repositories/auth_repository.dart';
import 'apps/features/common/auth/data/service/auth_service.dart';
import 'apps/features/patient/favorites/presentation/controller/cubit/favorites_cubit.dart';
import 'firebase_options.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Failed to load .env file: $e');
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AuthService.initialize();
  await initializeDateFormatting();
  final preferences = await SharedPreferences.getInstance();
  setupServiceLocator(preferences: preferences);

  final currentUser = getIt<AuthRepository>().currentUser;
  if (currentUser != null) {
    try {
      await getIt<AuthRepository>().isCurrentUserAdmin();
    } catch (e) {
      debugPrint('Failed to warm up user role: $e');
    }
  }

  LocaleSettings.useDeviceLocale();
  runApp(TranslationProvider(child: const DoctorHuntApp()));
}

class DoctorHuntApp extends StatefulWidget {
  const DoctorHuntApp({super.key});

  @override
  State<DoctorHuntApp> createState() => _DoctorHuntAppState();
}

class _DoctorHuntAppState extends State<DoctorHuntApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.tr.$meta.locale;

    return BlocProvider<FavoritesCubit>(
      create: (_) => getIt<FavoritesCubit>(),
      child: MaterialApp.router(
        key: ValueKey(locale),
        title: tr.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        locale: locale.flutterLocale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        routerConfig: AppRouter.router,
        builder: (context, child) {
          return ColoredBox(
            color: AppColors.background,
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
