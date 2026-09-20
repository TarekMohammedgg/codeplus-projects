import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/repositories/admin_doctors_repository.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_state.dart';
import 'package:doctor_hunt/apps/features/common/specialty/data/models/specialty_model.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/data/repositories/create_doctor_repository.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/cubit/create_doctor_state.dart';

void main() {
  test('AdminDoctorsCubit emits doctors from the Firestore stream', () async {
    final streamController = StreamController<List<AdminDoctorModel>>();
    final cubit = AdminDoctorsCubit(
      repository: _FakeAdminDoctorsRepository(streamController.stream),
    );
    final states = expectLater(
      cubit.stream,
      emitsInOrder([isA<AdminDoctorsLoading>(), isA<AdminDoctorsSuccess>()]),
    );

    cubit.load();
    streamController.add(const [
      AdminDoctorModel(id: 'doctor-1', name: 'Dr. One', specialty: 'Dentist'),
    ]);
    await states;

    expect((cubit.state as AdminDoctorsSuccess).doctors.single.id, 'doctor-1');
    await cubit.close();
    await streamController.close();
  });

  test('CreateDoctorCubit loads specialties through its repository', () async {
    final cubit = CreateDoctorCubit(
      repository: _FakeCreateDoctorRepository(
        specialties: const [
          SpecialtyModel(id: 'dentistry', nameAr: 'أسنان', nameEn: 'Dentistry'),
        ],
      ),
    );
    final states = expectLater(
      cubit.stream,
      emitsInOrder([isA<CreateDoctorLoading>(), isA<CreateDoctorSuccess>()]),
    );

    await cubit.loadSpecialties();
    await states;

    expect(
      (cubit.state as CreateDoctorSuccess).specialties.single.id,
      'dentistry',
    );
    await cubit.close();
  });
}

class _FakeAdminDoctorsRepository implements AdminDoctorsRepository {
  _FakeAdminDoctorsRepository(this.doctorsStream);

  final Stream<List<AdminDoctorModel>> doctorsStream;

  @override
  Stream<List<AdminDoctorModel>> streamDoctors() => doctorsStream;

  @override
  Future<void> deleteDoctor(String id) async {}
}

class _FakeCreateDoctorRepository implements CreateDoctorRepository {
  _FakeCreateDoctorRepository({required this.specialties});

  final List<SpecialtyModel> specialties;

  @override
  Future<List<SpecialtyModel>> fetchSpecialties() async => specialties;

  @override
  Future<String> uploadImage({
    required Uint8List bytes,
    required String fileName,
  }) async => '';

  @override
  Future<void> createDoctor({
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    String? imageUrl,
  }) async {}

  @override
  Future<void> updateDoctor({
    required String id,
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    String? imageUrl,
  }) async {}
}
