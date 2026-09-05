import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/favourite_doctors/presentation/screens/favourite_doctors_screen.dart';
import 'package:doctor_hunt/apps/features/favourite_doctors/presentation/widgets/favourite_doctor_card.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'test_app.dart';

List<DoctorModel> testFavouriteDoctors() {
  return const [
    DoctorModel(
      id: 'fav_1',
      name: 'Dr. Shouey',
      specialty: 'Medicine Specialist',
      isFavorite: true,
    ),
    DoctorModel(
      id: 'fav_2',
      name: 'Dr. Christen',
      specialty: 'Dental Specialist',
      isFavorite: true,
    ),
  ];
}

List<DoctorModel> testFeaturedDoctors() {
  return const [
    DoctorModel(
      id: 'feat_1',
      name: 'Dr. Cric',
      specialty: 'General Surgeon',
      isFeatured: true,
    ),
  ];
}

Widget buildTestFavouriteScreen() {
  return FavouriteDoctorsScreen(
    initialFavouriteDoctors: testFavouriteDoctors(),
    initialFeaturedDoctors: testFeaturedDoctors(),
  );
}

void main() {
  testWidgets(
    'FavouriteDoctorsScreen renders header, search and doctor cards',
    (WidgetTester tester) async {
      final tr = AppLocale.en.buildSync();
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestApp(buildTestFavouriteScreen()));
      await tester.pump();

      expect(find.text(tr.favouriteDoctors), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(FavouriteDoctorCard), findsWidgets);
      expect(find.text('Dr. Shouey'), findsOneWidget);
      expect(find.text('Dr. Christen'), findsOneWidget);
      expect(find.text(tr.featuredDoctor), findsOneWidget);
    },
  );

  testWidgets('Tapping FavouriteDoctorCard navigates to DoctorDetailsRoute', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final router = GoRouter(
      initialLocation: '/favourite-doctors',
      routes: [
        GoRoute(
          path: '/favourite-doctors',
          builder: (context, state) => buildTestFavouriteScreen(),
        ),
        GoRoute(
          path: '/doctor-details',
          builder: (context, state) =>
              const Scaffold(body: Text('DetailsScreen')),
        ),
      ],
    );

    await tester.pumpWidget(buildTestRouterApp(router));
    await tester.pump();

    await tester.tap(find.text('Dr. Shouey'));
    await tester.pumpAndSettle();

    expect(router.state.matchedLocation, '/doctor-details');
  });

  testWidgets(
    'FavouriteDoctorsScreen renders cleanly on compact screen without overflow',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestApp(buildTestFavouriteScreen()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(FavouriteDoctorCard), findsWidgets);
    },
  );

  testWidgets(
    'FavouriteDoctorsScreen renders HomeBottomNavigationBar and navigates home on tap',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final router = GoRouter(
        initialLocation: '/favourite-doctors',
        routes: [
          GoRoute(
            path: '/favourite-doctors',
            builder: (context, state) => buildTestFavouriteScreen(),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) =>
                const Scaffold(body: Text('HomeScreen')),
          ),
        ],
      );

      await tester.pumpWidget(buildTestRouterApp(router));
      await tester.pump();

      expect(find.byIcon(Icons.favorite_rounded), findsWidgets);
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.home_rounded));
      await tester.pumpAndSettle();

      expect(router.state.matchedLocation, '/home');
    },
  );
}
