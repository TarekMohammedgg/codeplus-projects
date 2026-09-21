import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/features/admin/settings/presentation/screens/admin_settings_screen.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import '../../../helpers/test_app.dart';
import '../../../helpers/test_fakes.dart';

class _FakeUser extends Fake implements User {
  _FakeUser({required this.email});

  @override
  final String? email;
}

Widget _buildTestAdminSettingsScreen({User? user}) {
  return BlocProvider<AuthCubit>(
    create: (_) => AuthCubit(repository: FakeAuthRepository(currentUser: user)),
    child: const AdminSettingsScreen(),
  );
}

void main() {
  testWidgets(
    'AdminSettingsScreen reads the email from the provided AuthCubit, not a manually constructed service',
    (WidgetTester tester) async {
      final tr = AppLocale.en.buildSync();
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestApp(
          _buildTestAdminSettingsScreen(
            user: _FakeUser(email: 'admin@doctorhunt.test'),
          ),
        ),
      );

      expect(find.text('admin@doctorhunt.test'), findsOneWidget);
      expect(find.text(tr.adminRoleTitle), findsOneWidget);
      expect(find.text(tr.logOut), findsOneWidget);
    },
  );

  testWidgets(
    'AdminSettingsScreen renders an empty email when there is no signed-in user',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestApp(_buildTestAdminSettingsScreen()));

      expect(find.text('admin@doctorhunt.test'), findsNothing);
    },
  );

  testWidgets(
    'Tapping log out signs out through the provided AuthCubit and navigates to role selection',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final tr = AppLocale.en.buildSync();
      final router = GoRouter(
        initialLocation: '/admin/settings',
        routes: [
          GoRoute(
            path: '/admin/settings',
            builder: (context, state) => _buildTestAdminSettingsScreen(),
          ),
          GoRoute(
            path: '/role-selection',
            builder: (context, state) => const Scaffold(),
          ),
        ],
      );

      await tester.pumpWidget(buildTestRouterApp(router));

      await tester.tap(find.text(tr.logOut));
      await tester.pumpAndSettle();

      expect(router.state.matchedLocation, '/role-selection');
    },
  );
}
