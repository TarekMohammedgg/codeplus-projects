import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
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
import 'package:doctor_hunt/apps/features/admin/availability/data/repositories/doctor_availability_repository.dart';
import 'package:doctor_hunt/apps/features/admin/availability/presentation/controller/cubit/doctor_availability_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/profile/data/repositories/admin_profile_repository.dart';
import 'package:doctor_hunt/apps/features/admin/profile/presentation/controller/cubit/admin_profile_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/data/repositories/admin_appointments_repository.dart';
import 'package:doctor_hunt/apps/features/admin/appointments/presentation/controller/cubit/admin_appointments_cubit.dart';
import 'package:doctor_hunt/apps/core/services/cloudinary_upload_service.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/controller/cubit/create_doctor_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/appointment_details/data/repositories/appointment_details_repository.dart';
import 'package:doctor_hunt/apps/features/common/appointment_details/presentation/controller/cubit/appointment_details_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/doctor_details/presentation/controller/cubit/admin_doctor_details_cubit.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/repositories/doctor_repository.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/repositories/booking_repository.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/data/repositories/doctor_details_repository.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/controller/cubit/doctor_details_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/data/repositories/favorites_repository.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/data/service/favorites_service.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/presentation/controller/cubit/booking_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/data/repositories/patient_appointments_repository.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/presentation/controller/cubit/patient_appointments_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/repositories/profile_repository.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/service/profile_service.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/change_password_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/profile_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/rate_doctor/data/repositories/rate_doctor_repository.dart';
import 'package:doctor_hunt/apps/features/patient/rate_doctor/presentation/cubit/rate_doctor_cubit.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctor_hunt/apps/core/services/app_preferences_service.dart';

final getIt = GetIt.instance;

//CR will tell u in session
void setupServiceLocator({required SharedPreferences preferences}) {
  getIt.registerSingleton<SharedPreferences>(preferences);
  getIt.registerLazySingleton<AppPreferencesService>(
    () => AppPreferencesService(preferences: getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<Dio>(Dio.new);

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
  getIt.registerLazySingleton<AdminDoctorService>(
    () => AdminDoctorService(doctorService: getIt<DoctorService>()),
  );

  getIt.registerLazySingleton<CloudinaryUploadService>(
    () => CloudinaryUploadService(dio: getIt<Dio>()),
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

  getIt.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(authService: getIt<AuthService>()),
  );
  getIt.registerLazySingleton<DoctorRepository>(
    () => FirebaseDoctorRepository(
      doctorService: getIt<DoctorService>(),
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
    () => BookingRepositoryImpl(
      appointmentService: getIt<AppointmentService>(),
      clinicService: getIt<ClinicService>(),
      authService: getIt<AuthService>(),
      profileService: getIt<ProfileService>(),
    ),
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
    () => FirebaseProfileRepository(
      profileService: getIt<ProfileService>(),
      uploadService: getIt<CloudinaryUploadService>(),
      authService: getIt<AuthService>(),
    ),
  );
  getIt.registerLazySingleton<PatientAppointmentsRepository>(
    () => PatientAppointmentsRepositoryImpl(
      appointmentService: getIt<AppointmentService>(),
      specialtyService: getIt<SpecialtyService>(),
      authService: getIt<AuthService>(),
    ),
  );
  getIt.registerLazySingleton<RateDoctorRepository>(
    () => RateDoctorRepositoryImpl(
      reviewService: getIt<ReviewService>(),
      specialtyService: getIt<SpecialtyService>(),
    ),
  );
  getIt.registerLazySingleton<DoctorAvailabilityRepository>(
    () => DoctorAvailabilityRepositoryImpl(
      doctorService: getIt<AdminDoctorService>(),
    ),
  );
  getIt.registerLazySingleton<AdminProfileRepository>(
    () => AdminProfileRepositoryImpl(
      authService: getIt<AuthService>(),
      profileService: getIt<ProfileService>(),
      clinicService: getIt<ClinicService>(),
      uploadService: getIt<CloudinaryUploadService>(),
    ),
  );
  getIt.registerLazySingleton<AdminAppointmentsRepository>(
    () => AdminAppointmentsRepositoryImpl(
      appointmentService: getIt<AppointmentService>(),
      specialtyService: getIt<SpecialtyService>(),
      profileService: getIt<ProfileService>(),
    ),
  );
  getIt.registerLazySingleton<AppointmentDetailsRepository>(
    () => AppointmentDetailsRepositoryImpl(
      appointmentService: getIt<AppointmentService>(),
      clinicService: getIt<ClinicService>(),
      specialtyService: getIt<SpecialtyService>(),
    ),
  );

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(repository: getIt<AuthRepository>()),
  );
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(repository: getIt<DoctorRepository>()),
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
  getIt.registerFactory<ChangePasswordCubit>(
    () => ChangePasswordCubit(repository: getIt<AuthRepository>()),
  );
  getIt.registerFactory<PatientAppointmentsCubit>(
    () => PatientAppointmentsCubit(
      repository: getIt<PatientAppointmentsRepository>(),
    ),
  );
  getIt.registerFactory<RateDoctorCubit>(
    () => RateDoctorCubit(repository: getIt<RateDoctorRepository>()),
  );
  getIt
      .registerFactoryParam<DoctorAvailabilityCubit, DoctorAvailability?, void>(
        (availability, _) => DoctorAvailabilityCubit(
          repository: getIt<DoctorAvailabilityRepository>(),
          initialAvailability: availability,
        ),
      );
  getIt.registerFactoryParam<AdminDoctorDetailsCubit, DoctorModel, void>(
    (doctor, _) => AdminDoctorDetailsCubit(
      initialDoctor: doctor,
      repository: getIt<AdminDoctorsRepository>(),
    ),
  );
  getIt.registerFactory<AppointmentDetailsCubit>(
    () => AppointmentDetailsCubit(
      repository: getIt<AppointmentDetailsRepository>(),
    ),
  );
  getIt.registerFactory<AdminProfileCubit>(
    () => AdminProfileCubit(repository: getIt<AdminProfileRepository>()),
  );
  getIt.registerFactory<AdminAppointmentsCubit>(
    () => AdminAppointmentsCubit(
      repository: getIt<AdminAppointmentsRepository>(),
    ),
  );
}
