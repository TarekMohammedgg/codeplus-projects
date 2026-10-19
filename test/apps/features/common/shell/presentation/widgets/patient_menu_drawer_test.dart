import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/features/common/shell/presentation/widgets/patient_menu_drawer.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/profile_cubit.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../../../../helpers/test_app.dart';
import '../../../../../../helpers/test_fakes.dart';

void main() {
  const profile = UserProfileModel(
    uid: 'user-1',
    name: 'Abdullah Mamun',
    phone: '01303-527300',
  );

  final scaffoldKey = GlobalKey<ScaffoldState>();
  int? tappedTab;
  var logoutTapped = false;

  Future<void> pumpOpenDrawer(WidgetTester tester) async {
    tappedTab = null;
    logoutTapped = false;
    final cubit = ProfileCubit(
      repository: FakeProfileRepository(profile: profile),
      authRepository: FakeAuthRepository(),
    )..init(uid: 'patient-1');
    addTearDown(cubit.close);

    await tester.pumpWidget(
      buildTestApp(
        BlocProvider<ProfileCubit>.value(
          value: cubit,
          child: Scaffold(
            key: scaffoldKey,
            drawer: PatientMenuDrawer(
              onTabTap: (index) => tappedTab = index,
              onLogoutTap: () => logoutTapped = true,
            ),
          ),
        ),
      ),
    );
    scaffoldKey.currentState!.openDrawer();
    await tester.pumpAndSettle();
  }

  testWidgets('shows the patient name, phone and menu items', (tester) async {
    await pumpOpenDrawer(tester);

    expect(find.text(profile.name), findsOneWidget);
    expect(find.text(profile.phone), findsOneWidget);
    expect(find.text(tr.tabHome), findsOneWidget);
    expect(find.text(tr.tabFavorites), findsOneWidget);
    expect(find.text(tr.myAppointments), findsOneWidget);
    expect(find.text(tr.settings), findsOneWidget);
    expect(find.text(tr.logOut), findsOneWidget);
  });

  testWidgets('My Appointments closes the drawer and opens tab 2', (
    tester,
  ) async {
    await pumpOpenDrawer(tester);

    await tester.tap(find.text(tr.myAppointments));
    await tester.pumpAndSettle();

    expect(tappedTab, 2);
    expect(scaffoldKey.currentState!.isDrawerOpen, isFalse);
  });

  testWidgets('Settings opens the settings tab (3)', (tester) async {
    await pumpOpenDrawer(tester);

    await tester.tap(find.text(tr.settings));
    await tester.pumpAndSettle();

    expect(tappedTab, 3);
  });

  testWidgets('Logout calls onLogoutTap', (tester) async {
    await pumpOpenDrawer(tester);

    await tester.tap(find.byKey(const Key('menu_logout_tile')));
    await tester.pumpAndSettle();

    expect(logoutTapped, isTrue);
  });
}
