import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/models/review_model.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/controller/cubit/doctor_details_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/controller/cubit/doctor_details_state.dart';

import '../../../helpers/test_fakes.dart';

void main() {
  test('load emits loading then success with reviews and clinic', () async {
    const review = ReviewModel(
      appointmentId: 'appt-1',
      patientId: 'patient-1',
      patientName: 'Mona',
      doctorId: 'doc-1',
      rating: 5,
    );
    const clinic = ClinicModel(addressAr: 'القاهرة', addressEn: 'Cairo');
    final cubit = DoctorDetailsCubit(
      repository: FakeDoctorDetailsRepository(
        reviews: const [review],
        clinic: clinic,
      ),
    );
    final states = expectLater(
      cubit.stream,
      emitsInOrder([isA<DoctorDetailsLoading>(), isA<DoctorDetailsSuccess>()]),
    );

    await cubit.load('doc-1');

    await states;
    final state = cubit.state as DoctorDetailsSuccess;
    expect(state.reviews.single.patientName, 'Mona');
    expect(state.clinic, same(clinic));
    await cubit.close();
  });

  test('load emits failure when the repository throws', () async {
    final cubit = DoctorDetailsCubit(
      repository: FakeDoctorDetailsRepository(error: StateError('offline')),
    );

    await cubit.load('doc-1');

    expect(cubit.state, isA<DoctorDetailsFailure>());
    await cubit.close();
  });

  test('clinic changes made by the admin reach the open screen', () async {
    // arrange
    final updates = StreamController<ClinicModel?>();
    final cubit = DoctorDetailsCubit(
      repository: FakeDoctorDetailsRepository(clinicUpdates: updates.stream),
    );
    await cubit.load('doc-1');

    // act
    updates.add(const ClinicModel(addressAr: 'قديم', addressEn: 'Old street'));
    await Future<void>.delayed(Duration.zero);
    updates.add(const ClinicModel(addressAr: 'جديد', addressEn: 'New street'));
    await Future<void>.delayed(Duration.zero);

    // assert
    final state = cubit.state as DoctorDetailsSuccess;
    expect(state.clinic?.addressEn, 'New street');
    await cubit.close();
    await updates.close();
  });
}
