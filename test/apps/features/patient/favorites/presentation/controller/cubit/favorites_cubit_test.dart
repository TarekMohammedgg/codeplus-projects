import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_state.dart';

import '../../../../../../../helpers/test_fakes.dart';

void main() {
  late FakeFavoritesRepository repository;
  late FavoritesCubit cubit;

  setUp(() {
    repository = FakeFavoritesRepository();
    cubit = FavoritesCubit(repository: repository);
  });

  tearDown(() => cubit.close());

  Future<void> signIn(String userId, Set<String> favorites) async {
    repository.userIds.add(userId);
    await pumpEventQueue();
    repository.favoriteIds.add(favorites);
    await pumpEventQueue();
  }

  test('emits the signed-in patient favorites', () async {
    // act
    await signIn('patient-1', {'doc-1'});

    // assert
    expect(repository.watchedUserIds, ['patient-1']);
    expect(cubit.state, isA<FavoritesSuccess>());
    expect(cubit.state.isFavorite('doc-1'), isTrue);
  });

  test('clears favorites when the user signs out', () async {
    // arrange
    await signIn('patient-1', {'doc-1'});

    // act
    repository.userIds.add(null);
    await pumpEventQueue();

    // assert
    expect(cubit.state, isA<FavoritesInitial>());
    expect(cubit.state.doctorIds, isEmpty);
  });

  test('watches the new patient after switching accounts', () async {
    // arrange
    await signIn('patient-1', {'doc-1'});

    // act
    repository.userIds.add('patient-2');
    await pumpEventQueue();

    // assert
    expect(repository.watchedUserIds, ['patient-1', 'patient-2']);
    expect(cubit.state.doctorIds, isEmpty);
  });

  test('toggle adds a doctor that is not a favorite', () async {
    // arrange
    await signIn('patient-1', {});

    // act
    await cubit.toggle('doc-1');

    // assert
    expect(cubit.state.isFavorite('doc-1'), isTrue);
    expect(repository.writes, [('patient-1', 'doc-1', true)]);
  });

  test('toggle removes a doctor that is a favorite', () async {
    // arrange
    await signIn('patient-1', {'doc-1'});

    // act
    await cubit.toggle('doc-1');

    // assert
    expect(cubit.state.isFavorite('doc-1'), isFalse);
    expect(repository.writes, [('patient-1', 'doc-1', false)]);
  });

  test('toggle failure restores the previous favorites', () async {
    // arrange
    await signIn('patient-1', {'doc-1'});
    repository.setFavoriteError = StateError('write failed');

    // act
    await cubit.toggle('doc-2');

    // assert
    expect(cubit.state, isA<FavoritesFailure>());
    expect(cubit.state.doctorIds, {'doc-1'});
  });

  test('toggle does nothing when signed out', () async {
    // act
    await cubit.toggle('doc-1');

    // assert
    expect(cubit.state, isA<FavoritesInitial>());
    expect(repository.writes, isEmpty);
  });
}
