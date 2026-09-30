import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/data/service/favorites_service.dart';

abstract interface class FavoritesRepository {
  /// The signed-in user's uid, or null when signed out.
  Stream<String?> userIdChanges();

  Stream<Set<String>> watchFavoriteIds(String userId);

  Future<void> setFavorite({
    required String userId,
    required String doctorId,
    required bool isFavorite,
  });
}

class FirebaseFavoritesRepository implements FavoritesRepository {
  FirebaseFavoritesRepository({
    required this.favoritesService,
    required this.authService,
  });

  final FavoritesService favoritesService;
  final AuthService authService;

  @override
  Stream<String?> userIdChanges() => authService.userIdChanges();

  @override
  Stream<Set<String>> watchFavoriteIds(String userId) =>
      favoritesService.watchFavoriteIds(userId);

  @override
  Future<void> setFavorite({
    required String userId,
    required String doctorId,
    required bool isFavorite,
  }) {
    return isFavorite
        ? favoritesService.addFavorite(userId: userId, doctorId: doctorId)
        : favoritesService.removeFavorite(userId: userId, doctorId: doctorId);
  }
}
