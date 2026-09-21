import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'package:doctor_hunt/apps/core/services/doctor_service.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/repositories/admin_doctors_repository.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/service/admin_doctor_service.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/data/repositories/create_doctor_repository.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/data/service/cloudinary_upload_service.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/controller/cubit/create_doctor_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_arch/auth_clean_arch.dart'
    as clean_auth;
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/repositories/doctor_repository.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/service/find_doctors_service.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/data/repositories/favourite_doctors_repository.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/data/service/favourite_doctors_service.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/presentation/controller/cubit/favourite_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/repositories/home_repository.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/service/home_service.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_cubit.dart';

final getIt = GetIt.instance;

/// Registers every Firebase dependency, service, repository and Cubit
/// factory used by the app. Called once from `main()` after Firebase is
/// initialized, and from test setup with fakes registered beforehand.
///
/// Every dependency is registered unconditionally: callers own the
/// lifecycle (`getIt.reset()` between test cases) instead of guarding each
/// registration with `isRegistered`.
//CR will tell u in session
void setupServiceLocator() {
  // Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // Services
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(
      auth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );
  getIt.registerLazySingleton<SpecialtyService>(
    () => SpecialtyService(firestore: getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<DoctorService>(
    () => DoctorService(
      firestore: getIt<FirebaseFirestore>(),
      specialtyService: getIt<SpecialtyService>(),
    ),
  );
  getIt.registerLazySingleton<HomeService>(
    () => HomeService(doctorService: getIt<DoctorService>()),
  );
  getIt.registerLazySingleton<FindDoctorsService>(
    () => FindDoctorsService(doctorService: getIt<DoctorService>()),
  );
  getIt.registerLazySingleton<FavouriteDoctorsService>(
    () => FavouriteDoctorsService(doctorService: getIt<DoctorService>()),
  );
  getIt.registerLazySingleton<AdminDoctorService>(
    () => AdminDoctorService(
      firestore: getIt<FirebaseFirestore>(),
      specialtyService: getIt<SpecialtyService>(),
    ),
  );
  getIt.registerLazySingleton<CloudinaryUploadService>(
    () => CloudinaryUploadService(),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(authService: getIt<AuthService>()),
  );
  getIt.registerLazySingleton<DoctorRepository>(
    () => FirebaseDoctorRepository(
      findDoctorsService: getIt<FindDoctorsService>(),
    ),
  );
  getIt.registerLazySingleton<FavouriteDoctorsRepository>(
    () => FirebaseFavouriteDoctorsRepository(
      favouriteDoctorsService: getIt<FavouriteDoctorsService>(),
    ),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => FirebaseHomeRepository(
      homeService: getIt<HomeService>(),
      specialtyService: getIt<SpecialtyService>(),
    ),
  );
  getIt.registerLazySingleton<AdminDoctorsRepository>(
    () => FirebaseAdminDoctorsRepository(
      doctorService: getIt<AdminDoctorService>(),
    ),
  );
  getIt.registerLazySingleton<CreateDoctorRepository>(
    () => FirebaseCreateDoctorRepository(
      doctorService: getIt<AdminDoctorService>(),
      specialtyService: getIt<SpecialtyService>(),
      uploadService: getIt<CloudinaryUploadService>(),
    ),
  );

  // Cubits (registered as factories to return a fresh instance on demand)
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(repository: getIt<AuthRepository>()),
  );
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(repository: getIt<HomeRepository>()),
  );
  getIt.registerFactory<FindDoctorsCubit>(
    () => FindDoctorsCubit(repository: getIt<DoctorRepository>()),
  );
  getIt.registerFactory<FavouriteDoctorsCubit>(
    () =>
        FavouriteDoctorsCubit(repository: getIt<FavouriteDoctorsRepository>()),
  );
  getIt.registerFactory<AdminDoctorsCubit>(
    () => AdminDoctorsCubit(repository: getIt<AdminDoctorsRepository>()),
  );
  getIt.registerFactory<CreateDoctorCubit>(
    () => CreateDoctorCubit(repository: getIt<CreateDoctorRepository>()),
  );

  // Clean Architecture Auth
  getIt.registerLazySingleton<clean_auth.AuthRemoteDataSource>(
    () => clean_auth.AuthRemoteDataSourceImpl(
      auth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );
  getIt.registerLazySingleton<clean_auth.AuthRepository>(
    () => clean_auth.AuthRepositoryImpl(
      remoteDataSource: getIt<clean_auth.AuthRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<clean_auth.SignInWithEmailUseCase>(
    () => clean_auth.SignInWithEmailUseCase(getIt<clean_auth.AuthRepository>()),
  );
  getIt.registerLazySingleton<clean_auth.SignUpWithEmailUseCase>(
    () => clean_auth.SignUpWithEmailUseCase(getIt<clean_auth.AuthRepository>()),
  );
  getIt.registerLazySingleton<clean_auth.SignInWithGoogleUseCase>(
    () => clean_auth.SignInWithGoogleUseCase(getIt<clean_auth.AuthRepository>()),
  );
  getIt.registerLazySingleton<clean_auth.ResetPasswordUseCase>(
    () => clean_auth.ResetPasswordUseCase(getIt<clean_auth.AuthRepository>()),
  );
  getIt.registerLazySingleton<clean_auth.CheckAdminStatusUseCase>(
    () => clean_auth.CheckAdminStatusUseCase(getIt<clean_auth.AuthRepository>()),
  );
  getIt.registerLazySingleton<clean_auth.SignOutUseCase>(
    () => clean_auth.SignOutUseCase(getIt<clean_auth.AuthRepository>()),
  );
  getIt.registerLazySingleton<clean_auth.GetCurrentUserUseCase>(
    () => clean_auth.GetCurrentUserUseCase(getIt<clean_auth.AuthRepository>()),
  );
  getIt.registerFactory<clean_auth.AuthCubit>(
    () => clean_auth.AuthCubit(
      signInWithEmailUseCase: getIt<clean_auth.SignInWithEmailUseCase>(),
      signUpWithEmailUseCase: getIt<clean_auth.SignUpWithEmailUseCase>(),
      signInWithGoogleUseCase: getIt<clean_auth.SignInWithGoogleUseCase>(),
      resetPasswordUseCase: getIt<clean_auth.ResetPasswordUseCase>(),
      checkAdminStatusUseCase: getIt<clean_auth.CheckAdminStatusUseCase>(),
      signOutUseCase: getIt<clean_auth.SignOutUseCase>(),
      getCurrentUserUseCase: getIt<clean_auth.GetCurrentUserUseCase>(),
    ),
  );
}
