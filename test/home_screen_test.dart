import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/apps/features/home/presentation/screens/home_screen.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'test_app.dart';

void main() {
  testWidgets('HomeScreen renders Doctor Hunt home UI elements properly', (
    WidgetTester tester,
  ) async {
    final t = AppLocale.en.buildSync();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestApp(const HomeScreen()));

    expect(find.text(t.hiSteven), findsOneWidget);
    expect(find.text(t.findYourDoctor), findsOneWidget);

    expect(find.text(t.searchDoctorHint), findsOneWidget);

    expect(find.text(t.liveDoctor), findsOneWidget);
    expect(find.text(t.popularDoctor), findsOneWidget);
    expect(find.text(t.featuredDoctor), findsOneWidget);

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
    expect(find.byIcon(Icons.settings_rounded), findsOneWidget);
    expect(find.byIcon(Icons.menu_book_rounded), findsOneWidget);
    expect(find.byIcon(Icons.chat_bubble_rounded), findsOneWidget);
  });

  testWidgets('DoctorCategoryCard handles tap properly', (
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
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/find-doctors',
          builder: (context, state) => const Scaffold(),
        ),
      ],
    );

    await tester.pumpWidget(buildTestRouterApp(router));

    await tester.tap(
      find.byWidgetPredicate(
        (w) => w is DoctorCategoryCard && w.category.id == 'cat_cardiology',
      ),
    );
    await tester.pumpAndSettle();

    expect(router.state.matchedLocation, '/find-doctors');
  });

  testWidgets('BottomNavigationBar switches tabs across all 4 icon items', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestApp(const HomeScreen()));

    final homeScreenState = tester.state<HomeScreenState>(
      find.byType(HomeScreen),
    );

    await tester.tap(
      find.byWidgetPredicate(
        (w) => w is NavItem && w.icon == Icons.favorite_rounded,
      ),
    );
    await tester.pumpAndSettle();
    expect(homeScreenState.selectedNavIndex, 1);

    await tester.tap(find.byIcon(Icons.menu_book_rounded));
    await tester.pumpAndSettle();
    expect(homeScreenState.selectedNavIndex, 2);

    await tester.tap(find.byIcon(Icons.chat_bubble_rounded));
    await tester.pumpAndSettle();
    expect(homeScreenState.selectedNavIndex, 3);

    await tester.tap(find.byIcon(Icons.home_rounded));
    await tester.pumpAndSettle();
    expect(homeScreenState.selectedNavIndex, 0);
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

    await tester.pumpWidget(buildTestApp(const HomeScreen()));

    final liveDoctorCardFinder = find.byType(LiveDoctorCard).first;
    expect(liveDoctorCardFinder, findsOneWidget);

    final imageFinder = find.descendant(
      of: liveDoctorCardFinder,
      matching: find.byType(Image),
    );
    expect(imageFinder, findsOneWidget);

    final imageWidget = tester.widget<Image>(imageFinder);
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

      await tester.pumpWidget(buildTestApp(const HomeScreen()));

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

      final homeScreenState = tester.state<HomeScreenState>(
        find.byType(HomeScreen),
      );
      expect(homeScreenState.searchController.text, isEmpty);

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

      await tester.pumpWidget(buildTestApp(const HomeScreen()));

      expect(find.byIcon(Icons.favorite_rounded), findsWidgets);
      expect(find.byIcon(Icons.favorite_border_rounded), findsWidgets);
    },
  );
}
