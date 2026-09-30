import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/screens/find_doctors_screen.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import '../../../helpers/test_app.dart';
import '../../../helpers/test_fakes.dart';

List<DoctorModel> testFindDoctors() {
  return const [
    DoctorModel(id: 'doc_1', name: 'Dr. Shruti Kedia', specialty: 'Dentist'),
    DoctorModel(
      id: 'doc_5',
      name: 'Dr. Fillerup Grab',
      specialty: 'Medicine Specialist',
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

  Future<void> pumpScreen(WidgetTester tester, {Set<String>? favorites}) async {
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
            child: const FindDoctorsScreen(),
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
    // act
    await pumpScreen(tester);

    // assert
    final tr = AppLocale.en.buildSync();
    expect(find.text(tr.searchDoctorHint), findsOneWidget);
    expect(find.text(tr.filterAll), findsOneWidget);
    expect(find.text(tr.favorites), findsOneWidget);
    expect(find.text(tr.sortPopular), findsOneWidget);
    expect(find.text('Dr. Shruti Kedia'), findsOneWidget);
    expect(find.text('Dr. Fillerup Grab'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);
  });

  testWidgets('tapping a heart toggles the favorite for the patient', (
    WidgetTester tester,
  ) async {
    // arrange
    await pumpScreen(tester, favorites: {});

    // act
    await tester.tap(find.byIcon(Icons.favorite_border_rounded).first);
    await tester.pump();

    // assert
    expect(favoritesRepository.writes, hasLength(1));
    expect(favoritesRepository.writes.single.$3, isTrue);
  });

  testWidgets('Favorites chip shows only favorite doctors', (
    WidgetTester tester,
  ) async {
    // arrange
    await pumpScreen(tester, favorites: {'doc_5'});

    // act
    await tester.tap(find.text(AppLocale.en.buildSync().favorites));
    await tester.pump();

    // assert
    expect(find.text('Dr. Fillerup Grab'), findsOneWidget);
    expect(find.text('Dr. Shruti Kedia'), findsNothing);
  });

  testWidgets('search with no match shows the empty state', (
    WidgetTester tester,
  ) async {
    // arrange
    await pumpScreen(tester);

    // act
    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump();

    // assert
    expect(find.text(AppLocale.en.buildSync().noDoctorsFound), findsOneWidget);
  });
}
