import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/widgets/app_search_bar.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorite_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/screens/favorites_screen.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/widgets/find_doctors_widgets.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../../../../helpers/test_app.dart';
import '../../../../../../helpers/test_fakes.dart';

List<DoctorModel> testDoctors() {
  return [
    DoctorModel(
      id: 'doc_1',
      name: 'Dr. Sarah Smith',
      specialty: 'Cardiology',
      specialtyId: 'cardio',
      consultationFee: 50.0,
      rating: 4.8,
      reviewsCount: 30,
    ),
    DoctorModel(
      id: 'doc_2',
      name: 'Dr. John Doe',
      specialty: 'Dermatology',
      specialtyId: 'derma',
      consultationFee: 40.0,
      rating: 4.5,
      reviewsCount: 20,
    ),
  ];
}

void main() {
  late FakeFavoritesRepository favoritesRepository;
  late FavoritesCubit favoritesCubit;

  Future<void> pumpScreen(
    WidgetTester tester, {
    Set<String> favorites = const {},
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    favoritesRepository = FakeFavoritesRepository(
      initialUserId: 'patient-1',
      initialFavorites: favorites,
    );
    favoritesCubit = FavoritesCubit(repository: favoritesRepository);
    addTearDown(favoritesCubit.close);

    await tester.pumpWidget(
      buildTestApp(
        BlocProvider<FavoritesCubit>.value(
          value: favoritesCubit,
          child: BlocProvider<FavoriteDoctorsCubit>(
            create: (_) => FavoriteDoctorsCubit(
              doctorRepository: FakeDoctorRepository(doctors: testDoctors()),
            ),
            child: const FavoritesScreen(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  testWidgets(
    'FavoritesScreen renders title, search bar, and empty state initially',
    (WidgetTester tester) async {
      // act
      await pumpScreen(tester, favorites: {});

      // assert
      final tr = AppLocale.en.buildSync();
      expect(find.text(tr.tabFavorites), findsOneWidget);
      expect(find.byType(AppSearchBar), findsOneWidget);
      expect(find.text(tr.noFavoritesFound), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    },
  );

  testWidgets(
    'FavoritesScreen renders favorite doctor cards when patient has favorites',
    (WidgetTester tester) async {
      // act
      await pumpScreen(tester, favorites: {'doc_1'});

      // assert
      expect(find.byType(FindDoctorCard), findsOneWidget);
      expect(find.text('Dr. Sarah Smith'), findsOneWidget);
      expect(find.text('Dr. John Doe'), findsNothing);
    },
  );

  testWidgets('FavoritesScreen toggling heart icon calls repository', (
    WidgetTester tester,
  ) async {
    // arrange
    await pumpScreen(tester, favorites: {'doc_1'});

    // act
    await tester.tap(find.byIcon(Icons.favorite_rounded).first);
    await tester.pump();

    // assert
    expect(favoritesRepository.writes, [('patient-1', 'doc_1', false)]);
  });

  testWidgets('FavoritesScreen search bar filters the favorite doctors', (
    WidgetTester tester,
  ) async {
    // arrange
    await pumpScreen(tester, favorites: {'doc_1', 'doc_2'});
    expect(find.byType(FindDoctorCard), findsNWidgets(2));

    // act
    await tester.enterText(find.byType(TextField), 'John');
    await tester.pump();

    // assert
    expect(find.text('Dr. John Doe'), findsOneWidget);
    expect(find.text('Dr. Sarah Smith'), findsNothing);
  });
}
