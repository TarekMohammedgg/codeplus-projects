import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/repositories/home_repository.dart';

void main() {
  const mostReviewed = DoctorModel(
    id: 'most-reviewed',
    name: 'A',
    specialty: 'S',
    rating: 4.2,
    reviewsCount: 40,
  );
  const bestRated = DoctorModel(
    id: 'best-rated',
    name: 'B',
    specialty: 'S',
    rating: 4.9,
    reviewsCount: 8,
  );
  const newDoctor = DoctorModel(id: 'new', name: 'C', specialty: 'S');
  const doctors = [newDoctor, bestRated, mostReviewed];

  test('sortByPopularity orders by reviewsCount desc', () {
    // act
    final sorted = sortByPopularity(doctors);

    // assert
    expect(sorted.map((d) => d.id), ['most-reviewed', 'best-rated', 'new']);
  });

  test('sortByTopRated orders by rating desc', () {
    // act
    final sorted = sortByTopRated(doctors);

    // assert
    expect(sorted.map((d) => d.id), ['best-rated', 'most-reviewed', 'new']);
  });

  test('sortByPopularity breaks reviewsCount ties by rating', () {
    // arrange
    const lowRated = DoctorModel(
      id: 'low',
      name: 'D',
      specialty: 'S',
      rating: 3,
      reviewsCount: 10,
    );
    const highRated = DoctorModel(
      id: 'high',
      name: 'E',
      specialty: 'S',
      rating: 5,
      reviewsCount: 10,
    );

    // act
    final sorted = sortByPopularity([lowRated, highRated]);

    // assert
    expect(sorted.map((d) => d.id), ['high', 'low']);
  });

  test('sorting does not mutate the input list', () {
    // arrange
    final input = [...doctors];

    // act
    sortByTopRated(input);

    // assert
    expect(input.map((d) => d.id), ['new', 'best-rated', 'most-reviewed']);
  });
}
