import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_state.dart';

import '../../../../../../../helpers/test_fakes.dart';

void main() {
  const mostReviewed = DoctorModel(
    id: 'most_reviewed',
    nameEn: 'Dr. Popular',
    rating: 4,
    reviewsCount: 50,
  );
  const bestRated = DoctorModel(
    id: 'best_rated',
    nameEn: 'Dr. Top',
    rating: 5,
    reviewsCount: 3,
  );

  test('load sorts popular by reviews and top rated by rating', () async {
    // arrange
    final cubit = HomeCubit(
      repository: FakeDoctorRepository(
        doctors: [bestRated, mostReviewed],
        specialties: const [
          SpecialtyModel(id: 'dentist', nameAr: 'أسنان', nameEn: 'Dentist'),
        ],
      ),
    );

    // act
    await cubit.load();

    // assert
    final state = cubit.state as HomeSuccess;
    expect(state.popularDoctors.map((d) => d.id), [
      'most_reviewed',
      'best_rated',
    ]);
    expect(state.topRatedDoctors.map((d) => d.id), [
      'best_rated',
      'most_reviewed',
    ]);
    expect(state.specialties.single.id, 'dentist');
    await cubit.close();
  });

  test('load emits loading then failure when the repository throws', () async {
    // arrange
    final cubit = HomeCubit(
      repository: FakeDoctorRepository(error: StateError('load failed')),
    );
    final states = expectLater(
      cubit.stream,
      emitsInOrder([isA<HomeLoading>(), isA<HomeFailure>()]),
    );

    // act
    await cubit.load();

    // assert
    await states;
    await cubit.close();
  });
}
