import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
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

void main() {
  setUp(() async {
    await setupServiceLocator();
  });

  group('Service Locator (GetIt) Registration', () {
    test('registers all core and feature services as lazy singletons', () {
      expect(getIt.isRegistered<AuthService>(), isTrue);
      expect(getIt.isRegistered<HomeService>(), isTrue);
      expect(getIt.isRegistered<FindDoctorsService>(), isTrue);
      expect(getIt.isRegistered<FavouriteDoctorsService>(), isTrue);
      expect(getIt.isRegistered<SpecialtyService>(), isTrue);
      expect(getIt.isRegistered<AdminDoctorService>(), isTrue);
      expect(getIt.isRegistered<CloudinaryUploadService>(), isTrue);
    });

    test('registers all repositories', () {
      expect(getIt.isRegistered<AuthRepository>(), isTrue);
      expect(getIt.isRegistered<DoctorRepository>(), isTrue);
      expect(getIt.isRegistered<FavouriteDoctorsRepository>(), isTrue);
      expect(getIt.isRegistered<HomeRepository>(), isTrue);
      expect(getIt.isRegistered<AdminDoctorsRepository>(), isTrue);
      expect(getIt.isRegistered<CreateDoctorRepository>(), isTrue);
    });

    test('registers all cubits as factories', () {
      expect(getIt.isRegistered<AuthCubit>(), isTrue);
      expect(getIt.isRegistered<HomeCubit>(), isTrue);
      expect(getIt.isRegistered<FindDoctorsCubit>(), isTrue);
      expect(getIt.isRegistered<FavouriteDoctorsCubit>(), isTrue);
      expect(getIt.isRegistered<AdminDoctorsCubit>(), isTrue);
      expect(getIt.isRegistered<CreateDoctorCubit>(), isTrue);
    });
  });
}
