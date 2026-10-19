import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/screens/patient_home_screen.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/core/widgets/app_search_bar.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/widgets/doctor_category_section.dart';
import 'package:doctor_hunt/apps/features/common/bottom_navigation_bar/presentation/widgets/main_bottom_navigation_bar.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/widgets/popular_doctor_section.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import '../../../../../../helpers/test_app.dart';
import '../../../../../../helpers/test_fakes.dart';

void main() {
  testWidgets(
    'HomeScreen shows Popular and Top Rated sections and toggles a favorite',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      final doctors = testHomeDoctors();
      final favoritesRepository = FakeFavoritesRepository();
      final favoritesCubit = FavoritesCubit(repository: favoritesRepository);
      addTearDown(favoritesCubit.close);
      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<FavoritesCubit>.value(
            value: favoritesCubit,
            child: BlocProvider<HomeCubit>(
              create: (_) =>
                  HomeCubit(repository: FakeDoctorRepository(doctors: doctors)),
              child: const HomeScreen(),
            ),
          ),
        ),
      );
      favoritesRepository.userIds.add('patient-1');
      await tester.pump();
      favoritesRepository.favoriteIds.add({});
      await tester.pump();
      expect(find.text(tr.popularDoctor), findsOneWidget);
      expect(find.text(tr.topRatedDoctors), findsOneWidget);
      expect(find.byIcon(Icons.favorite_rounded), findsNothing);

      await tester.tap(find.byIcon(Icons.favorite_border_rounded).first);
      await tester.pump();

      expect(favoritesRepository.writes, [('patient-1', 'doc_5', true)]);
      expect(find.byIcon(Icons.favorite_rounded), findsNWidgets(2));
    },
  );

  testWidgets('HomeScreen renders Doctor Hunt home UI elements properly', (
    WidgetTester tester,
  ) async {
    final tr = AppLocale.en.buildSync();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestApp(testHomeScreen()));
    await tester.pump();

    expect(find.text(tr.greetingGeneric), findsOneWidget);
    expect(find.text(tr.findYourDoctor), findsOneWidget);

    expect(find.text(tr.searchDoctorHint), findsOneWidget);

    expect(find.text(tr.popularDoctor), findsOneWidget);

    expect(find.byType(DoctorCategorySection), findsOneWidget);
    expect(find.byType(DoctorCategoryCard), findsWidgets);

    expect(find.text('Dr. Fillerup Grab'), findsOneWidget);
    expect(find.text('Dr. Blessing'), findsOneWidget);

    expect(find.byType(PopularDoctorCard), findsWidgets);
    expect(find.byType(Image), findsWidgets);

    final navBarFinder = find.byType(MainBottomNavigationBar);
    expect(navBarFinder, findsOneWidget);
    expect(
      find.descendant(
        of: navBarFinder,
        matching: find.byIcon(Icons.home_rounded),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: navBarFinder,
        matching: find.byIcon(Icons.favorite_rounded),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: navBarFinder,
        matching: find.byIcon(Icons.calendar_month_rounded),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: navBarFinder,
        matching: find.byIcon(Icons.settings_rounded),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'DoctorCategoryCard renders the specialty icon and handles tap properly',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final router = GoRouter(
        initialLocation: '/home',
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => testHomeScreen(
              onCategoryTap: () => context.push('/find-doctors'),
            ),
          ),
          GoRoute(
            path: '/find-doctors',
            builder: (context, state) => const Scaffold(),
          ),
        ],
      );

      await tester.pumpWidget(buildTestRouterApp(router));
      await tester.pump();

      final cardiologyCategory = find.byWidgetPredicate(
        (w) => w is DoctorCategoryCard && w.specialty.id == 'cardiologist',
      );

      final pediatricCategory = find.byWidgetPredicate(
        (w) => w is DoctorCategoryCard && w.specialty.id == 'pediatrician',
      );

      expect(
        find.descendant(
          of: pediatricCategory,
          matching: find.byIcon(Icons.child_care_rounded),
        ),
        findsOneWidget,
      );

      await tester.tap(cardiologyCategory);
      await tester.pumpAndSettle();

      expect(router.state.matchedLocation, '/find-doctors');
    },
  );

  testWidgets('BottomNavigationBar switches tabs across all 4 icon items', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    int currentIndex = 0;
    await tester.pumpWidget(
      buildTestApp(
        StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              bottomNavigationBar: MainBottomNavigationBar(
                currentIndex: currentIndex,
                onTap: (index) {
                  setState(() => currentIndex = index);
                },
              ),
            );
          },
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.favorite_rounded));
    await tester.pumpAndSettle();
    expect(currentIndex, 1);

    await tester.tap(find.byIcon(Icons.calendar_month_rounded));
    await tester.pumpAndSettle();
    expect(currentIndex, 2);

    await tester.tap(find.byIcon(Icons.settings_rounded));
    await tester.pumpAndSettle();
    expect(currentIndex, 3);

    await tester.tap(find.byIcon(Icons.home_rounded));
    await tester.pumpAndSettle();
    expect(currentIndex, 0);
  });

  testWidgets(
    'AppSearchBar in HomeScreen shows clear X button only when text is entered and clears text on tap',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final controller = TextEditingController();
      await tester.pumpWidget(
        buildTestApp(Scaffold(body: AppSearchBar(controller: controller))),
      );
      await tester.pump();

      final initialVisibility = tester.widget<Visibility>(
        find.byWidgetPredicate((w) => w is Visibility && w.child is IconButton),
      );
      expect(initialVisibility.visible, isFalse);

      await tester.enterText(find.byType(TextField), 'Dentist');
      await tester.pump();

      final activeVisibility = tester.widget<Visibility>(
        find.byWidgetPredicate((w) => w is Visibility && w.child is IconButton),
      );
      expect(activeVisibility.visible, isTrue);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();

      expect(controller.text, isEmpty);

      final clearedVisibility = tester.widget<Visibility>(
        find.byWidgetPredicate((w) => w is Visibility && w.child is IconButton),
      );
      expect(clearedVisibility.visible, isFalse);
    },
  );

  testWidgets('PopularDoctorCard renders favorite icons properly', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestApp(testHomeScreen()));
    await tester.pump();

    expect(find.byIcon(Icons.favorite_border_rounded), findsWidgets);
  });

  testWidgets(
    'HomeScreen language toggle toggles locale between English and Arabic',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        LocaleSettings.setLocaleSync(AppLocale.en);
      });

      await tester.pumpWidget(buildTestApp(testHomeScreen()));
      await tester.pump();

      expect(
        find.text(AppLocale.en.buildSync().findYourDoctor),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.language_rounded), findsOneWidget);
      expect(find.text('ع'), findsOneWidget);
      expect(LocaleSettings.currentLocale, AppLocale.en);

      await tester.tap(find.byIcon(Icons.language_rounded));
      await tester.pumpAndSettle();

      expect(LocaleSettings.currentLocale, AppLocale.ar);
      expect(
        find.text(AppLocale.ar.buildSync().findYourDoctor),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.translate_rounded), findsOneWidget);
      expect(find.text('EN'), findsOneWidget);
    },
  );

  testWidgets('Tapping profile avatar in HomeScreen navigates to /profile', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) =>
              testHomeScreen(onProfileTap: () => context.push('/profile')),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) =>
              const Scaffold(body: Text('ProfilePage')),
        ),
      ],
    );

    await tester.pumpWidget(buildTestRouterApp(router));
    await tester.pump();

    final avatarPlaceholder = find.byType(DoctorAvatarPlaceholder);
    expect(avatarPlaceholder, findsOneWidget);

    await tester.tap(avatarPlaceholder);
    await tester.pumpAndSettle();

    expect(router.state.matchedLocation, '/profile');
  });

  testWidgets('Tapping search bar in HomeScreen navigates to /doctors', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => BlocProvider<HomeCubit>(
            create: (_) => HomeCubit(repository: FakeDoctorRepository()),
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/doctors',
          builder: (context, state) =>
              const Scaffold(body: Text('FindDoctorsPage')),
        ),
      ],
    );

    await tester.pumpWidget(buildTestRouterApp(router));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(AppSearchBar));
    await tester.pumpAndSettle();

    expect(router.state.matchedLocation, '/doctors');
    expect(find.text('FindDoctorsPage'), findsOneWidget);
  });
}

