import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.repository}) : super(const AuthInitial());

  final AuthRepository repository;

  Future<void> signIn({required String email, required String password}) {
    return _run(
      AuthAction.signIn,
      () => repository.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) {
    return _run(
      AuthAction.signUp,
      () => repository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    const action = AuthAction.googleSignIn;
    emit(const AuthLoading(action: action));
    try {
      final credential = await repository.signInWithGoogle();
      if (credential == null) {
        emit(const AuthInitial());
        return;
      }
      emit(const AuthSuccess(action: action));
    } catch (error, stackTrace) {
      _emitFailure(error, stackTrace);
    }
  }

  Future<void> signInAsAdmin({
    required String email,
    required String password,
  }) async {
    const action = AuthAction.adminSignIn;
    emit(const AuthLoading(action: action));
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
      emit(const AuthSuccess(action: action));
    } catch (error, stackTrace) {
      _emitFailure(error, stackTrace);
    }
  }

  Future<void> resetPassword({required String email}) {
    return _run(
      AuthAction.resetPassword,
      () => repository.resetPassword(email: email),
    );
  }

  Future<void> signOut() {
    return _run(AuthAction.signOut, repository.signOut);
  }

  Future<void> _run(AuthAction action, Future<void> Function() request) async {
    emit(AuthLoading(action: action));
    try {
      await request();
      emit(AuthSuccess(action: action));
    } catch (error, stackTrace) {
      _emitFailure(error, stackTrace);
    }
  }

  void _emitFailure(Object error, StackTrace stackTrace) {
    addError(error, stackTrace);
    emit(AuthFailure(errorMessage: AppException.from(error).message));
  }
}
