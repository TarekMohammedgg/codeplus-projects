import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'package:doctor_hunt/apps/core/services/appointment_service.dart';
import 'package:doctor_hunt/apps/core/services/clinic_service.dart';
import 'package:doctor_hunt/apps/core/services/doctor_service.dart';
import 'package:doctor_hunt/apps/core/services/review_service.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/repositories/admin_doctors_repository.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/service/admin_doctor_service.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/data/repositories/create_doctor_repository.dart';
import 'package:doctor_hunt/apps/core/services/cloudinary_upload_service.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/controller/cubit/create_doctor_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/repositories/doctor_repository.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/service/find_doctors_service.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/repositories/booking_repository.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/data/repositories/doctor_details_repository.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/controller/cubit/doctor_details_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/data/repositories/favorites_repository.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/data/service/favorites_service.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/controller/cubit/booking_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/repositories/home_repository.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/service/home_service.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/repositories/profile_repository.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/service/profile_service.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/profile_cubit.dart';

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
  getIt.registerLazySingleton<AdminDoctorService>(
    () => AdminDoctorService(
      firestore: getIt<FirebaseFirestore>(),
      specialtyService: getIt<SpecialtyService>(),
    ),
  );
  getIt.registerLazySingleton<CloudinaryUploadService>(
    () => CloudinaryUploadService(),
  );
  getIt.registerLazySingleton<ClinicService>(
    () => ClinicService(firestore: getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<AppointmentService>(
    () => AppointmentService(firestore: getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<ReviewService>(
    () => ReviewService(firestore: getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<FavoritesService>(
    () => FavoritesService(firestore: getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<ProfileService>(
    () => ProfileService(firestore: getIt<FirebaseFirestore>()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(authService: getIt<AuthService>()),
  );
  getIt.registerLazySingleton<DoctorRepository>(
    () => FirebaseDoctorRepository(
      findDoctorsService: getIt<FindDoctorsService>(),
      specialtyService: getIt<SpecialtyService>(),
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
      specialtyService: getIt<SpecialtyService>(),
    ),
  );
  getIt.registerLazySingleton<CreateDoctorRepository>(
    () => FirebaseCreateDoctorRepository(
      doctorService: getIt<AdminDoctorService>(),
      specialtyService: getIt<SpecialtyService>(),
      uploadService: getIt<CloudinaryUploadService>(),
    ),
  );
  getIt.registerLazySingleton<BookingRepository>(
    () =>
        BookingRepositoryImpl(appointmentService: getIt<AppointmentService>()),
  );
  getIt.registerLazySingleton<DoctorDetailsRepository>(
    () => FirebaseDoctorDetailsRepository(
      reviewService: getIt<ReviewService>(),
      clinicService: getIt<ClinicService>(),
    ),
  );
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FirebaseFavoritesRepository(
      favoritesService: getIt<FavoritesService>(),
      authService: getIt<AuthService>(),
    ),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => FirebaseProfileRepository(profileService: getIt<ProfileService>()),
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
  getIt.registerFactory<AdminDoctorsCubit>(
    () => AdminDoctorsCubit(repository: getIt<AdminDoctorsRepository>()),
  );
  getIt.registerFactory<CreateDoctorCubit>(
    () => CreateDoctorCubit(repository: getIt<CreateDoctorRepository>()),
  );
  getIt.registerFactory<BookingCubit>(
    () => BookingCubit(repository: getIt<BookingRepository>()),
  );
  getIt.registerFactory<DoctorDetailsCubit>(
    () => DoctorDetailsCubit(repository: getIt<DoctorDetailsRepository>()),
  );
  getIt.registerFactory<FavoritesCubit>(
    () => FavoritesCubit(repository: getIt<FavoritesRepository>()),
  );
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      repository: getIt<ProfileRepository>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );
}