Widget testHomeScreen({
  VoidCallback? onProfileTap,
  VoidCallback? onCategoryTap,
  VoidCallback? onSeeAllDoctors,
}) {
  final doctors = testHomeDoctors();
  final popularDoctors = doctors;

  final searchController = TextEditingController();

  return Builder(
    builder: (context) {
      final tr = TranslationProvider.of(context).translations;
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeaderSection(
                greeting: tr.greetingGeneric,
                title: tr.findYourDoctor,
                searchController: searchController,
                showLanguageToggle: true,
                showProfile: true,
                onProfileTap: onProfileTap,
              ),
              Column(
                children: [
                  const SizedBox(height: 24),
                  DoctorCategorySection(
                    specialties: testSpecialties(),
                    onSpecialtyTap: (_) => onCategoryTap?.call(),
                  ),
                  if (popularDoctors.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    DoctorsSection(
                      title: tr.popularDoctor,
                      doctors: popularDoctors,
                      favoriteIds: const {},
                      onFavoriteTap: (_) {},
                      onSeeAllPressed: onSeeAllDoctors ?? () {},
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: MainBottomNavigationBar(
          currentIndex: 0,
          onTap: (_) {},
        ),
      );
    },
  );
}

List<DoctorModel> testHomeDoctors() {
  return const [
    DoctorModel(
      id: 'doc_5',
      nameEn: 'Dr. Fillerup Grab',
      imageUrl: 'https://res.cloudinary.com/diexaortk/image/upload/popular_1',
      rating: 4.9,
      reviewsCount: 124,
    ),
    DoctorModel(
      id: 'doc_6',
      nameEn: 'Dr. Blessing',
      imageUrl: 'https://res.cloudinary.com/diexaortk/image/upload/popular_2',
    ),
  ];
}

List<SpecialtyModel> testSpecialties() {
  return const [
    SpecialtyModel(
      id: 'cardiologist',
      nameAr: 'طبيب قلب',
      nameEn: 'Cardiologist',
      iconKey: 'cardiology',
    ),
    SpecialtyModel(
      id: 'pediatrician',
      nameAr: 'طبيب أطفال',
      nameEn: 'Pediatrician',
      iconKey: 'pediatrics',
    ),
  ];
}
