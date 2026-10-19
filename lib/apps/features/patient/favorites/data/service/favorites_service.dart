import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/apps/core/services/firestore_collections.dart';

class FavoritesService {
  FavoritesService({required this.firestore});

  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> _favorites(String userId) =>
      firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .collection(FirestoreCollections.favorites);

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
