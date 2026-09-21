import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_code/data/datasources/auth_remote_data_source_impl.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_code/data/repositories/auth_repository_impl.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_code/domain/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_code/domain/usecases/check_admin_status_usecase.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_code/domain/usecases/reset_password_usecase.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_code/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_code/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_code/domain/usecases/sign_out_usecase.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_code/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_code/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.signInWithEmailUseCase,
    required this.signUpWithEmailUseCase,
    required this.signInWithGoogleUseCase,
    required this.resetPasswordUseCase,
    required this.checkAdminStatusUseCase,
    required this.signOutUseCase,
  }) : super(const AuthInitial());

  factory AuthCubit.create() {
    final remoteDataSource = AuthRemoteDataSourceImpl();
    final repository = AuthRepositoryImpl(remoteDataSource: remoteDataSource);
    return AuthCubit.fromRepository(repository);
  }

  factory AuthCubit.fromRepository(AuthRepository repository) {
    return AuthCubit(
      signInWithEmailUseCase: SignInWithEmailUseCase(repository),
      signUpWithEmailUseCase: SignUpWithEmailUseCase(repository),
      signInWithGoogleUseCase: SignInWithGoogleUseCase(repository),
      resetPasswordUseCase: ResetPasswordUseCase(repository),
      checkAdminStatusUseCase: CheckAdminStatusUseCase(repository),
      signOutUseCase: SignOutUseCase(repository),
    );
  }

  final SignInWithEmailUseCase signInWithEmailUseCase;
  final SignUpWithEmailUseCase signUpWithEmailUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final CheckAdminStatusUseCase checkAdminStatusUseCase;
  final SignOutUseCase signOutUseCase;

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading(action: AuthAction.signIn));
    try {
      final user = await signInWithEmailUseCase(
        email: email,
        password: password,
      );
      emit(AuthSuccess(action: AuthAction.signIn, user: user));
    } catch (error, stackTrace) {
      _emitFailure(error, stackTrace);
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(const AuthLoading(action: AuthAction.signUp));
    try {
      final user = await signUpWithEmailUseCase(
        email: email,
        password: password,
        name: name,
      );
      emit(AuthSuccess(action: AuthAction.signUp, user: user));
    } catch (error, stackTrace) {
      _emitFailure(error, stackTrace);
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const AuthLoading(action: AuthAction.googleSignIn));
    try {
      final user = await signInWithGoogleUseCase();
      if (user == null) {
        emit(const AuthInitial());
        return;
      }
      emit(AuthSuccess(action: AuthAction.googleSignIn, user: user));
    } catch (error, stackTrace) {
      _emitFailure(error, stackTrace);
    }
  }

  Future<void> signInAsAdmin({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading(action: AuthAction.adminSignIn));
    try {
      final user = await signInWithEmailUseCase(
        email: email,
        password: password,
      );
      final isAdmin = await checkAdminStatusUseCase();
      if (!isAdmin) {
        await signOutUseCase();
        emit(
          const AuthFailure(errorMessage: 'هذا الحساب لا يملك صلاحيات الأدمن.'),
        );
        return;
      }
      emit(AuthSuccess(action: AuthAction.adminSignIn, user: user));
    } catch (error, stackTrace) {
      _emitFailure(error, stackTrace);
    }
  }

  Future<void> resetPassword({required String email}) async {
    emit(const AuthLoading(action: AuthAction.resetPassword));
    try {
      await resetPasswordUseCase(email: email);
      emit(const AuthSuccess(action: AuthAction.resetPassword));
    } catch (error, stackTrace) {
      _emitFailure(error, stackTrace);
    }
  }

  Future<void> signOut() async {
    emit(const AuthLoading(action: AuthAction.signOut));
    try {
      await signOutUseCase();
      emit(const AuthSuccess(action: AuthAction.signOut));
    } catch (error, stackTrace) {
      _emitFailure(error, stackTrace);
    }
  }

  void _emitFailure(Object error, StackTrace stackTrace) {
    addError(error, stackTrace);
    emit(AuthFailure(errorMessage: AppException.from(error).message));
  }
}
