/// Every state carries the favorite doctor ids so hearts keep rendering
/// while a toggle fails.
sealed class FavoritesState {
  const FavoritesState({this.doctorIds = const {}});

  final Set<String> doctorIds;

  bool isFavorite(String doctorId) => doctorIds.contains(doctorId);
}

final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

final class FavoritesSuccess extends FavoritesState {
  const FavoritesSuccess({required super.doctorIds});
}

final class FavoritesFailure extends FavoritesState {
  const FavoritesFailure({required super.doctorIds});
}
