import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:doctor_hunt/apps/core/services/firestore_collections.dart';
import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/features/common/role_selection/data/models/user_role.dart';

class AuthService {
  static String get serverClientId =>
      (dotenv.isInitialized ? dotenv.maybeGet('SERVER_CLIENT_ID') : null) ?? '';

  //CR [Correct DI Approach for Service Layer]:
  //CR Do not use nullable `_auth` or `_safeAuth()` fallback that catches and swallows startup errors.
  //CR Step 1: Register FirebaseAuth in `injection.dart`:
  //CR   `getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);`
  //CR Step 2: Inject non-nullable `FirebaseAuth` directly into AuthService:
  //CR   ```dart
  //CR   class AuthService {
  //CR     final FirebaseAuth auth;
  //CR     AuthService({required this.auth});
  //CR   }
  //CR   ```
  // solved
  AuthService({required this.auth, required this.firestore});

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  // Cached role of the signed-in user; reset on every sign-in / sign-out.
  bool? _isAdmin;

  static Future<void> initialize() async {
    final clientId = serverClientId;
    await GoogleSignIn.instance.initialize(
      serverClientId: clientId.isNotEmpty ? clientId : null,
    );
  }

  User? get currentUser => auth.currentUser;

  bool get hasPasswordProvider =>
      currentUser?.providerData.any(
        (p) => p.providerId == EmailAuthProvider.PROVIDER_ID,
      ) ??
      false;

  Future<void> updateDisplayNameAndPhoto(String name, String? photoUrl) async {
    final user = currentUser;
    if (user == null) return;
    await user.updateDisplayName(name);
    if (photoUrl != null && photoUrl.isNotEmpty) {
      await user.updatePhotoURL(photoUrl);
    }
  }

  Future<void> requestEmailChange(String newEmail) async {
    await currentUser?.verifyBeforeUpdateEmail(newEmail);
  }

  Stream<String?> userIdChanges() =>
      auth.authStateChanges().map((user) => user?.uid);

  //CR Layer separation defect: Data service must never take BuildContext or handle UI greetings/translations.
  // solved

  Future<void> signOut() async {
    _isAdmin = null;
    await Future.wait([auth.signOut(), GoogleSignIn.instance.signOut()]);
  }

  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (name != null && name.trim().isNotEmpty) {
      await userCredential.user?.updateDisplayName(name.trim());
      await userCredential.user?.reload();
    }

    final user = userCredential.user;
    if (user != null) await ensureUserProfile(user);
    _isAdmin = null;
    return userCredential;
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user != null) await ensureUserProfile(user);
    _isAdmin = null;
    return credential;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final credential = GoogleAuthProvider.credential(
        idToken: googleUser.authentication.idToken,
      );

      final result = await auth.signInWithCredential(credential);
      final user = result.user;
      if (user != null) await ensureUserProfile(user);
      _isAdmin = null;
      return result;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      throw AppException.from(e);
    }
  }

  Future<void> ensureUserProfile(User user) async {
    final reference = firestore
        .collection(FirestoreCollections.users)
        .doc(user.uid);
    final snapshot = await reference.get();

    if (snapshot.exists) {
      final existingData = snapshot.data() ?? const <String, dynamic>{};
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };
      final existingName = existingData['displayName'] as String?;
      if ((existingName == null || existingName.trim().isEmpty) &&
          user.displayName != null &&
          user.displayName!.trim().isNotEmpty) {
        updateData['displayName'] = user.displayName!.trim();
      }
      if (user.email != null && user.email!.trim().isNotEmpty) {
        updateData['email'] = user.email!.trim();
      }
      final existingPhoto = existingData['photoUrl'] as String?;
      if ((existingPhoto == null || existingPhoto.trim().isEmpty) &&
          user.photoURL != null &&
          user.photoURL!.trim().isNotEmpty) {
        updateData['photoUrl'] = user.photoURL!.trim();
      }
      await reference.set(updateData, SetOptions(merge: true));
      return;
    }

    await reference.set({
      'displayName': user.displayName?.trim() ?? '',
      'email': user.email?.trim() ?? '',
      if (user.photoURL != null && user.photoURL!.trim().isNotEmpty)
        'photoUrl': user.photoURL!.trim(),
      'role': UserRole.patient.name,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> isCurrentUserAdmin() async {
    final user = currentUser;
    if (user == null) {
      _isAdmin = null;
      return false;
    }
    if (_isAdmin != null) return _isAdmin!;
    final snapshot = await firestore
        .collection(FirestoreCollections.users)
        .doc(user.uid)
        .get();
    final isAdmin = snapshot.data()?['role'] == UserRole.admin.name;
    _isAdmin = isAdmin;
    return isAdmin;
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      throw AppException.from(e);
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = currentUser;
    if (user == null || user.email == null || user.email!.isEmpty) {
      throw const AppException(AppErrorCode.userNotFound);
    }
    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw const AppException(AppErrorCode.wrongCurrentPassword);
      }
      throw AppException.from(e);
    } catch (e) {
      throw AppException.from(e);
    }
  }
}
