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
  var settingsTapped = false;
  var logoutTapped = false;

  Future<void> pumpOpenDrawer(WidgetTester tester) async {
    tappedTab = null;
    settingsTapped = false;
    logoutTapped = false;
    final cubit = ProfileCubit(
      repository: FakeProfileRepository(profile: profile),
      authRepository: FakeAuthRepository(),
    )..init(initialProfile: profile);
    addTearDown(cubit.close);

    await tester.pumpWidget(
      buildTestApp(
        BlocProvider<ProfileCubit>.value(
          value: cubit,
          child: Scaffold(
            key: scaffoldKey,
            drawer: PatientMenuDrawer(
              onTabTap: (index) => tappedTab = index,
              onSettingsTap: () => settingsTapped = true,
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
    // act
    await pumpOpenDrawer(tester);

    // assert
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
    // arrange
    await pumpOpenDrawer(tester);

    // act
    await tester.tap(find.text(tr.myAppointments));
    await tester.pumpAndSettle();

    // assert
    expect(tappedTab, 2);
    expect(scaffoldKey.currentState!.isDrawerOpen, isFalse);
  });

  testWidgets('Settings calls onSettingsTap', (tester) async {
    // arrange
    await pumpOpenDrawer(tester);

    // act
    await tester.tap(find.text(tr.settings));
    await tester.pumpAndSettle();

    // assert
    expect(settingsTapped, isTrue);
  });

  testWidgets('Logout calls onLogoutTap', (tester) async {
    // arrange
    await pumpOpenDrawer(tester);

    // act
    await tester.tap(find.byKey(const Key('menu_logout_tile')));
    await tester.pumpAndSettle();

    // assert
    expect(logoutTapped, isTrue);
  });
}
