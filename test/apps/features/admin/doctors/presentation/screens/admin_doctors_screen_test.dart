import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/screens/admin_doctors_screen.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../../../../helpers/test_app.dart';
import '../../../../../../helpers/test_fakes.dart';

void main() {
  late FakeAdminDoctorsRepository repository;

  Future<void> pumpScreen(
    WidgetTester tester, {
    List<DoctorModel> doctors = const [
      DoctorModel(
        id: 'dentist',
        name: 'Dr. Sara',
        specialty: 'Dentistry',
        specialtyId: 'dentistry',
      ),
      DoctorModel(
        id: 'cardiologist',
        name: 'Dr. Omar',
        specialty: 'Cardiology',
        specialtyId: 'cardiology',
        isActive: false,
      ),
    ],
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    repository = FakeAdminDoctorsRepository(
      doctors: doctors,
      specialties: const [
        SpecialtyModel(id: 'dentistry', nameAr: 'أسنان', nameEn: 'Dentistry'),
        SpecialtyModel(id: 'cardiology', nameAr: 'قلب', nameEn: 'Cardiology'),
      ],
    );
    await tester.pumpWidget(
      buildTestApp(
        BlocProvider<AdminDoctorsCubit>(
          create: (_) => AdminDoctorsCubit(repository: repository),
          child: const AdminDoctorsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('specialty chip filters the doctor list', (tester) async {
    // arrange
    await pumpScreen(tester);
    expect(find.text('Dr. Omar'), findsOneWidget);

    // act
    await tester.tap(find.widgetWithText(ChoiceChip, 'Dentistry (1)'));
    await tester.pump();

    // assert
    expect(find.text('Dr. Sara'), findsOneWidget);
    expect(find.text('Dr. Omar'), findsNothing);
  });

  testWidgets('deactivate asks for confirmation, then calls setActive', (
    tester,
  ) async {
    // arrange
    final tr = AppLocale.en.buildSync();
    await pumpScreen(tester);
    await tester.tap(find.byIcon(Icons.more_vert_rounded).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(tr.deactivate));
    await tester.pumpAndSettle();
    expect(find.text(tr.deactivateDoctorTitle), findsOneWidget);

    // act
    await tester.tap(find.text(tr.deactivate).last);
    await tester.pumpAndSettle();

    // assert
    expect(repository.activeChanges, [('dentist', false)]);
  });

  testWidgets('an inactive doctor offers Activate and no delete', (
    tester,
  ) async {
    // arrange
    await pumpScreen(tester);

    // act
    await tester.tap(find.byIcon(Icons.more_vert_rounded).last);
    await tester.pumpAndSettle();

    // assert
    expect(find.text(AppLocale.en.buildSync().activate), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline_rounded), findsNothing);
  });

  testWidgets('shows active and total counters with counted chips', (
    tester,
  ) async {
    // arrange
    final tr = AppLocale.en.buildSync();

    // act
    await pumpScreen(tester);

    // assert
    expect(find.text(tr.activeDoctors), findsOneWidget);
    expect(find.text(tr.totalDoctors), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'All (2)'), findsOneWidget);
    expect(find.text(tr.inactiveLabel), findsOneWidget);
  });

  testWidgets('no doctors shows the empty state without chips', (tester) async {
    // arrange
    final tr = AppLocale.en.buildSync();

    // act
    await pumpScreen(tester, doctors: const []);

    // assert
    expect(find.text(tr.noDoctorsFound), findsOneWidget);
    expect(find.text(tr.noDoctorsYet), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNothing);
  });
}
