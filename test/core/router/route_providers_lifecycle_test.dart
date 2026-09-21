import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/data/repositories/create_doctor_repository.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/controller/cubit/create_doctor_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/screens/create_doctor_screen.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/repositories/admin_doctors_repository.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/screens/admin_doctors_screen.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/screens/login_screen.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/screens/reset_password_screen.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/screens/signup_screen.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/widgets/forgot_password_bottom_sheet.dart';
import 'package:doctor_hunt/apps/features/common/role_selection/data/models/user_role.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/data/repositories/favourite_doctors_repository.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/presentation/controller/cubit/favourite_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/presentation/screens/favourite_doctors_screen.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/repositories/doctor_repository.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/screens/find_doctors_screen.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/repositories/home_repository.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/screens/patient_home_screen.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/screens/profile_screen.dart';

import '../../helpers/test_app.dart';
import '../../helpers/test_fakes.dart';

Future<void> setupFakeServiceLocator({
  void Function(AuthCubit)? onAuthCubitCreated,
  void Function(HomeCubit)? onHomeCubitCreated,
  void Function(FindDoctorsCubit)? onFindDoctorsCubitCreated,
  void Function(FavouriteDoctorsCubit)? onFavouriteDoctorsCubitCreated,
  void Function(AdminDoctorsCubit)? onAdminDoctorsCubitCreated,
  void Function(CreateDoctorCubit)? onCreateDoctorCubitCreated,
}) async {
  await getIt.reset();
  getIt.registerLazySingleton<FirebaseAuth>(() => FakeFirebaseAuth());
  getIt.registerLazySingleton<FirebaseFirestore>(() => FakeFirebaseFirestore());

  final fakeAuthService = FakeAuthService();
  getIt.registerLazySingleton<AuthService>(() => fakeAuthService);

  final fakeAuthRepo = FakeAuthRepository();
  getIt.registerLazySingleton<AuthRepository>(() => fakeAuthRepo);

  final fakeDoctorRepo = FakeDoctorRepository();
  getIt.registerLazySingleton<DoctorRepository>(() => fakeDoctorRepo);

  final fakeFavDoctorRepo = FakeFavouriteDoctorsRepository();
  getIt.registerLazySingleton<FavouriteDoctorsRepository>(
    () => fakeFavDoctorRepo,
  );

  final fakeHomeRepo = FakeHomeRepository();
  getIt.registerLazySingleton<HomeRepository>(() => fakeHomeRepo);

  final fakeAdminDoctorRepo = FakeAdminDoctorsRepository();
  getIt.registerLazySingleton<AdminDoctorsRepository>(
    () => fakeAdminDoctorRepo,
  );

  final fakeCreateDoctorRepo = FakeCreateDoctorRepository();
  getIt.registerLazySingleton<CreateDoctorRepository>(
    () => fakeCreateDoctorRepo,
  );

  getIt.registerFactory<AuthCubit>(() {
    final cubit = AuthCubit(repository: getIt<AuthRepository>());
    onAuthCubitCreated?.call(cubit);
    return cubit;
  });
  getIt.registerFactory<HomeCubit>(() {
    final cubit = HomeCubit(repository: getIt<HomeRepository>());
    onHomeCubitCreated?.call(cubit);
    return cubit;
  });
  getIt.registerFactory<FindDoctorsCubit>(() {
    final cubit = FindDoctorsCubit(repository: getIt<DoctorRepository>());
    onFindDoctorsCubitCreated?.call(cubit);
    return cubit;
  });
  getIt.registerFactory<FavouriteDoctorsCubit>(() {
    final cubit = FavouriteDoctorsCubit(
      repository: getIt<FavouriteDoctorsRepository>(),
    );
    onFavouriteDoctorsCubitCreated?.call(cubit);
    return cubit;
  });
  getIt.registerFactory<AdminDoctorsCubit>(() {
    final cubit = AdminDoctorsCubit(
      repository: getIt<AdminDoctorsRepository>(),
    );
    onAdminDoctorsCubitCreated?.call(cubit);
    return cubit;
  });
  getIt.registerFactory<CreateDoctorCubit>(() {
    final cubit = CreateDoctorCubit(
      repository: getIt<CreateDoctorRepository>(),
    );
    onCreateDoctorCubitCreated?.call(cubit);
    return cubit;
  });
}

