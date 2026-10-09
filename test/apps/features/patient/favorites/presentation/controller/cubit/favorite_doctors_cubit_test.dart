import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorite_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorite_doctors_state.dart';

import '../../../../../../../helpers/test_fakes.dart';

void main() {
  late FakeDoctorRepository repository;
  late FavoriteDoctorsCubit cubit;

  final doctor1 = DoctorModel(
    id: 'doc-1',
    name: 'Dr. Sarah Smith',
    specialty: 'Cardiology',
    specialtyId: 'cardio',
    consultationFee: 50.0,
  );
  final doctor2 = DoctorModel(
    id: 'doc-2',
    name: 'Dr. John Doe',
    specialty: 'Dermatology',
    specialtyId: 'derma',
    consultationFee: 40.0,
  );

  setUp(() {
    repository = FakeDoctorRepository();
    cubit = FavoriteDoctorsCubit(doctorRepository: repository);
  });

  tearDown(() => cubit.close());

  test('initial state is FavoriteDoctorsInitial', () {
    // assert
    expect(cubit.state, isA<FavoriteDoctorsInitial>());
  });

  test(
    'load() emits [FavoriteDoctorsLoading, FavoriteDoctorsSuccess]',
    () async {
      // arrange
      repository.doctors = [doctor1, doctor2];

      // act
      await cubit.load();

      // assert
      expect(cubit.state, isA<FavoriteDoctorsSuccess>());
      final state = cubit.state as FavoriteDoctorsSuccess;
      expect(state.doctors, hasLength(2));
      expect(state.doctors.first.id, 'doc-1');
    },
  );

  test(
    'load() emits [FavoriteDoctorsLoading, FavoriteDoctorsFailure] on error',
    () async {
      // arrange
      repository.error = Exception('Failed to fetch doctors');

      // act
      await cubit.load();

      // assert
      expect(cubit.state, isA<FavoriteDoctorsFailure>());
    },
  );

  test('search() updates searchQuery in FavoriteDoctorsSuccess', () async {
    // arrange
    repository.doctors = [doctor1, doctor2];
    await cubit.load();

    // act
    cubit.search('sarah');

    // assert
    final state = cubit.state as FavoriteDoctorsSuccess;
    expect(state.searchQuery, 'sarah');
  });

  test('visibleFavoriteDoctors filters by favorites and query', () {
    // arrange
    final state = FavoriteDoctorsSuccess(
      doctors: [doctor1, doctor2],
      searchQuery: 'sarah',
    );

    // act
    final visible = visibleFavoriteDoctors(state, {'doc-1', 'doc-2'});

    // assert
    expect(visible, hasLength(1));
    expect(visible.first.id, 'doc-1');
  });

  test('visibleFavoriteDoctors excludes non-favorite doctors', () {
    // arrange
    final state = FavoriteDoctorsSuccess(
      doctors: [doctor1, doctor2],
      searchQuery: '',
    );

    // act
    final visible = visibleFavoriteDoctors(state, {'doc-2'});

    // assert
    expect(visible, hasLength(1));
    expect(visible.first.id, 'doc-2');
  });
}
