import 'package:get_it/get_it.dart';

import 'package:doctor_hunt/apps/core/services/doctor_service.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/repositories/admin_doctors_repository.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/service/admin_doctor_service.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/data/repositories/create_doctor_repository.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/data/service/cloudinary_upload_service.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/repositories/doctor_repository.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/cubit/find_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/presentation/controller/cubit/favourite_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/repositories/home_repository.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/cubit/home_cubit.dart';
import 'package:doctor_hunt/apps/features/common/specialty/data/service/specialty_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Services
  if (!getIt.isRegistered<AuthService>()) {
    getIt.registerLazySingleton<AuthService>(() => AuthService());
  }
  if (!getIt.isRegistered<DoctorService>()) {
    getIt.registerLazySingleton<DoctorService>(() => DoctorService());
  }
  if (!getIt.isRegistered<SpecialtyService>()) {
    getIt.registerLazySingleton<SpecialtyService>(() => SpecialtyService());
  }
  if (!getIt.isRegistered<AdminDoctorService>()) {
    getIt.registerLazySingleton<AdminDoctorService>(() => AdminDoctorService());
  }
  if (!getIt.isRegistered<CloudinaryUploadService>()) {
    getIt.registerLazySingleton<CloudinaryUploadService>(
      () => CloudinaryUploadService(),
    );
  }

  // Repositories
  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => FirebaseAuthRepository(authService: getIt<AuthService>()),
    );
  }
  if (!getIt.isRegistered<DoctorRepository>()) {
    getIt.registerLazySingleton<DoctorRepository>(
      () => FirebaseDoctorRepository(doctorService: getIt<DoctorService>()),
    );
  }
  if (!getIt.isRegistered<HomeRepository>()) {
    getIt.registerLazySingleton<HomeRepository>(
      () => FirebaseHomeRepository(
        doctorService: getIt<DoctorService>(),
        specialtyService: getIt<SpecialtyService>(),
      ),
    );
  }
  if (!getIt.isRegistered<AdminDoctorsRepository>()) {
    getIt.registerLazySingleton<AdminDoctorsRepository>(
      () => FirebaseAdminDoctorsRepository(
        doctorService: getIt<AdminDoctorService>(),
      ),
    );
  }
  if (!getIt.isRegistered<CreateDoctorRepository>()) {
    getIt.registerLazySingleton<CreateDoctorRepository>(
      () => FirebaseCreateDoctorRepository(
        doctorService: getIt<AdminDoctorService>(),
        specialtyService: getIt<SpecialtyService>(),
        uploadService: getIt<CloudinaryUploadService>(),
      ),
    );
  }

  // Cubits (Registered as factories to return a fresh instance on demand)
  if (!getIt.isRegistered<AuthCubit>()) {
    getIt.registerFactory<AuthCubit>(
      () => AuthCubit(repository: getIt<AuthRepository>()),
    );
  }
  if (!getIt.isRegistered<HomeCubit>()) {
    getIt.registerFactory<HomeCubit>(
      () => HomeCubit(repository: getIt<HomeRepository>()),
    );
  }
  if (!getIt.isRegistered<FindDoctorsCubit>()) {
    getIt.registerFactory<FindDoctorsCubit>(
      () => FindDoctorsCubit(repository: getIt<DoctorRepository>()),
    );
  }
  if (!getIt.isRegistered<FavouriteDoctorsCubit>()) {
    getIt.registerFactory<FavouriteDoctorsCubit>(
      () => FavouriteDoctorsCubit(repository: getIt<DoctorRepository>()),
    );
  }
  if (!getIt.isRegistered<AdminDoctorsCubit>()) {
    getIt.registerFactory<AdminDoctorsCubit>(
      () => AdminDoctorsCubit(repository: getIt<AdminDoctorsRepository>()),
    );
  }
  if (!getIt.isRegistered<CreateDoctorCubit>()) {
    getIt.registerFactory<CreateDoctorCubit>(
      () => CreateDoctorCubit(repository: getIt<CreateDoctorRepository>()),
    );
  }
}
