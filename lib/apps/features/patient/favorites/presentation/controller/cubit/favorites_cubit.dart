import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/features/patient/favorites/data/repositories/favorites_repository.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_state.dart';

/// App-wide favorites of the signed-in patient. Follows auth changes so a
/// different patient never sees the previous patient's hearts.
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({required this.repository}) : super(const FavoritesInitial()) {
    _userSubscription = repository.userIdChanges().listen(
      _onUserChanged,
      onError: addError,
    );
  }

  final FavoritesRepository repository;

  late final StreamSubscription<String?> _userSubscription;
  StreamSubscription<Set<String>>? _favoritesSubscription;
  String? _userId;

  void _onUserChanged(String? userId) {
    if (userId == _userId) return;
    _userId = userId;
    _favoritesSubscription?.cancel();
    _favoritesSubscription = null;
    emit(const FavoritesInitial());
    if (userId == null) return;

    _favoritesSubscription = repository
        .watchFavoriteIds(userId)
        .listen(
          (ids) => emit(FavoritesSuccess(doctorIds: ids)),
          onError: (Object error, StackTrace stackTrace) {
            addError(error, stackTrace);
            emit(FavoritesFailure(doctorIds: state.doctorIds));
          },
        );
  }

  Future<void> toggle(String doctorId) async {
    final userId = _userId;
    if (userId == null) return;

    final previous = state.doctorIds;
    final makeFavorite = !previous.contains(doctorId);
    // Optimistic: the heart flips now, the Firestore stream confirms it.
    emit(
      FavoritesSuccess(
        doctorIds: makeFavorite
            ? {...previous, doctorId}
            : ({...previous}..remove(doctorId)),
      ),
    );
    try {
      await repository.setFavorite(
        userId: userId,
        doctorId: doctorId,
        isFavorite: makeFavorite,
      );
    } catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      emit(FavoritesFailure(doctorIds: previous));
    }
  }

  @override
  Future<void> close() async {
    await _userSubscription.cancel();
    await _favoritesSubscription?.cancel();
    return super.close();
  }
}
