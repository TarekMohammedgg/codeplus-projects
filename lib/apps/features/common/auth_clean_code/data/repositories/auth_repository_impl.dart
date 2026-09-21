import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_code/data/datasources/auth_remote_data_source.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_code/domain/entities/user_entity.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_code/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required this.remoteDataSource});

  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      return await remoteDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    try {
      return await remoteDataSource.signInWithGoogle();
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Future<bool> isCurrentUserAdmin() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      if (user == null) return false;
      return await remoteDataSource.isUserAdmin(user.id);
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await remoteDataSource.signOut();
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      return await remoteDataSource.getCurrentUser();
    } catch (e) {
      throw AppException.from(e);
    }
  }
}
