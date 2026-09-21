import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/models/home_data.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/repositories/home_repository.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_state.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';

void main() {
  test('load emits loading then success with repository data', () async {
    final repository = _FakeHomeRepository(
      data: HomeData(
        doctors: [
          const DoctorModel(
            id: 'doctor-1',
            name: 'Dr. One',
            specialty: 'Dentist',
          ),
        ],
        specialties: [
          const SpecialtyModel(
            id: 'dentistry',
            nameAr: 'أسنان',
            nameEn: 'Dentistry',
          ),
        ],
      ),
    );
    final cubit = HomeCubit(repository: repository);
    final stateExpectation = expectLater(
      cubit.stream,
      emitsInOrder([isA<HomeLoading>(), isA<HomeSuccess>()]),
    );

    await cubit.load();
    await stateExpectation;
    final state = cubit.state as HomeSuccess;
    expect(state.doctors.single.id, 'doctor-1');
    expect(state.specialties.single.id, 'dentistry');
    await cubit.close();
  });

  test('load emits failure when the repository throws', () async {
    final cubit = HomeCubit(
      repository: _FakeHomeRepository(error: StateError('load failed')),
    );
    final stateExpectation = expectLater(
      cubit.stream,
      emitsInOrder([isA<HomeLoading>(), isA<HomeFailure>()]),
    );

    await cubit.load();
    await stateExpectation;
    expect((cubit.state as HomeFailure).errorMessage, contains('load failed'));
    await cubit.close();
  });
}

class _FakeHomeRepository implements HomeRepository {
  _FakeHomeRepository({this.data, this.error});

  final HomeData? data;
  final Object? error;

  @override
  Future<HomeData> fetchHomeData() async {
    if (error != null) throw error!;
    return data ?? const HomeData(doctors: [], specialties: []);
  }
}
