import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
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

void main() {
  setUp(() async {
    await setupServiceLocator();
  });

  group('Service Locator (GetIt) Registration', () {
    test('registers all core services as lazy singletons', () {
      expect(getIt.isRegistered<AuthService>(), isTrue);
      expect(getIt.isRegistered<DoctorService>(), isTrue);
      expect(getIt.isRegistered<SpecialtyService>(), isTrue);
      expect(getIt.isRegistered<AdminDoctorService>(), isTrue);
      expect(getIt.isRegistered<CloudinaryUploadService>(), isTrue);
    });

    test('registers all repositories', () {
      expect(getIt.isRegistered<AuthRepository>(), isTrue);
      expect(getIt.isRegistered<DoctorRepository>(), isTrue);
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
