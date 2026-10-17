import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/features/common/appointment_details/data/repositories/appointment_details_repository.dart';
import 'package:doctor_hunt/apps/features/common/appointment_details/presentation/controller/cubit/appointment_details_cubit.dart';

class _FakeRepository implements AppointmentDetailsRepository {
  final updates = StreamController<AppointmentModel?>.broadcast();
  Object? actionError;
  CancelledBy? cancelledBy;
  String? completedId;

  @override
  Stream<AppointmentModel?> watchAppointment(String appointmentId) =>
      updates.stream;

  @override
  Future<String?> fetchSpecialtyName(String? specialtyId) async => null;

  @override
  Stream<ClinicModel?> watchClinic() => const Stream.empty();

  @override
  Future<void> cancel(AppointmentModel appointment, CancelledBy by) async {
    if (actionError != null) throw actionError!;
    cancelledBy = by;
  }

  @override
  Future<void> markCompleted(String appointmentId) async {
    if (actionError != null) throw actionError!;
    completedId = appointmentId;
  }
}

AppointmentModel _appointment({bool isReviewed = false}) => AppointmentModel(
  id: 'a1',
  patientId: 'p1',
  patientName: 'Jane',
  patientEmail: '',
  patientPhone: '',
  doctorId: 'd1',
  doctorNameAr: '',
  doctorNameEn: 'Dr. House',
  startAt: DateTime(2026, 9, 1, 10),
  slotId: 'd1_202609011000',
  status: AppointmentStatus.completed,
  isReviewed: isReviewed,
);

void main() {
  test('follows live updates of the appointment', () async {
    final repo = _FakeRepository();
    final cubit = AppointmentDetailsCubit(
      repository: repo,
      appointment: _appointment(),
    );
    await cubit.init();

    repo.updates.add(_appointment(isReviewed: true));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.appointment.isReviewed, isTrue);
    await cubit.close();
  });

  test('cancel goes cancelling then cancelled', () async {
    final repo = _FakeRepository();
    final cubit = AppointmentDetailsCubit(
      repository: repo,
      appointment: _appointment(),
    );
    final actions = <AppointmentActionStatus>[];
    final sub = cubit.stream.listen((state) => actions.add(state.action));

    await cubit.cancel(CancelledBy.admin);
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(actions, [
      AppointmentActionStatus.cancelling,
      AppointmentActionStatus.cancelled,
    ]);
    expect(repo.cancelledBy, CancelledBy.admin);
    await cubit.close();
  });

  test('a failed action keeps the error code', () async {
    final repo = _FakeRepository()
      ..actionError = const AppException(AppErrorCode.service);
    final cubit = AppointmentDetailsCubit(
      repository: repo,
      appointment: _appointment(),
    );

    await cubit.markCompleted();

    expect(cubit.state.action, AppointmentActionStatus.failed);
    expect(cubit.state.error, AppErrorCode.service);
    expect(cubit.state.isBusy, isFalse);
    await cubit.close();
  });
}
