import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/models/admin_doctor_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/repositories/admin_doctors_repository.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/data/repositories/create_doctor_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/repositories/doctor_repository.dart';
import 'package:doctor_hunt/apps/features/patient/favourite_doctors/data/repositories/favourite_doctors_repository.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/models/home_data.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/repositories/home_repository.dart';

class FakeFirebaseAuth extends Fake implements FirebaseAuth {
  FakeFirebaseAuth({this.mockUser});

  final User? mockUser;

  @override
  User? get currentUser => mockUser;
}

class FakeFirebaseFirestore extends Fake implements FirebaseFirestore {}

class FakeAuthService extends Fake implements AuthService {
  FakeAuthService({this.user});

  final User? user;

  @override
  User? get currentUser => user;
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.shouldFail = false, this.currentUser});

  final bool shouldFail;

  @override
  final User? currentUser;

  void _throwIfNeeded() {
    if (shouldFail) throw StateError('auth operation failed');
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _throwIfNeeded();
    throw StateError('not used in UI test');
  }

  @override
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    _throwIfNeeded();
    throw StateError('not used in UI test');
  }

  @override
  Future<UserCredential?> signInWithGoogle() async {
    _throwIfNeeded();
    return null;
  }

  @override
  Future<void> resetPassword({required String email}) async {
    _throwIfNeeded();
  }

  @override
  Future<bool> isCurrentUserAdmin() async => false;

  @override
  Future<void> signOut() async {
    _throwIfNeeded();
  }
}

class FakeDoctorRepository implements DoctorRepository {
  FakeDoctorRepository({this.doctors = const []});

  final List<DoctorModel> doctors;

  @override
  Future<List<DoctorModel>> fetchDoctors() async => doctors;
}

class FakeFavouriteDoctorsRepository implements FavouriteDoctorsRepository {
  FakeFavouriteDoctorsRepository({
    this.favouriteDoctors = const [],
    this.featuredDoctors = const [],
  });

  final List<DoctorModel> favouriteDoctors;
  final List<DoctorModel> featuredDoctors;

  @override
  Future<List<DoctorModel>> fetchFavouriteDoctors() async => favouriteDoctors;

  @override
  Future<List<DoctorModel>> fetchFeaturedDoctors() async => featuredDoctors;
}

class FakeHomeRepository implements HomeRepository {
  FakeHomeRepository({this.data, this.error});

  final HomeData? data;
  final Object? error;

  @override
  Future<HomeData> fetchHomeData() async {
    if (error != null) throw error!;
    return data ?? const HomeData(doctors: [], specialties: []);
  }
}

class FakeAdminDoctorsRepository implements AdminDoctorsRepository {
  FakeAdminDoctorsRepository({this.doctors = const []});

  final List<AdminDoctorModel> doctors;

  @override
  Stream<List<AdminDoctorModel>> streamDoctors() => Stream.value(doctors);

  @override
  Future<void> deleteDoctor(String id) async {}
}

class FakeCreateDoctorRepository implements CreateDoctorRepository {
  FakeCreateDoctorRepository({this.specialties = const []});

  final List<SpecialtyModel> specialties;

  @override
  Future<List<SpecialtyModel>> fetchSpecialties() async => specialties;

  @override
  Future<String> uploadImage({
    required Uint8List bytes,
    required String fileName,
  }) async => '';

  @override
  Future<void> createDoctor({
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    String? imageUrl,
  }) async {}

  @override
  Future<void> updateDoctor({
    required String id,
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    String? imageUrl,
  }) async {}
}
