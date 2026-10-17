import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/services/appointment_service.dart';
import 'package:doctor_hunt/apps/core/services/clinic_service.dart';
import 'package:doctor_hunt/apps/core/services/doctor_service.dart';
import 'package:doctor_hunt/apps/core/services/review_service.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/repositories/admin_doctors_repository.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/presentation/controller/cubit/admin_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/data/repositories/create_doctor_repository.dart';
import 'package:doctor_hunt/apps/core/services/cloudinary_upload_service.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/presentation/controller/cubit/create_doctor_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/data/repositories/favorites_repository.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/data/service/favorites_service.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/repositories/doctor_repository.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/presentation/controller/cubit/find_doctors_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/home/presentation/controller/cubit/home_cubit.dart';

import '../../helpers/test_fakes.dart';
import 'package:doctor_hunt/apps/core/services/app_preferences_service.dart';

class _FakeFirebaseAuth extends Fake implements FirebaseAuth {}

class _FakeFirebaseFirestore extends Fake implements FirebaseFirestore {}

void main() {
  setUp(() async {
    await getIt.reset();
    setupServiceLocator(preferences: FakeSharedPreferences());
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('Service Locator (GetIt) Registration', () {
    test('registers Firebase dependencies as lazy singletons', () {
      expect(getIt.isRegistered<FirebaseAuth>(), isTrue);
      expect(getIt.isRegistered<FirebaseFirestore>(), isTrue);
      expect(getIt.isRegistered<Dio>(), isTrue);
    });

    test('registers all core and feature services as lazy singletons', () {
      expect(getIt.isRegistered<AppPreferencesService>(), isTrue);
      expect(getIt.isRegistered<AuthService>(), isTrue);
      expect(getIt.isRegistered<DoctorService>(), isTrue);
      expect(getIt.isRegistered<SpecialtyService>(), isTrue);
      expect(getIt.isRegistered<CloudinaryUploadService>(), isTrue);
      expect(getIt.isRegistered<ClinicService>(), isTrue);
      expect(getIt.isRegistered<AppointmentService>(), isTrue);
      expect(getIt.isRegistered<ReviewService>(), isTrue);
      expect(getIt.isRegistered<FavoritesService>(), isTrue);
    });

    test('registers all repositories', () {
      expect(getIt.isRegistered<AuthRepository>(), isTrue);
      expect(getIt.isRegistered<DoctorRepository>(), isTrue);
      expect(getIt.isRegistered<AdminDoctorsRepository>(), isTrue);
      expect(getIt.isRegistered<CreateDoctorRepository>(), isTrue);
      expect(getIt.isRegistered<FavoritesRepository>(), isTrue);
    });

    test('registers all cubits as factories', () {
      expect(getIt.isRegistered<AuthCubit>(), isTrue);
      expect(getIt.isRegistered<HomeCubit>(), isTrue);
      expect(getIt.isRegistered<FindDoctorsCubit>(), isTrue);
      expect(getIt.isRegistered<AdminDoctorsCubit>(), isTrue);
      expect(getIt.isRegistered<CreateDoctorCubit>(), isTrue);
      expect(getIt.isRegistered<FavoritesCubit>(), isTrue);
    });
  });

  group('Firebase Service Constructor Dependency Injection', () {
    test('AuthService accepts injected FirebaseAuth and FirebaseFirestore', () {
      final fakeAuth = _FakeFirebaseAuth();
      final fakeFirestore = _FakeFirebaseFirestore();
      final service = AuthService(auth: fakeAuth, firestore: fakeFirestore);
      expect(service, isNotNull);
    });

    test('AuthRepository receives injected AuthService', () {
      final fakeAuth = _FakeFirebaseAuth();
      final fakeFirestore = _FakeFirebaseFirestore();
      final service = AuthService(auth: fakeAuth, firestore: fakeFirestore);
      final repo = FirebaseAuthRepository(authService: service);
      expect(repo.authService, same(service));
    });

    test('AdminDoctorsRepository receives injected DoctorService', () {
      final fakeFirestore = _FakeFirebaseFirestore();
      final specialtyService = SpecialtyService(firestore: fakeFirestore);
      final service = DoctorService(
        firestore: fakeFirestore,
        specialtyService: specialtyService,
      );
      final repo = FirebaseAdminDoctorsRepository(
        doctorService: service,
        specialtyService: specialtyService,
      );
      expect(repo.doctorService, same(service));
      expect(repo.specialtyService, same(specialtyService));
    });
  });
}
