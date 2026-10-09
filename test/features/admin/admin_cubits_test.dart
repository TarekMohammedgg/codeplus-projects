import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/repositories/admin_doctors_repository.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_state.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/data/repositories/create_doctor_repository.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/controller/cubit/create_doctor_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/controller/cubit/create_doctor_state.dart';
import 'package:doctor_hunt/apps/features/admin/doctor_details/presentation/controller/cubit/admin_doctor_details_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/service/admin_doctor_service.dart';

void main() {
  test('AdminDoctorsCubit emits doctors from the Firestore stream', () async {
    final streamController = StreamController<List<DoctorModel>>();
    final cubit = AdminDoctorsCubit(
      repository: _FakeAdminDoctorsRepository(streamController.stream),
    );
    final states = expectLater(
      cubit.stream,
      emitsInOrder([isA<AdminDoctorsLoading>(), isA<AdminDoctorsSuccess>()]),
    );

    await cubit.load();
    streamController.add(const [
      DoctorModel(id: 'doctor-1', name: 'Dr. One', specialty: 'Dentist'),
    ]);
    await states;

    final state = cubit.state as AdminDoctorsSuccess;
    expect(state.doctors.single.id, 'doctor-1');
    expect(state.specialties.single.id, 'dentistry');
    await cubit.close();
    await streamController.close();
  });

  test(
    'AdminDoctorsCubit.setActive deactivates through the repository',
    () async {
      final repository = _FakeAdminDoctorsRepository(const Stream.empty());
      final cubit = AdminDoctorsCubit(repository: repository);

      await cubit.setActive('doctor-1', false);

      expect(repository.activeChanges, [('doctor-1', false)]);
      await cubit.close();
    },
  );

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

  test(
    'AdminDoctorDetailsCubit streams updates and toggles active state',
    () async {
      final streamController = StreamController<DoctorModel?>();
      final service = _FakeAdminDoctorService(streamController.stream);
      const initialDoctor = DoctorModel(
        id: 'doc-1',
        name: 'Dr. Gregory House',
        specialty: 'Diagnostics',
        isActive: true,
        consultationFee: 100,
      );

      final cubit = AdminDoctorDetailsCubit(
        initialDoctor: initialDoctor,
        doctorService: service,
      );

      expect(cubit.state.doctor.id, 'doc-1');
      expect(cubit.state.doctor.name, 'Dr. Gregory House');

      final updateDoctor = initialDoctor.copyWith(consultationFee: 150);
      streamController.add(updateDoctor);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(cubit.state.doctor.consultationFee, 150);

      await cubit.toggleActive(false);
      expect(service.activeChanges, [('doc-1', false)]);
      expect(cubit.state.doctor.isActive, false);

      await cubit.close();
      await streamController.close();
    },
  );
}

class _FakeAdminDoctorService extends Fake implements AdminDoctorService {
  _FakeAdminDoctorService(this.doctorStream);

  final Stream<DoctorModel?> doctorStream;
  final activeChanges = <(String, bool)>[];

  @override
  Stream<DoctorModel?> streamDoctor(String id) => doctorStream;

  @override
  Future<void> setActive(String id, bool isActive) async {
    activeChanges.add((id, isActive));
  }
}

class _FakeAdminDoctorsRepository implements AdminDoctorsRepository {
  _FakeAdminDoctorsRepository(this.doctorsStream);

  final Stream<List<DoctorModel>> doctorsStream;
  final activeChanges = <(String, bool)>[];

  @override
  Stream<List<DoctorModel>> streamDoctors() => doctorsStream;

  @override
  Future<List<SpecialtyModel>> fetchSpecialties() async => const [
    SpecialtyModel(id: 'dentistry', nameAr: 'أسنان', nameEn: 'Dentistry'),
  ];

  @override
  Future<void> setActive(String id, bool isActive) async {
    activeChanges.add((id, isActive));
  }
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
    required double consultationFee,
    String? imageUrl,
  }) async {}

  @override
  Future<void> updateDoctor({
    required String id,
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    required double consultationFee,
    String? imageUrl,
  }) async {}
}