void main() {
  setUp(() async {
    await setupFakeServiceLocator();
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('Route Provider Mounting and Dependency Scoping', () {
    testWidgets('LoginRoute mounts LoginScreen and provides AuthCubit', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final router = GoRouter(initialLocation: '/login', routes: $appRoutes);
      await tester.pumpWidget(buildTestRouterApp(router));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
      final loginElement = tester.element(find.byType(LoginScreen));
      expect(loginElement.read<AuthCubit>(), isA<AuthCubit>());
      expect(tester.widget<LoginScreen>(find.byType(LoginScreen)).role, isNull);
    });

    testWidgets('LoginRoute preserves UserRole argument passed via extra', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final router = GoRouter(
        initialLocation: '/start',
        routes: [
          GoRoute(
            path: '/start',
            builder: (context, state) => const Scaffold(body: Text('Start')),
          ),
          ...$appRoutes,
        ],
      );
      await tester.pumpWidget(buildTestRouterApp(router));
      await tester.pumpAndSettle();

      const LoginRoute(
        UserRole.patient,
      ).push(tester.element(find.text('Start')));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(
        tester.widget<LoginScreen>(find.byType(LoginScreen)).role,
        UserRole.patient,
      );
    });

    testWidgets('SignupRoute mounts SignupScreen and provides AuthCubit', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final router = GoRouter(initialLocation: '/signup', routes: $appRoutes);
      await tester.pumpWidget(buildTestRouterApp(router));
      await tester.pumpAndSettle();

      expect(find.byType(SignupScreen), findsOneWidget);
      final signupElement = tester.element(find.byType(SignupScreen));
      expect(signupElement.read<AuthCubit>(), isA<AuthCubit>());
    });

    testWidgets(
      'ResetPasswordRoute mounts ResetPasswordScreen and provides AuthCubit',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final router = GoRouter(
          initialLocation: '/reset-password',
          routes: $appRoutes,
        );
        await tester.pumpWidget(buildTestRouterApp(router));
        await tester.pumpAndSettle();

        expect(find.byType(ResetPasswordScreen), findsOneWidget);
        final resetElement = tester.element(find.byType(ResetPasswordScreen));
        expect(resetElement.read<AuthCubit>(), isA<AuthCubit>());
      },
    );

    testWidgets(
      'ProfileRoute mounts ProfileScreen and preserves profile extra',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final router = GoRouter(
          initialLocation: '/start',
          routes: [
            GoRoute(
              path: '/start',
              builder: (context, state) => const Scaffold(body: Text('Start')),
            ),
            ...$appRoutes,
          ],
        );
        await tester.pumpWidget(buildTestRouterApp(router));
        await tester.pumpAndSettle();

        const profile = UserProfileModel(name: 'Jane Doe');
        const ProfileRoute(profile).push(tester.element(find.text('Start')));
        await tester.pumpAndSettle();

        expect(find.byType(ProfileScreen), findsOneWidget);
        final profileElement = tester.element(find.byType(ProfileScreen));
        expect(profileElement.read<AuthCubit>(), isA<AuthCubit>());
        expect(
          tester
              .widget<ProfileScreen>(find.byType(ProfileScreen))
              .profile
              ?.name,
          'Jane Doe',
        );
      },
    );

    testWidgets(
      'HomeRoute mounts HomeScreen, provides HomeCubit, and injects the current user',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final router = GoRouter(initialLocation: '/home', routes: $appRoutes);
        await tester.pumpWidget(buildTestRouterApp(router));
        await tester.pumpAndSettle();

        expect(find.byType(HomeScreen), findsOneWidget);
        final homeElement = tester.element(find.byType(HomeScreen));
        expect(homeElement.read<HomeCubit>(), isA<HomeCubit>());

        final homeScreen = tester.widget<HomeScreen>(find.byType(HomeScreen));
        expect(homeScreen.user, same(getIt<AuthRepository>().currentUser));
      },
    );

    testWidgets(
      'FindDoctorsRoute mounts FindDoctorsScreen and provides FindDoctorsCubit',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final router = GoRouter(
          initialLocation: '/find-doctors',
          routes: $appRoutes,
        );
        await tester.pumpWidget(buildTestRouterApp(router));
        await tester.pumpAndSettle();

        expect(find.byType(FindDoctorsScreen), findsOneWidget);
        final findDocsElement = tester.element(find.byType(FindDoctorsScreen));
        expect(
          findDocsElement.read<FindDoctorsCubit>(),
          isA<FindDoctorsCubit>(),
        );
      },
    );

    testWidgets(
      'FavouriteDoctorsRoute mounts FavouriteDoctorsScreen and provides FavouriteDoctorsCubit',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final router = GoRouter(
          initialLocation: '/favourite-doctors',
          routes: $appRoutes,
        );
        await tester.pumpWidget(buildTestRouterApp(router));
        await tester.pumpAndSettle();

        expect(find.byType(FavouriteDoctorsScreen), findsOneWidget);
        final favDocsElement = tester.element(
          find.byType(FavouriteDoctorsScreen),
        );
        expect(
          favDocsElement.read<FavouriteDoctorsCubit>(),
          isA<FavouriteDoctorsCubit>(),
        );
      },
    );

    testWidgets(
      'AdminDoctorsRoute mounts AdminDoctorsScreen and provides AdminDoctorsCubit',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final router = GoRouter(
          initialLocation: '/admin/doctors',
          routes: $appRoutes,
        );
        await tester.pumpWidget(buildTestRouterApp(router));
        await tester.pumpAndSettle();

        expect(find.byType(AdminDoctorsScreen), findsOneWidget);
        final adminElement = tester.element(find.byType(AdminDoctorsScreen));
        expect(
          adminElement.read<AdminDoctorsCubit>(),
          isA<AdminDoctorsCubit>(),
        );
      },
    );

    testWidgets(
      'CreateDoctorRoute mounts CreateDoctorScreen, provides CreateDoctorCubit, and preserves doctor extra',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final router = GoRouter(
          initialLocation: '/start',
          routes: [
            GoRoute(
              path: '/start',
              builder: (context, state) => const Scaffold(body: Text('Start')),
            ),
            ...$appRoutes,
          ],
        );
        await tester.pumpWidget(buildTestRouterApp(router));
        await tester.pumpAndSettle();

        const doctor = AdminDoctorModel(
          id: 'doc_1',
          name: 'Dr. John',
          specialty: 'Dentist',
        );
        const CreateDoctorRoute(
          doctor,
        ).push(tester.element(find.text('Start')));
        await tester.pumpAndSettle();

        expect(find.byType(CreateDoctorScreen), findsOneWidget);
        final createElement = tester.element(find.byType(CreateDoctorScreen));
        expect(
          createElement.read<CreateDoctorCubit>(),
          isA<CreateDoctorCubit>(),
        );
        expect(
          tester
              .widget<CreateDoctorScreen>(find.byType(CreateDoctorScreen))
              .doctor
              ?.name,
          'Dr. John',
        );
      },
    );
  });

  group('Cubit Disposal on Route Pop', () {
    testWidgets('AuthCubit is disposed when LoginRoute is popped', (
      WidgetTester tester,
    ) async {
      AuthCubit? captured;
      await setupFakeServiceLocator(onAuthCubitCreated: (c) => captured = c);

      final router = GoRouter(
        initialLocation: '/start',
        routes: [
          GoRoute(
            path: '/start',
            builder: (context, state) => const Scaffold(body: Text('Start')),
          ),
          ...$appRoutes,
        ],
      );
      await tester.pumpWidget(buildTestRouterApp(router));
      await tester.pumpAndSettle();

      const LoginRoute().push(tester.element(find.text('Start')));
      await tester.pumpAndSettle();

      expect(captured, isNotNull);
      expect(captured!.isClosed, isFalse);

      router.pop();
      await tester.pumpAndSettle();

      expect(captured!.isClosed, isTrue);
    });

    testWidgets('HomeCubit is disposed when HomeRoute is popped', (
      WidgetTester tester,
    ) async {
      HomeCubit? captured;
      await setupFakeServiceLocator(onHomeCubitCreated: (c) => captured = c);

      final router = GoRouter(
        initialLocation: '/start',
        routes: [
          GoRoute(
            path: '/start',
            builder: (context, state) => const Scaffold(body: Text('Start')),
          ),
          ...$appRoutes,
        ],
      );
      await tester.pumpWidget(buildTestRouterApp(router));
      await tester.pumpAndSettle();

      const HomeRoute().push(tester.element(find.text('Start')));
      await tester.pumpAndSettle();

      expect(captured, isNotNull);
      expect(captured!.isClosed, isFalse);

      router.pop();
      await tester.pumpAndSettle();

      expect(captured!.isClosed, isTrue);
    });

    testWidgets(
      'FindDoctorsCubit is disposed when FindDoctorsRoute is popped',
      (WidgetTester tester) async {
        FindDoctorsCubit? captured;
        await setupFakeServiceLocator(
          onFindDoctorsCubitCreated: (c) => captured = c,
        );

        final router = GoRouter(
          initialLocation: '/start',
          routes: [
            GoRoute(
              path: '/start',
              builder: (context, state) => const Scaffold(body: Text('Start')),
            ),
            ...$appRoutes,
          ],
        );
        await tester.pumpWidget(buildTestRouterApp(router));
        await tester.pumpAndSettle();

        const FindDoctorsRoute().push(tester.element(find.text('Start')));
        await tester.pumpAndSettle();

        expect(captured, isNotNull);
        expect(captured!.isClosed, isFalse);

        router.pop();
        await tester.pumpAndSettle();

        expect(captured!.isClosed, isTrue);
      },
    );

    testWidgets(
      'FavouriteDoctorsCubit is disposed when FavouriteDoctorsRoute is popped',
      (WidgetTester tester) async {
        FavouriteDoctorsCubit? captured;
        await setupFakeServiceLocator(
          onFavouriteDoctorsCubitCreated: (c) => captured = c,
        );

        final router = GoRouter(
          initialLocation: '/start',
          routes: [
            GoRoute(
              path: '/start',
              builder: (context, state) => const Scaffold(body: Text('Start')),
            ),
            ...$appRoutes,
          ],
        );
        await tester.pumpWidget(buildTestRouterApp(router));
        await tester.pumpAndSettle();

        const FavouriteDoctorsRoute().push(tester.element(find.text('Start')));
        await tester.pumpAndSettle();

        expect(captured, isNotNull);
        expect(captured!.isClosed, isFalse);

        router.pop();
        await tester.pumpAndSettle();

        expect(captured!.isClosed, isTrue);
      },
    );

    testWidgets(
      'AdminDoctorsCubit is disposed when AdminDoctorsRoute is popped',
      (WidgetTester tester) async {
        AdminDoctorsCubit? captured;
        await setupFakeServiceLocator(
          onAdminDoctorsCubitCreated: (c) => captured = c,
        );

        final router = GoRouter(
          initialLocation: '/start',
          routes: [
            GoRoute(
              path: '/start',
              builder: (context, state) => const Scaffold(body: Text('Start')),
            ),
            ...$appRoutes,
          ],
        );
        await tester.pumpWidget(buildTestRouterApp(router));
        await tester.pumpAndSettle();

        const AdminDoctorsRoute().push(tester.element(find.text('Start')));
        await tester.pumpAndSettle();

        expect(find.byType(AdminDoctorsScreen), findsOneWidget);
        expect(captured, isNotNull);
        expect(captured!.isClosed, isFalse);

        expect(router.canPop(), isTrue);
        router.pop();
        await tester.pumpAndSettle();

        expect(find.byType(AdminDoctorsScreen), findsNothing);
        await tester.runAsync(() async {
          await Future<void>.delayed(const Duration(milliseconds: 10));
        });
        await tester.pump();
        expect(captured!.isClosed, isTrue);
      },
    );

    testWidgets(
      'CreateDoctorCubit is disposed when CreateDoctorRoute is popped',
      (WidgetTester tester) async {
        CreateDoctorCubit? captured;
        await setupFakeServiceLocator(
          onCreateDoctorCubitCreated: (c) => captured = c,
        );

        final router = GoRouter(
          initialLocation: '/start',
          routes: [
            GoRoute(
              path: '/start',
              builder: (context, state) => const Scaffold(body: Text('Start')),
            ),
            ...$appRoutes,
          ],
        );
        await tester.pumpWidget(buildTestRouterApp(router));
        await tester.pumpAndSettle();

        const CreateDoctorRoute().push(tester.element(find.text('Start')));
        await tester.pumpAndSettle();

        expect(captured, isNotNull);
        expect(captured!.isClosed, isFalse);

        router.pop();
        await tester.pumpAndSettle();

        expect(captured!.isClosed, isTrue);
      },
    );
  });

  group('Rebuild Safety', () {
    testWidgets(
      'Rebuilding parent widget preserves Cubit instance without recreating it',
      (WidgetTester tester) async {
        late StateSetter triggerSetState;
        AuthCubit? cubitFirstBuild;
        AuthCubit? cubitSecondBuild;

        await tester.pumpWidget(
          buildTestApp(
            StatefulBuilder(
              builder: (context, setState) {
                triggerSetState = setState;
                return BlocProvider<AuthCubit>(
                  create: (_) => getIt<AuthCubit>(),
                  child: Builder(
                    builder: (innerContext) {
                      final cubit = innerContext.read<AuthCubit>();
                      if (cubitFirstBuild == null) {
                        cubitFirstBuild = cubit;
                      } else {
                        cubitSecondBuild = cubit;
                      }
                      return const Scaffold(body: Text('Rebuild test'));
                    },
                  ),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(cubitFirstBuild, isNotNull);
        expect(cubitFirstBuild!.isClosed, isFalse);

        triggerSetState(() {});
        await tester.pumpAndSettle();

        expect(cubitSecondBuild, isNotNull);
        expect(identical(cubitFirstBuild, cubitSecondBuild), isTrue);
        expect(cubitFirstBuild!.isClosed, isFalse);
      },
    );
  });

  group('Modal Isolation (ForgotPasswordBottomSheet)', () {
    testWidgets(
      'ForgotPasswordBottomSheet creates separate AuthCubit and disposes only sheet cubit on dismiss',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final createdCubits = <AuthCubit>[];
        await setupFakeServiceLocator(onAuthCubitCreated: createdCubits.add);

        final router = GoRouter(initialLocation: '/login', routes: $appRoutes);
        await tester.pumpWidget(buildTestRouterApp(router));
        await tester.pumpAndSettle();

        expect(find.byType(LoginScreen), findsOneWidget);
        expect(createdCubits.length, 1);
        final parentCubit = createdCubits.first;
        expect(parentCubit.isClosed, isFalse);

        // Open ForgotPasswordBottomSheet via its static show method
        final loginContext = tester.element(find.byType(LoginScreen));
        ForgotPasswordBottomSheet.show(loginContext);
        await tester.pumpAndSettle();

        expect(find.byType(ForgotPasswordBottomSheet), findsOneWidget);
        expect(createdCubits.length, 2);
        final sheetCubit = createdCubits.last;

        // Verify cubits are completely separate instances
        expect(identical(parentCubit, sheetCubit), isFalse);
        expect(sheetCubit.isClosed, isFalse);
        expect(parentCubit.isClosed, isFalse);

        // Dismiss the bottom sheet
        Navigator.of(
          tester.element(find.byType(ForgotPasswordBottomSheet)),
        ).pop();
        await tester.pumpAndSettle();

        expect(find.byType(ForgotPasswordBottomSheet), findsNothing);
        expect(sheetCubit.isClosed, isTrue);
        expect(parentCubit.isClosed, isFalse);
      },
    );
  });
}
