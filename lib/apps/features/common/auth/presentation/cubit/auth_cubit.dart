import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.repository}) : super(const AuthInitial());

  final AuthRepository repository;

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading(action: AuthAction.signIn));
    try {
      await repository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(const AuthSuccess(action: AuthAction.signIn));
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
      await repository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
      emit(const AuthSuccess(action: AuthAction.signUp));
    } catch (error, stackTrace) {
      _emitFailure(error, stackTrace);
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const AuthLoading(action: AuthAction.googleSignIn));
    try {
      final credential = await repository.signInWithGoogle();
      if (credential == null) {
        emit(const AuthInitial());
        return;
      }
      emit(const AuthSuccess(action: AuthAction.googleSignIn));
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
      await repository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!await repository.isCurrentUserAdmin()) {
        await repository.signOut();
        emit(
          const AuthFailure(errorMessage: 'هذا الحساب لا يملك صلاحيات الأدمن.'),
        );
        return;
      }
      emit(const AuthSuccess(action: AuthAction.adminSignIn));
    } catch (error, stackTrace) {
      _emitFailure(error, stackTrace);
    }
  }

  Future<void> resetPassword({required String email}) async {
    emit(const AuthLoading(action: AuthAction.resetPassword));
    try {
      await repository.resetPassword(email: email);
      emit(const AuthSuccess(action: AuthAction.resetPassword));
    } catch (error, stackTrace) {
      _emitFailure(error, stackTrace);
    }
  }

  Future<void> signOut() async {
    emit(const AuthLoading(action: AuthAction.signOut));
    try {
      await repository.signOut();
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
