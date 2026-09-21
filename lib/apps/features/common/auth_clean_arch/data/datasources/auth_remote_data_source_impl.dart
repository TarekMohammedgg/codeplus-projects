import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/data/datasources/auth_remote_data_source.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/data/models/user_model.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/entities/user_entity.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    // ignore: prefer_initializing_formals
  }) : _auth = auth,
       // ignore: prefer_initializing_formals
       _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  static const _usersCollection = 'users';
  static const _roleField = 'role';

  static String get serverClientId =>
      (dotenv.isInitialized ? dotenv.maybeGet('SERVER_CLIENT_ID') : null) ?? '';

  static Future<void> initialize() async {
    final clientId = serverClientId;
    await GoogleSignIn.instance.initialize(
      serverClientId: clientId.isNotEmpty ? clientId : null,
    );
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user!;
      await _ensureUserProfile(user);
      final role = await _getUserRole(user.uid);
      return UserModel.fromFirebaseUser(user, role: role);
    } on FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuth(e);
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user!;
      if (name.trim().isNotEmpty) {
        await user.updateDisplayName(name.trim());
        await user.reload();
      }
      await _ensureUserProfile(user);
      return UserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuth(e);
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final credential = GoogleAuthProvider.credential(
        idToken: googleUser.authentication.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      final user = result.user;
      if (user == null) return null;

      await _ensureUserProfile(user);
      final role = await _getUserRole(user.uid);
      return UserModel.fromFirebaseUser(user, role: role);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      throw AppException.fromGoogleSignIn(e);
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuth(e);
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), GoogleSignIn.instance.signOut()]);
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      final role = await _getUserRole(user.uid);
      return UserModel.fromFirebaseUser(user, role: role);
    } catch (e) {
      throw AppException.from(e);
    }
  }

  Future<void> _ensureUserProfile(User user) async {
    final reference = _firestore.collection(_usersCollection).doc(user.uid);
    final snapshot = await reference.get();
    final profile = {
      'displayName': user.displayName?.trim() ?? '',
      'email': user.email?.trim() ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (snapshot.exists) {
      await reference.set({
        ...profile,
        'permissions': FieldValue.delete(),
      }, SetOptions(merge: true));
      return;
    }

    await reference.set({
      ...profile,
      _roleField: AuthRole.patient.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<AuthRole> _getUserRole(String uid) async {
    final snapshot = await _firestore
        .collection(_usersCollection)
        .doc(uid)
        .get();
    final role = snapshot.data()?[_roleField] as String?;
    return AuthRole.values.asNameMap()[role] ?? AuthRole.patient;
  }
}
