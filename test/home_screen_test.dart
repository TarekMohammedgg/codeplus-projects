import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/core/widgets/app_search_bar.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/features/home/data/doctors_categories.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/doctor_category_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/featured_doctor_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/live_doctor_section.dart';
import 'package:doctor_hunt/apps/features/home/presentation/widgets/popular_doctor_section.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'test_app.dart';

void main() {
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

    expect(find.text(tr.hiSteven), findsOneWidget);
    expect(find.text(tr.findYourDoctor), findsOneWidget);

    expect(find.text(tr.searchDoctorHint), findsOneWidget);

    expect(find.text(tr.liveDoctor), findsOneWidget);
    expect(find.text(tr.popularDoctor), findsOneWidget);
    expect(find.text(tr.featuredDoctor), findsOneWidget);

    expect(find.byType(DoctorCategorySection), findsOneWidget);
    expect(find.byType(DoctorCategoryCard), findsWidgets);

    expect(find.text('Dr. Fillerup Grab'), findsOneWidget);
    expect(find.text('Dr. Blessing'), findsOneWidget);

    expect(find.byType(LiveDoctorCard), findsWidgets);
    expect(find.byType(PopularDoctorCard), findsWidgets);
    expect(find.byType(Image), findsWidgets);

    expect(find.text('Dr. Cric'), findsOneWidget);

    expect(find.byType(HomeBottomNavigationBar), findsOneWidget);
    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    expect(find.byIcon(Icons.language_rounded), findsOneWidget);
    expect(find.byIcon(Icons.menu_book_rounded), findsOneWidget);
    expect(find.byIcon(Icons.chat_bubble_rounded), findsOneWidget);
  });

  testWidgets(
    'DoctorCategoryCard renders image when available, falls back to icon, and handles tap properly',
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
        (w) => w is DoctorCategoryCard && w.category.id == 'cat_cardiology',
      );

      expect(
        find.descendant(of: cardiologyCategory, matching: find.byType(Image)),
        findsOneWidget,
      );

      final pediatricCategory = find.byWidgetPredicate(
        (w) => w is DoctorCategoryCard && w.category.id == 'cat_pediatric',
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
              bottomNavigationBar: HomeBottomNavigationBar(
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

    await tester.tap(
      find.byWidgetPredicate(
        (w) => w is NavItem && w.icon == Icons.favorite_rounded,
      ),
    );
    await tester.pumpAndSettle();
    expect(currentIndex, 1);

    await tester.tap(find.byIcon(Icons.menu_book_rounded));
    await tester.pumpAndSettle();
    expect(currentIndex, 2);

    await tester.tap(find.byIcon(Icons.chat_bubble_rounded));
    await tester.pumpAndSettle();
    expect(currentIndex, 3);

    await tester.tap(find.byIcon(Icons.home_rounded));
    await tester.pumpAndSettle();
    expect(currentIndex, 0);
  });

  testWidgets('LiveDoctorCard doctor image fills the full container', (
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

    final liveDoctorCardFinder = find.byType(LiveDoctorCard).first;
    expect(liveDoctorCardFinder, findsOneWidget);

    final imageFinder = find.descendant(
      of: liveDoctorCardFinder,
      matching: find.byType(DoctorImage),
    );
    expect(imageFinder, findsOneWidget);

    final imageWidget = tester.widget<DoctorImage>(imageFinder);
    expect(
      imageWidget.imageUrl,
      startsWith('https://res.cloudinary.com/diexaortk/image/upload/'),
    );
    expect(imageWidget.fit, BoxFit.cover);
    expect(imageWidget.width, double.infinity);
    expect(imageWidget.height, double.infinity);
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

  testWidgets(
    'PopularDoctorCard and FeaturedDoctorCard render favorite icons properly',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestApp(testHomeScreen()));
      await tester.pump();

      expect(find.byIcon(Icons.favorite_rounded), findsWidgets);
      expect(find.byIcon(Icons.favorite_border_rounded), findsWidgets);
    },
  );

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
}

Widget testHomeScreen({
  VoidCallback? onProfileTap,
  VoidCallback? onCategoryTap,
  VoidCallback? onSeeAllDoctors,
}) {
  final doctors = testHomeDoctors();
  final liveDoctors =
      doctors.where((d) => d.isLive).toList()
        ..sort((a, b) => a.liveOrder.compareTo(b.liveOrder));
  final popularDoctors =
      doctors.where((d) => d.isPopular).toList()
        ..sort((a, b) => a.popularOrder.compareTo(b.popularOrder));
  final featuredDoctors =
      doctors.where((d) => d.isFeatured).toList()
        ..sort((a, b) => a.featuredOrder.compareTo(b.featuredOrder));

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
                greeting: tr.hiSteven,
                title: tr.findYourDoctor,
                searchController: searchController,
                showLanguageToggle: true,
                showProfile: true,
                onProfileTap: onProfileTap,
              ),
              Column(
                children: [
                  if (liveDoctors.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    LiveDoctorSection(
                      liveDoctors: liveDoctors,
                      onSeeAllPressed: onSeeAllDoctors ?? () {},
                    ),
                  ],
                  const SizedBox(height: 24),
                  DoctorCategorySection(
                    categories: categories(),
                    onCategoryTap: (_) => onCategoryTap?.call(),
                  ),
                  if (popularDoctors.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    PopularDoctorSection(
                      doctors: popularDoctors,
                      onSeeAllPressed: onSeeAllDoctors ?? () {},
                    ),
                  ],
                  if (featuredDoctors.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    FeaturedDoctorSection(
                      doctors: featuredDoctors,
                      onSeeAllPressed: onSeeAllDoctors ?? () {},
                    ),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: HomeBottomNavigationBar(
          currentIndex: 0,
          onTap: (_) {},
        ),
      );
    },
  );
}

List<DoctorModel> testHomeDoctors() {
  return [
    DoctorModel.fromFirestore('live_1', {
      'name': 'Dr. Stephanie',
      'specialtyKey': 'live_cardiologist',
      'imageUrl': 'https://res.cloudinary.com/diexaortk/image/upload/live_1',
      'isLive': true,
      'liveOrder': 1,
    }),
    DoctorModel.fromFirestore('doc_5', {
      'name': 'Dr. Fillerup Grab',
      'specialtyKey': 'medicine_specialist',
      'imageUrl': 'https://res.cloudinary.com/diexaortk/image/upload/popular_1',
      'rating': 4.9,
      'reviewsCount': 124,
      'hourlyRate': 30,
      'isPopular': true,
      'popularOrder': 1,
    }),
    DoctorModel.fromFirestore('doc_6', {
      'name': 'Dr. Blessing',
      'specialtyKey': 'dental_specialist',
      'imageUrl': 'https://res.cloudinary.com/diexaortk/image/upload/popular_2',
      'isFavorite': true,
      'isPopular': true,
      'popularOrder': 2,
    }),
    DoctorModel.fromFirestore('feat_1', {
      'name': 'Dr. Cric',
      'specialtyKey': 'general_surgeon',
      'imageUrl':
          'https://res.cloudinary.com/diexaortk/image/upload/featured_1',
      'isFeatured': true,
      'featuredOrder': 1,
    }),
  ];
}
