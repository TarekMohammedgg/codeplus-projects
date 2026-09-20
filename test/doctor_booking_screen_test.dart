import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/screens/doctor_booking_screen.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/date_selector_list.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/no_slots_available_section.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/thank_you_dialog.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/widgets/time_slots_section.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'test_app.dart';

void main() {
  final testDoctor = DoctorModel(
    id: 'test_doc_1',
    name: 'Dr. Test Specialist',
    specialty: 'Cardiologist',
    rating: 4.8,
    hourlyRate: 35.0,
    isFavorite: true,
  );

  testWidgets(
    'DoctorBookingScreen starts on Today (no slots) and shows NoSlotsAvailableSection',
    (WidgetTester tester) async {
      final tr = AppLocale.en.buildSync();
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestApp(DoctorBookingScreen(doctor: testDoctor)),
      );

      expect(find.text(tr.selectTime), findsOneWidget);
      expect(find.text('Dr. Test Specialist'), findsOneWidget);
      expect(find.text('Cardiologist'), findsOneWidget);
      expect(find.text('\$35.00/hour'), findsOneWidget);
      expect(find.byType(DateSelectorList), findsOneWidget);
      expect(find.text(tr.dateOptionToday), findsWidgets);
      expect(find.byType(NoSlotsAvailableSection), findsOneWidget);
      expect(find.text(tr.noSlotsAvailable), findsWidgets);
      expect(
        find.text(tr.nextAvailabilityOn(date: tr.dateOptionTomorrow)),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'DoctorBookingScreen selecting Tomorrow shows slots and tapping confirm displays ThankYouDialog',
    (WidgetTester tester) async {
      final tr = AppLocale.en.buildSync();
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestApp(DoctorBookingScreen(doctor: testDoctor)),
      );

      // Tap on tomorrow.
      await tester.tap(find.text(tr.dateOptionTomorrow));
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
    'DoctorBookingScreen selecting a different slot updates ThankYouDialog details',
    (WidgetTester tester) async {
      final tr = AppLocale.en.buildSync();
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestApp(DoctorBookingScreen(doctor: testDoctor)),
      );

      // Select tomorrow.
      await tester.tap(find.text(tr.dateOptionTomorrow));
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
            date: tr.dateOptionTomorrow,
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

  testWidgets('DoctorBookingScreen shows only the three requested dates', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      buildTestApp(DoctorBookingScreen(doctor: testDoctor)),
    );

    final tr = AppLocale.en.buildSync();
    expect(find.text(tr.dateOptionToday), findsWidgets);
    expect(find.text(tr.dateOptionTomorrow), findsOneWidget);
    expect(find.text(tr.dateOptionThu), findsOneWidget);
    expect(find.text(tr.slotsAvailable(count: 9)), findsOneWidget);
    expect(find.text(tr.slotsAvailable(count: 10)), findsOneWidget);
    expect(find.text(tr.dateOptionFri), findsNothing);
  });
}
