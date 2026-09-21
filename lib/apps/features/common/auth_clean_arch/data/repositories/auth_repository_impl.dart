import 'package:doctor_hunt/apps/features/common/auth_clean_arch/data/datasources/auth_remote_data_source.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/entities/user_entity.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/repositories/auth_repository.dart';

/// Pure delegation: the data source already maps Firebase errors to
/// `AppException`, so wrapping again here would change nothing.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required this.remoteDataSource});

  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) => remoteDataSource.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  @override
  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) => remoteDataSource.signUpWithEmailAndPassword(
    email: email,
    password: password,
    name: name,
  );

  @override
  Future<UserEntity?> signInWithGoogle() => remoteDataSource.signInWithGoogle();

  @override
  Future<void> resetPassword({required String email}) =>
      remoteDataSource.sendPasswordResetEmail(email: email);

  @override
  Future<void> signOut() => remoteDataSource.signOut();

  @override
  Future<UserEntity?> getCurrentUser() => remoteDataSource.getCurrentUser();
}
