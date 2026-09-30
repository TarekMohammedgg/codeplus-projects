import 'dart:async';
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
import 'package:doctor_hunt/apps/features/patient/favorites/data/repositories/favorites_repository.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/repositories/doctor_repository.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/models/home_data.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/repositories/home_repository.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/repositories/booking_repository.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/repositories/profile_repository.dart';

class FakeFirebaseAuth extends Fake implements FirebaseAuth {
  FakeFirebaseAuth({this.mockUser});

  User? mockUser;
  final StreamController<User?> _controller =
      StreamController<User?>.broadcast();

  @override
  User? get currentUser => mockUser;

  @override
  Stream<User?> authStateChanges() => _controller.stream;

  @override
  Future<void> signOut() async {
    mockUser = null;
    _controller.add(null);
  }
}

class FakeFirebaseFirestore extends Fake implements FirebaseFirestore {}

class FakeAuthService extends Fake implements AuthService {
  FakeAuthService({this.user});

  final User? user;

  @override
  User? get currentUser => user;
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.shouldFail = false,
    User? currentUser,
    this.auth,
    this.isAdmin = false,
  }) : _currentUser = currentUser ?? auth?.currentUser;

  final bool shouldFail;
  final FirebaseAuth? auth;
  final bool isAdmin;
  User? _currentUser;

  @override
  User? get currentUser => auth != null ? auth!.currentUser : _currentUser;

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
  Future<bool> isCurrentUserAdmin() async => isAdmin;

  @override
  Future<void> signOut() async {
    _throwIfNeeded();
    _currentUser = null;
    await auth?.signOut();
  }
}

class FakeDoctorRepository implements DoctorRepository {
  FakeDoctorRepository({this.doctors = const []});

  final List<DoctorModel> doctors;

  @override
  Future<List<DoctorModel>> fetchDoctors() async => doctors;
}

class FakeHomeRepository implements HomeRepository {
  FakeHomeRepository({this.data, this.error});

  final HomeData? data;
  final Object? error;

  @override
  Future<HomeData> fetchHomeData() async {
    if (error != null) throw error!;
    return data ??
        const HomeData(
          popularDoctors: [],
          topRatedDoctors: [],
          specialties: [],
        );
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

/// Drive auth and favorites by adding to [userIds] / [favoriteIds].
class FakeFavoritesRepository implements FavoritesRepository {
  FakeFavoritesRepository({this.setFavoriteError});

  final userIds = StreamController<String?>.broadcast();
  final favoriteIds = StreamController<Set<String>>.broadcast();
  final watchedUserIds = <String>[];
  final writes = <(String userId, String doctorId, bool isFavorite)>[];
  Object? setFavoriteError;

  @override
  Stream<String?> userIdChanges() => userIds.stream;

  @override
  Stream<Set<String>> watchFavoriteIds(String userId) {
    watchedUserIds.add(userId);
    return favoriteIds.stream;
  }

  @override
  Future<void> setFavorite({
    required String userId,
    required String doctorId,
    required bool isFavorite,
  }) async {
    if (setFavoriteError != null) throw setFavoriteError!;
    writes.add((userId, doctorId, isFavorite));
  }
}

class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository({this.profile});

  final UserProfileModel? profile;

  @override
  Stream<UserProfileModel> streamProfile(String uid) {
    if (profile != null) return Stream.value(profile!);
    return const Stream.empty();
  }

  @override
  Future<void> updateProfile({
    required String uid,
    String? displayName,
    String? phone,
    DateTime? dob,
    String? gender,
    String? photoUrl,
    String? language,
    bool? notificationsEnabled,
  }) async {}
}

class FakeBookingRepository implements BookingRepository {
  FakeBookingRepository({this.bookedStarts = const {}});

  final Set<DateTime> bookedStarts;

  @override
  Future<Set<DateTime>> fetchBookedStarts(String doctorId, DateTime day) async {
    return bookedStarts;
  }
}
