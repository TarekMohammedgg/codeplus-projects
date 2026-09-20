import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_code/data/datasources/auth_remote_data_source.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_code/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? _safeAuth(),
      _firestore = firestore ?? _safeFirestore();

  final FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;

  static FirebaseAuth? _safeAuth() {
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  static FirebaseFirestore? _safeFirestore() {
    try {
      return FirebaseFirestore.instance;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth!.signInWithEmailAndPassword(
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
      final credential = await _auth!.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user!;
      if (name.trim().isNotEmpty) {
        await user.updateDisplayName(name.trim());
        await user.reload();
      }
      await _ensureUserProfile(user);
      return UserModel.fromFirebaseUser(user, role: 'patient');
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

      final result = await _auth!.signInWithCredential(credential);
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
      await _auth!.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuth(e);
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Future<bool> isUserAdmin(String uid) async {
    try {
      final role = await _getUserRole(uid);
      return role == 'admin';
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        if (_auth != null) _auth.signOut(),
        GoogleSignIn.instance.signOut(),
      ]);
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _auth?.currentUser;
    if (user == null) return null;
    final role = await _getUserRole(user.uid);
    return UserModel.fromFirebaseUser(user, role: role);
  }

  Future<void> _ensureUserProfile(User user) async {
    if (_firestore == null) return;
    final reference = _firestore.collection('users').doc(user.uid);
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
      'role': 'patient',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String> _getUserRole(String uid) async {
    if (_firestore == null) return 'patient';
    try {
      final snapshot = await _firestore.collection('users').doc(uid).get();
      return (snapshot.data()?['role'] as String?) ?? 'patient';
    } catch (_) {
      return 'patient';
    }
  }
}
