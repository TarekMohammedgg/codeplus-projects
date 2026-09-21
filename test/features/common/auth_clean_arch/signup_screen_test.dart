import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/auth_clean_arch.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import '../../../helpers/test_app.dart';

void main() {
  testWidgets(
    'clean_arch SignupScreen renders Google social signup button properly',
    (WidgetTester tester) async {
      final tr = AppLocale.en.buildSync();
      final repository = _FakeAuthRepository();
      final cubit = AuthCubit(
        signInWithEmailUseCase: SignInWithEmailUseCase(repository),
        signUpWithEmailUseCase: SignUpWithEmailUseCase(repository),
        signInWithGoogleUseCase: SignInWithGoogleUseCase(repository),
        resetPasswordUseCase: ResetPasswordUseCase(repository),
        signInAsAdminUseCase: SignInAsAdminUseCase(repository),
        signOutUseCase: SignOutUseCase(repository),
        getCurrentUserUseCase: GetCurrentUserUseCase(repository),
      );

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<AuthCubit>.value(
            value: cubit,
            child: const SignupScreen(),
          ),
        ),
      );

      expect(find.text(tr.createYourAccount), findsOneWidget);
      expect(find.text(tr.google), findsOneWidget);
      expect(find.text(tr.fullNameHint), findsOneWidget);
      expect(find.text(tr.emailHint), findsOneWidget);
      expect(find.text(tr.passwordHint), findsOneWidget);
      expect(find.text(tr.createAccount), findsOneWidget);

      await cubit.close();
    },
  );
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return UserEntity(id: '1', email: email, displayName: 'Test');
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    return UserEntity(id: '1', email: email, displayName: name);
  }

  @override
  Future<UserEntity?> signInWithGoogle() async => null;

  @override
  Future<void> resetPassword({required String email}) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<UserEntity?> getCurrentUser() async => null;
}
