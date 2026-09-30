import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/utils/doctor_sort.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_state.dart';

import '../../../helpers/test_fakes.dart';

const _dentist = DoctorModel(
  id: 'dentist',
  name: 'Dr. Sara',
  nameAr: 'د. سارة',
  nameEn: 'Dr. Sara',
  specialty: 'Dentist',
  specialtyId: 'dentistry',
  rating: 4.9,
  reviewsCount: 5,
);
const _cardiologist = DoctorModel(
  id: 'cardiologist',
  name: 'Dr. Omar',
  nameAr: 'د. عمر',
  nameEn: 'Dr. Omar',
  specialty: 'Cardiologist',
  specialtyId: 'cardiology',
  rating: 4.1,
  reviewsCount: 30,
);

void main() {
  late FindDoctorsCubit cubit;

  setUp(() {
    cubit = FindDoctorsCubit(
      repository: FakeDoctorRepository(
        doctors: const [_dentist, _cardiologist],
        specialties: const [
          SpecialtyModel(id: 'dentistry', nameAr: 'أسنان', nameEn: 'Dentistry'),
        ],
      ),
    );
  });

  tearDown(() => cubit.close());

  List<String> visibleIds([Set<String> favoriteIds = const {}]) =>
      visibleDoctors(
        cubit.state as FindDoctorsSuccess,
        favoriteIds,
      ).map((doctor) => doctor.id).toList();

  test(
    'load emits loading then success with doctors and specialties',
    () async {
      // arrange
      final states = expectLater(
        cubit.stream,
        emitsInOrder([isA<FindDoctorsLoading>(), isA<FindDoctorsSuccess>()]),
      );

      // act
      await cubit.load();

      // assert
      await states;
      final state = cubit.state as FindDoctorsSuccess;
      expect(state.doctors, hasLength(2));
      expect(state.specialties.single.id, 'dentistry');
      expect(visibleIds(), ['cardiologist', 'dentist']);
    },
  );

  test('load applies route filters from Home', () async {
    // act
    await cubit.load(specialtyId: 'dentistry', sort: DoctorSort.topRated);

    // assert
    expect(visibleIds(), ['dentist']);
    expect((cubit.state as FindDoctorsSuccess).sort, DoctorSort.topRated);
  });

  test('load emits failure when the repository throws', () async {
    // arrange
    final failing = FindDoctorsCubit(repository: _ThrowingDoctorRepository());

    // act
    await failing.load();

    // assert
    expect(failing.state, isA<FindDoctorsFailure>());
    await failing.close();
  });

  test('search matches the Arabic or English name', () async {
    // arrange
    await cubit.load();

    // act
    cubit.search('عمر');

    // assert
    expect(visibleIds(), ['cardiologist']);
  });

  test('selectSpecialty(null) shows all doctors again', () async {
    // arrange
    await cubit.load(specialtyId: 'dentistry');

    // act
    cubit.selectSpecialty(null);

    // assert
    expect(visibleIds(), hasLength(2));
  });

  test('favorites filter keeps only the patient favorites', () async {
    // arrange
    await cubit.load();

    // act
    cubit.toggleFavoritesOnly();

    // assert
    expect(visibleIds({'dentist'}), ['dentist']);
  });

  test('sortBy topRated orders by rating desc', () async {
    // arrange
    await cubit.load();

    // act
    cubit.sortBy(DoctorSort.topRated);

    // assert
    expect(visibleIds(), ['dentist', 'cardiologist']);
  });

  test('applyRouteFilters replaces the current filters', () async {
    // arrange
    await cubit.load();
    cubit.search('Sara');
    cubit.toggleFavoritesOnly();

    // act
    cubit.applyRouteFilters(specialtyId: 'cardiology');

    // assert
    final state = cubit.state as FindDoctorsSuccess;
    expect(state.query, isEmpty);
    expect(state.favoritesOnly, isFalse);
    expect(visibleIds(), ['cardiologist']);
  });
}

class _ThrowingDoctorRepository extends FakeDoctorRepository {
  @override
  Future<List<DoctorModel>> fetchDoctors() async =>
      throw StateError('load failed');
}
