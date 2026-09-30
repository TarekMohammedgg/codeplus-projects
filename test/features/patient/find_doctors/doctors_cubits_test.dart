import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/repositories/doctor_repository.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_state.dart';

void main() {
  test('FindDoctorsCubit loads doctors through the repository', () async {
    final doctor = const DoctorModel(
      id: 'doctor-1',
      name: 'Dr. One',
      specialty: 'Dentist',
    );
    final cubit = FindDoctorsCubit(
      repository: _FakeDoctorRepository(doctors: [doctor]),
    );
    final states = expectLater(
      cubit.stream,
      emitsInOrder([isA<FindDoctorsLoading>(), isA<FindDoctorsSuccess>()]),
    );

    await cubit.load();
    await states;

    expect((cubit.state as FindDoctorsSuccess).doctors.single.id, 'doctor-1');
    await cubit.close();
  });
}

class _FakeDoctorRepository implements DoctorRepository {
  _FakeDoctorRepository({this.doctors = const []});

  final List<DoctorModel> doctors;

  @override
  Future<List<DoctorModel>> fetchDoctors() async => doctors;
}
