import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/controller/cubit/create_doctor_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/controller/cubit/create_doctor_state.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../helpers/test_fakes.dart';

void main() {
  Future<CreateDoctorCubit> loaded(FakeCreateDoctorRepository repo) async {
    final cubit = CreateDoctorCubit(repository: repo);
    await cubit.loadSpecialties();
    return cubit;
  }

  Future<void> submit(CreateDoctorCubit cubit, {String? doctorId}) =>
      cubit.submit(
        doctorId: doctorId,
        fullNameAr: 'Sara AR',
        fullNameEn: 'Dr. Sara',
        specialtyId: 'dentistry',
        consultationFee: 30,
        imageBytes: Uint8List(1),
        imageName: 'sara.jpg',
      );

  CreateDoctorSuccess current(CreateDoctorCubit cubit) =>
      cubit.state as CreateDoctorSuccess;

  test('uploads the image then creates the doctor', () async {
    final repo = FakeCreateDoctorRepository();
    final cubit = await loaded(repo);
    final steps = <CreateDoctorSubmit>[];
    final sub = cubit.stream.listen(
      (state) => steps.add((state as CreateDoctorSuccess).submit),
    );

    await submit(cubit);
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(steps, [
      CreateDoctorSubmit.uploadingImage,
      CreateDoctorSubmit.saving,
      CreateDoctorSubmit.saved,
    ]);
    expect(repo.createdImageUrl, 'https://img/sara.jpg');
    await cubit.close();
  });

  test('updates instead of creating when a doctor id is given', () async {
    final repo = FakeCreateDoctorRepository();
    final cubit = await loaded(repo);

    await submit(cubit, doctorId: 'doc1');

    expect(repo.updatedDoctorId, 'doc1');
    expect(repo.createdImageUrl, isNull);
    await cubit.close();
  });

  test('upload failure stops before saving', () async {
    final repo = FakeCreateDoctorRepository(uploadError: Exception('x'));
    final cubit = await loaded(repo);

    await submit(cubit);

    expect(current(cubit).submit, CreateDoctorSubmit.failed);
    expect(current(cubit).submitError, tr.uploadImageError);
    expect(repo.createdImageUrl, isNull);
    await cubit.close();
  });

  test('save failure reports the error', () async {
    final cubit = await loaded(
      FakeCreateDoctorRepository(
        saveError: const AppException(message: 'denied'),
      ),
    );

    await submit(cubit);

    expect(current(cubit).submit, CreateDoctorSubmit.failed);
    expect(current(cubit).submitError, 'denied');
    await cubit.close();
  });
}
