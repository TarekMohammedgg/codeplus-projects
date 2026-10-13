import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/core/utils/doctor_sort.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/repositories/doctor_repository.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.repository}) : super(const HomeInitial());

  final DoctorRepository repository;

  Future<void> load() async {
    if (state is HomeLoading) return;

    emit(const HomeLoading());
    try {
      final (doctors, specialties) = await (
        repository.fetchDoctors(),
        repository.fetchSpecialties(),
      ).wait;
      if (isClosed) return;
      emit(
        HomeSuccess(
          popularDoctors: sortByPopularity(doctors),
          topRatedDoctors: sortByTopRated(doctors),
          specialties: specialties,
        ),
      );
    } catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      emit(HomeFailure(errorMessage: error.toString()));
    }
  }
}
