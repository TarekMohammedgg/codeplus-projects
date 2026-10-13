import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/utils/doctor_sort.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/screens/find_doctors_screen.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import '../../../helpers/test_app.dart';
import '../../../helpers/test_fakes.dart';

List<DoctorModel> testFindDoctors() {
  return const [
    DoctorModel(
      id: 'doc_1',
      nameEn: 'Dr. Shruti Kedia',
      specialtyEn: 'Dentist',
    ),
    DoctorModel(
      id: 'doc_5',
      nameEn: 'Dr. Fillerup Grab',
      specialtyEn: 'Medicine Specialist',
    ),
  ];
}

void main() {
  late FakeFavoritesRepository favoritesRepository;
  late FavoritesCubit favoritesCubit;

  setUp(() {
    favoritesRepository = FakeFavoritesRepository();
    favoritesCubit = FavoritesCubit(repository: favoritesRepository);
  });

  tearDown(() => favoritesCubit.close());

  Future<void> pumpScreen(
    WidgetTester tester, {
    Set<String>? favorites,
    DoctorSort? sort,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      buildTestApp(
        BlocProvider<FavoritesCubit>.value(
          value: favoritesCubit,
          child: BlocProvider<FindDoctorsCubit>(
            create: (_) => FindDoctorsCubit(
              repository: FakeDoctorRepository(doctors: testFindDoctors()),
            ),
            child: FindDoctorsScreen(sort: sort),
          ),
        ),
      ),
    );
    await tester.pump();
    if (favorites != null) {
      favoritesRepository.userIds.add('patient-1');
      await tester.pump();
      favoritesRepository.favoriteIds.add(favorites);
      await tester.pump();
    }
  }

  testWidgets('FindDoctorsScreen renders search, filters and doctor cards', (
    WidgetTester tester,
  ) async {
    await pumpScreen(tester);

    final tr = AppLocale.en.buildSync();
    expect(find.text(tr.searchDoctorHint), findsOneWidget);
    expect(find.text(tr.filterAll), findsOneWidget);
    expect(find.text(tr.favorites), findsNothing);
    expect(find.text(tr.findDoctors), findsOneWidget);
    expect(find.text('Dr. Shruti Kedia'), findsOneWidget);
    expect(find.text('Dr. Fillerup Grab'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
  });

  testWidgets(
    'See All (popular sort) shows the list without search or filters',
    (WidgetTester tester) async {
      await pumpScreen(tester, sort: DoctorSort.popular);

      final tr = AppLocale.en.buildSync();
      expect(find.text(tr.popularDoctors), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
      expect(find.text(tr.filterAll), findsNothing);
      expect(find.text('Dr. Shruti Kedia'), findsOneWidget);
    },
  );

  testWidgets('tapping a heart toggles the favorite for the patient', (
    WidgetTester tester,
  ) async {
    await pumpScreen(tester, favorites: {});

    await tester.tap(find.byIcon(Icons.favorite_border_rounded).first);
    await tester.pump();

    expect(favoritesRepository.writes, hasLength(1));
    expect(favoritesRepository.writes.single.$3, isTrue);
  });

  testWidgets('search with no match shows the empty state', (
    WidgetTester tester,
  ) async {
    await pumpScreen(tester);

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump();

    expect(find.text(AppLocale.en.buildSync().noDoctorsFound), findsOneWidget);
  });

  testWidgets(
    'backward navigation via back button navigates to home when canPop is false',
    (WidgetTester tester) async {
      final router = GoRouter(
        initialLocation: '/doctors',
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, _) => const Scaffold(body: Text('Home Page')),
          ),
          GoRoute(
            path: '/doctors',
            builder: (_, _) => BlocProvider<FavoritesCubit>.value(
              value: favoritesCubit,
              child: BlocProvider<FindDoctorsCubit>(
                create: (_) => FindDoctorsCubit(
                  repository: FakeDoctorRepository(doctors: testFindDoctors()),
                ),
                child: const FindDoctorsScreen(),
              ),
            ),
          ),
        ],
      );
      await tester.pumpWidget(buildTestRouterApp(router));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Home Page'), findsOneWidget);
    },
  );

  testWidgets(
    'backward navigation via system back navigates to home when canPop is false',
    (WidgetTester tester) async {
      final router = GoRouter(
        initialLocation: '/doctors',
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, _) => const Scaffold(body: Text('Home Page')),
          ),
          GoRoute(
            path: '/doctors',
            builder: (_, _) => BlocProvider<FavoritesCubit>.value(
              value: favoritesCubit,
              child: BlocProvider<FindDoctorsCubit>(
                create: (_) => FindDoctorsCubit(
                  repository: FakeDoctorRepository(doctors: testFindDoctors()),
                ),
                child: const FindDoctorsScreen(),
              ),
            ),
          ),
        ],
      );
      await tester.pumpWidget(buildTestRouterApp(router));
      await tester.pumpAndSettle();

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text('Home Page'), findsOneWidget);
    },
  );

  testWidgets('backward navigation via back button pops when canPop is true', (
    WidgetTester tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/start',
      routes: [
        GoRoute(
          path: '/start',
          builder: (context, _) => Scaffold(
            body: ElevatedButton(
              onPressed: () => context.push('/doctors'),
              child: const Text('Go to Doctors'),
            ),
          ),
        ),
        GoRoute(
          path: '/doctors',
          builder: (_, _) => BlocProvider<FavoritesCubit>.value(
            value: favoritesCubit,
            child: BlocProvider<FindDoctorsCubit>(
              create: (_) => FindDoctorsCubit(
                repository: FakeDoctorRepository(doctors: testFindDoctors()),
              ),
              child: const FindDoctorsScreen(),
            ),
          ),
        ),
      ],
    );
    await tester.pumpWidget(buildTestRouterApp(router));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Go to Doctors'));
    await tester.pumpAndSettle();
    expect(find.byType(FindDoctorsScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Go to Doctors'), findsOneWidget);
  });
}
