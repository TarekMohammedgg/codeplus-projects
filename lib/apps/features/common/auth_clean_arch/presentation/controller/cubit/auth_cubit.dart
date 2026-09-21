import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/entities/user_entity.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/usecases/check_admin_status_usecase.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/usecases/get_current_user_usecase.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/usecases/reset_password_usecase.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/usecases/sign_out_usecase.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/presentation/controller/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.signInWithEmailUseCase,
    required this.signUpWithEmailUseCase,
    required this.signInWithGoogleUseCase,
    required this.resetPasswordUseCase,
    required this.checkAdminStatusUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(const AuthInitial());

  final SignInWithEmailUseCase signInWithEmailUseCase;
  final SignUpWithEmailUseCase signUpWithEmailUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final CheckAdminStatusUseCase checkAdminStatusUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading(action: AuthAction.signIn));
    try {
      final user = await signInWithEmailUseCase(
        email: email,
        password: password,
      );
      if (isClosed) return;
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
      if (isClosed) return;
      emit(AuthSuccess(action: AuthAction.signUp, user: user));
    } catch (error, stackTrace) {
      _emitFailure(error, stackTrace);
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const AuthLoading(action: AuthAction.googleSignIn));
    try {
      final user = await signInWithGoogleUseCase();
      if (isClosed) return;
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
      if (isClosed) return;
      final isAdmin = await checkAdminStatusUseCase();
      if (isClosed) return;
      if (!isAdmin) {
        await signOutUseCase();
        if (isClosed) return;
        emit(const AuthFailure(code: AuthFailureCode.adminPermissionDenied));
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
      if (isClosed) return;
      emit(const AuthSuccess(action: AuthAction.resetPassword));
    } catch (error, stackTrace) {
      _emitFailure(error, stackTrace);
    }
  }

  Future<void> signOut() async {
    emit(const AuthLoading(action: AuthAction.signOut));
    try {
      await signOutUseCase();
      if (isClosed) return;
      emit(const AuthSuccess(action: AuthAction.signOut));
    } catch (error, stackTrace) {
      _emitFailure(error, stackTrace);
    }
  }

  Future<UserEntity?> getCurrentUser() {
    return getCurrentUserUseCase();
  }

  void _emitFailure(Object error, StackTrace stackTrace) {
    if (isClosed) return;
    addError(error, stackTrace);
    emit(AuthFailure.withMessage(AppException.from(error).message));
  }
}
