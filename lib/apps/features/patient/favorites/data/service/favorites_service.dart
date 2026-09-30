import 'package:cloud_firestore/cloud_firestore.dart';

/// Per-patient favorites stored in `users/{uid}/favorites/{doctorId}`.
class FavoritesService {
  FavoritesService({
    required FirebaseFirestore firestore,
    // ignore: prefer_initializing_formals
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _favorites(String userId) =>
      _firestore.collection('users').doc(userId).collection('favorites');

  Stream<Set<String>> watchFavoriteIds(String userId) {
    return _favorites(
      userId,
    ).snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.id).toSet());
  }

  Future<void> addFavorite({required String userId, required String doctorId}) {
    return _favorites(
      userId,
    ).doc(doctorId).set({'createdAt': FieldValue.serverTimestamp()});
  }

  Future<void> removeFavorite({
    required String userId,
    required String doctorId,
  }) {
    return _favorites(userId).doc(doctorId).delete();
  }
}
