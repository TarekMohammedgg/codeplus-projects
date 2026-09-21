import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/screens/signup_screen.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/widgets/auth_buttons.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import '../../../helpers/test_app.dart';
import '../../../helpers/test_fakes.dart';

void main() {
  testWidgets(
    'SignupScreen renders Google social signup button properly and excludes Facebook',
    (WidgetTester tester) async {
      final tr = AppLocale.en.buildSync();

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<AuthCubit>(
            create: (_) => AuthCubit(repository: FakeAuthRepository()),
            child: const SignupScreen(),
          ),
        ),
      );

      expect(find.text(tr.createYourAccount), findsOneWidget);
      expect(find.text(tr.signupSubtitle), findsOneWidget);

      expect(find.text(tr.google), findsOneWidget);
      expect(find.text(tr.facebook), findsNothing);
      expect(find.byType(SocialMark), findsOneWidget);

      expect(find.text(tr.fullNameHint), findsOneWidget);
      expect(find.text(tr.emailAddress), findsOneWidget);
      expect(find.text(tr.passwordHint), findsOneWidget);
      expect(find.text(tr.createAccount), findsOneWidget);
    },
  );
}
