import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'package:doctor_hunt/apps/features/admin/doctors/data/repositories/admin_doctors_repository.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/service/admin_doctor_service.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/data/repositories/create_doctor_repository.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/data/service/cloudinary_upload_service.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/controller/cubit/create_doctor_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/repositories/doctor_repository.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/service/find_doctors_service.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/data/repositories/favourite_doctors_repository.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/data/service/favourite_doctors_service.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/presentation/controller/cubit/favourite_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/repositories/home_repository.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/service/home_service.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_cubit.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';

final getIt = GetIt.instance;
//CR will tell u in session
Future<void> setupServiceLocator() async {
  // Firebase
  if (!getIt.isRegistered<FirebaseAuth>()) {
    getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  }
  if (!getIt.isRegistered<FirebaseFirestore>()) {
    getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
  }

  // Services
  if (!getIt.isRegistered<AuthService>()) {
    getIt.registerLazySingleton<AuthService>(
      () => AuthService(
        auth: getIt<FirebaseAuth>(),
        firestore: getIt<FirebaseFirestore>(),
      ),
    );
  }
  if (!getIt.isRegistered<HomeService>()) {
    getIt.registerLazySingleton<HomeService>(
      () => HomeService(firestore: getIt<FirebaseFirestore>()),
    );
  }
  if (!getIt.isRegistered<FindDoctorsService>()) {
    getIt.registerLazySingleton<FindDoctorsService>(
      () => FindDoctorsService(firestore: getIt<FirebaseFirestore>()),
    );
  }
  if (!getIt.isRegistered<FavouriteDoctorsService>()) {
    getIt.registerLazySingleton<FavouriteDoctorsService>(
      () => FavouriteDoctorsService(firestore: getIt<FirebaseFirestore>()),
    );
  }
  if (!getIt.isRegistered<SpecialtyService>()) {
    getIt.registerLazySingleton<SpecialtyService>(() => SpecialtyService());
  }
  if (!getIt.isRegistered<AdminDoctorService>()) {
    getIt.registerLazySingleton<AdminDoctorService>(
      () => AdminDoctorService(firestore: getIt<FirebaseFirestore>()),
    );
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
      () => FirebaseDoctorRepository(
        findDoctorsService: getIt<FindDoctorsService>(),
      ),
    );
  }
  if (!getIt.isRegistered<FavouriteDoctorsRepository>()) {
    getIt.registerLazySingleton<FavouriteDoctorsRepository>(
      () => FirebaseFavouriteDoctorsRepository(
        favouriteDoctorsService: getIt<FavouriteDoctorsService>(),
      ),
    );
  }
  if (!getIt.isRegistered<HomeRepository>()) {
    getIt.registerLazySingleton<HomeRepository>(
      () => FirebaseHomeRepository(
        homeService: getIt<HomeService>(),
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
      () => FavouriteDoctorsCubit(
        repository: getIt<FavouriteDoctorsRepository>(),
      ),
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
