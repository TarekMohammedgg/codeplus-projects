import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/repositories/doctor_repository.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_state.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/data/repositories/favourite_doctors_repository.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/presentation/controller/cubit/favourite_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/presentation/controller/cubit/favourite_doctors_state.dart';

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

  test('FavouriteDoctorsCubit loads both doctor sections', () async {
    final favourite = const DoctorModel(
      id: 'favourite-1',
      name: 'Dr. Favourite',
      specialty: 'Dentist',
    );
    final featured = const DoctorModel(
      id: 'featured-1',
      name: 'Dr. Featured',
      specialty: 'Surgeon',
    );
    final cubit = FavouriteDoctorsCubit(
      repository: _FakeFavouriteDoctorsRepository(
        favouriteDoctors: [favourite],
        featuredDoctors: [featured],
      ),
    );
    final states = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<FavouriteDoctorsLoading>(),
        isA<FavouriteDoctorsSuccess>(),
      ]),
    );

    await cubit.load();
    await states;

    final state = cubit.state as FavouriteDoctorsSuccess;
    expect(state.favouriteDoctors.single.id, 'favourite-1');
    expect(state.featuredDoctors.single.id, 'featured-1');
    await cubit.close();
  });
}

class _FakeDoctorRepository implements DoctorRepository {
  _FakeDoctorRepository({this.doctors = const []});

  final List<DoctorModel> doctors;

  @override
  Future<List<DoctorModel>> fetchDoctors() async => doctors;
}

class _FakeFavouriteDoctorsRepository implements FavouriteDoctorsRepository {
  _FakeFavouriteDoctorsRepository({
    this.favouriteDoctors = const [],
    this.featuredDoctors = const [],
  });

  final List<DoctorModel> favouriteDoctors;
  final List<DoctorModel> featuredDoctors;

  @override
  Future<List<DoctorModel>> fetchFavouriteDoctors() async => favouriteDoctors;

  @override
  Future<List<DoctorModel>> fetchFeaturedDoctors() async => featuredDoctors;
}
