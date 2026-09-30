import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/utils/rating_utils.dart';

void main() {
  test('first review makes the average equal to the new rating', () {
    // act
    final average = nextAverage(0, 0, 4);

    // assert
    expect(average, 4);
  });

  test('adds a rating to an existing average', () {
    // act
    final average = nextAverage(4.0, 3, 5);

    // assert
    expect(average, 4.25);
  });
}
