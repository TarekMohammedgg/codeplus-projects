import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/features/doctors/data/models/doctor_detail_args.dart';
import 'package:doctor_hunt/apps/features/doctor_select_time/presentation/screens/doctor_select_time_screen.dart';
import 'package:doctor_hunt/apps/features/doctor_select_time/presentation/widgets/date_selector_list.dart';
import 'package:doctor_hunt/apps/features/doctor_select_time/presentation/widgets/no_slots_available_section.dart';
import 'package:doctor_hunt/apps/features/doctor_select_time/presentation/widgets/thank_you_dialog.dart';
import 'package:doctor_hunt/apps/features/doctor_select_time/presentation/widgets/time_slots_section.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'test_app.dart';

void main() {
  final testDoctor = DoctorDetailArgs(
    id: 'test_doc_1',
    name: 'Dr. Test Specialist',
    specialty: 'Cardiologist',
    rating: 4.8,
    hourlyRate: 35.0,
    isFavorite: true,
  );

  testWidgets(
    'SelectTimeScreen starts on Today (no slots) and shows NoSlotsAvailableSection',
    (WidgetTester tester) async {
      final tr = AppLocale.en.buildSync();
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestApp(SelectTimeScreen(doctor: testDoctor)),
      );

      expect(find.text(tr.selectTime), findsOneWidget);
      expect(find.text('Dr. Test Specialist'), findsOneWidget);
      expect(find.text('Cardiologist'), findsOneWidget);
      expect(find.text('\$35.00/hour'), findsOneWidget);
      expect(find.byType(DateSelectorList), findsOneWidget);
      expect(find.text('Today, 23 Feb'), findsWidgets);
      expect(find.byType(NoSlotsAvailableSection), findsOneWidget);
      expect(find.text(tr.noSlotsAvailable), findsWidgets);
      expect(
        find.text(tr.nextAvailabilityOn(date: 'Wed, 24 Feb')),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'SelectTimeScreen selecting Tomorrow shows slots and tapping confirm displays ThankYouDialog',
    (WidgetTester tester) async {
      final tr = AppLocale.en.buildSync();
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestApp(SelectTimeScreen(doctor: testDoctor)),
      );

      // Tap on Tomorrow, 24 Feb
      await tester.tap(find.text('Tomorrow, 24 Feb'));
      await tester.pumpAndSettle();

      // TimeSlotsSection should be visible with 7 afternoon and 2 evening slots
      expect(find.byType(TimeSlotsSection), findsWidgets);
      expect(
        find.text('${tr.afternoonSlots} ${tr.slotsCount(count: 7)}'),
        findsOneWidget,
      );
      expect(
        find.text('${tr.eveningSlots} ${tr.slotsCount(count: 2)}'),
        findsOneWidget,
      );
      expect(find.textContaining('1:00'), findsOneWidget);
      expect(find.textContaining('2:00'), findsOneWidget);

      // Confirm button should be visible and enabled
      expect(find.text(tr.confirm), findsOneWidget);
      await tester.tap(find.text(tr.confirm));
      await tester.pumpAndSettle();

      // Thank You dialog should be displayed
      expect(find.byType(ThankYouDialog), findsOneWidget);
      expect(find.text(tr.thankYou), findsOneWidget);
      expect(find.text(tr.appointmentSuccessful), findsOneWidget);
      expect(find.text(tr.done), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      // Tap "Edit your appointment" to dismiss the dialog
      await tester.tap(find.text(tr.editYourAppointment));
      await tester.pumpAndSettle();

      expect(find.byType(ThankYouDialog), findsNothing);
    },
  );

  testWidgets(
    'SelectTimeScreen selecting a different slot updates ThankYouDialog details',
    (WidgetTester tester) async {
      final tr = AppLocale.en.buildSync();
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestApp(SelectTimeScreen(doctor: testDoctor)),
      );

      // Select Tomorrow, 24 Feb
      await tester.tap(find.text('Tomorrow, 24 Feb'));
      await tester.pumpAndSettle();

      // Select 2:00 PM slot
      await tester.tap(find.textContaining('2:00'));
      await tester.pumpAndSettle();

      // Tap Confirm
      await tester.tap(find.text(tr.confirm));
      await tester.pumpAndSettle();

      // Check that ThankYouDialog shows 2:00 PM
      expect(find.byType(ThankYouDialog), findsOneWidget);
      expect(
        find.text(
          tr.appointmentBookedWith(
            name: testDoctor.name,
            date: 'Tomorrow, 24 Feb',
            time: '2:00 PM',
          ),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('ThankYouDialog Done button invokes navigation callback', (
    WidgetTester tester,
  ) async {
    final tr = AppLocale.en.buildSync();
    var donePressed = false;
    var editPressed = false;

    await tester.pumpWidget(
      buildTestApp(
        ThankYouDialog(
          doctorName: 'Dr. Specialist',
          dateLabel: 'Tomorrow, 24 Feb',
          timeSlot: '10:00 AM',
          onDone: () => donePressed = true,
          onEdit: () => editPressed = true,
        ),
      ),
    );

    expect(find.text(tr.thankYou), findsOneWidget);
    expect(find.text(tr.appointmentSuccessful), findsOneWidget);
    expect(
      find.text(
        tr.appointmentBookedWith(
          name: 'Dr. Specialist',
          date: 'Tomorrow, 24 Feb',
          time: '10:00 AM',
        ),
      ),
      findsOneWidget,
    );

    await tester.tap(find.text(tr.done));
    await tester.pump();
    expect(donePressed, isTrue);

    await tester.tap(find.text(tr.editYourAppointment));
    await tester.pump();
    expect(editPressed, isTrue);
  });

  testWidgets('SelectTimeScreen shows only the three requested dates', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestApp(SelectTimeScreen(doctor: testDoctor)));

    expect(find.text('Today, 23 Feb'), findsWidgets);
    expect(find.text('Tomorrow, 24 Feb'), findsOneWidget);
    expect(find.text('Thursday, 25 Feb'), findsOneWidget);
    expect(find.text('9 slots available'), findsOneWidget);
    expect(find.text('10 slots available'), findsOneWidget);
    expect(find.text('Fri, 26 Feb'), findsNothing);
  });
}
