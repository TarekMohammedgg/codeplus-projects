import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/repositories/home_repository.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.repository}) : super(const HomeInitial());

  final HomeRepository repository;

  Future<void> load() async {
    if (state is HomeLoading) return;

    emit(const HomeLoading());
    try {
      final data = await repository.fetchHomeData();
      if (isClosed) return;
      emit(HomeSuccess(doctors: data.doctors, specialties: data.specialties));
    } catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      emit(HomeFailure(errorMessage: error.toString()));
    }
  }
}
