import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class _FakeFirebaseAuth extends Fake implements FirebaseAuth {}

class _FakeFirebaseFirestore extends Fake implements FirebaseFirestore {}

void main() {
  setUp(() async {
    await getIt.reset();
    await setupServiceLocator();
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('Service Locator (GetIt) Registration', () {
    test('registers Firebase dependencies as lazy singletons', () {
      expect(getIt.isRegistered<FirebaseAuth>(), isTrue);
      expect(getIt.isRegistered<FirebaseFirestore>(), isTrue);
    });

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

  group('Firebase Service Constructor Dependency Injection', () {
    test('AuthService accepts injected FirebaseAuth and FirebaseFirestore', () {
      final fakeAuth = _FakeFirebaseAuth();
      final fakeFirestore = _FakeFirebaseFirestore();
      final service = AuthService(auth: fakeAuth, firestore: fakeFirestore);
      expect(service, isNotNull);
    });

    test('AdminDoctorService accepts injected FirebaseFirestore', () {
      final fakeFirestore = _FakeFirebaseFirestore();
      final service = AdminDoctorService(firestore: fakeFirestore);
      expect(service, isNotNull);
    });

    test('AuthRepository receives injected AuthService', () {
      final fakeAuth = _FakeFirebaseAuth();
      final fakeFirestore = _FakeFirebaseFirestore();
      final service = AuthService(auth: fakeAuth, firestore: fakeFirestore);
      final repo = FirebaseAuthRepository(authService: service);
      expect(repo.authService, same(service));
    });

    test('AdminDoctorsRepository receives injected AdminDoctorService', () {
      final fakeFirestore = _FakeFirebaseFirestore();
      final service = AdminDoctorService(firestore: fakeFirestore);
      final repo = FirebaseAdminDoctorsRepository(doctorService: service);
      expect(repo.doctorService, same(service));
    });
  });
}
