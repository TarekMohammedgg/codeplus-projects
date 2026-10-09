import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';
import 'package:doctor_hunt/apps/features/admin/doctors/data/repositories/admin_doctors_repository.dart';
import 'package:doctor_hunt/apps/features/admin/create_doctor/data/repositories/create_doctor_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/models/review_model.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/models/booking_draft.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/data/repositories/doctor_details_repository.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/data/repositories/favorites_repository.dart';
import 'package:doctor_hunt/apps/features/patient/find_doctors/data/repositories/doctor_repository.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/models/home_data.dart';
import 'package:doctor_hunt/apps/features/patient/home/data/repositories/home_repository.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/repositories/booking_repository.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/data/repositories/patient_appointments_repository.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/repositories/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeSharedPreferences extends Fake implements SharedPreferences {
  FakeSharedPreferences([Map<String, Object>? values])
    : _values = values != null
          ? Map<String, Object>.from(values)
          : <String, Object>{};

  final Map<String, Object> _values;

  @override
  bool? getBool(String key) => _values[key] as bool?;

  @override
  Future<bool> setBool(String key, bool value) async {
    _values[key] = value;
    return true;
  }
}

class FakeUser extends Fake implements User {
  FakeUser({
    this.uid = 'test_uid',
    this.email = 'test@example.com',
    this.displayName = 'Test User',
    this.photoURL,
    this.providerData = const [],
  });

  @override
  final String uid;

  @override
  final String? email;

  @override
  final String? displayName;

  @override
  final String? photoURL;

  @override
  final List<UserInfo> providerData;
}

class FakeFirebaseAuth extends Fake implements FirebaseAuth {
  FakeFirebaseAuth({User? mockUser, User? user}) : mockUser = mockUser ?? user;

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
    this.changePasswordError,
  }) : _currentUser = currentUser ?? auth?.currentUser;

  final bool shouldFail;
  final FirebaseAuth? auth;
  final bool isAdmin;
  final String? changePasswordError;
  bool changePasswordCalled = false;
  String? lastCurrentPassword;
  String? lastNewPassword;
  User? _currentUser;

  @override
  User? get currentUser => auth != null ? auth!.currentUser : _currentUser;

  @override
  bool get hasPasswordProvider =>
      currentUser?.providerData.any(
        (p) => p.providerId == EmailAuthProvider.PROVIDER_ID,
      ) ??
      false;

  @override
  Future<void> updateDisplayNameAndPhoto(String name, String? photoUrl) async {
    _throwIfNeeded();
  }

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
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (changePasswordError != null) {
      throw AppException(message: changePasswordError!);
    }
    _throwIfNeeded();
    changePasswordCalled = true;
    lastCurrentPassword = currentPassword;
    lastNewPassword = newPassword;
  }

  @override
  Future<void> signOut() async {
    _throwIfNeeded();
    _currentUser = null;
    await auth?.signOut();
  }
}

class FakeDoctorRepository implements DoctorRepository {
  FakeDoctorRepository({
    this.doctors = const [],
    this.specialties = const [],
    this.error,
  });

  List<DoctorModel> doctors;
  List<SpecialtyModel> specialties;
  Object? error;

  @override
  Future<List<DoctorModel>> fetchDoctors() async {
    if (error != null) throw error!;
    return doctors;
  }

  @override
  Future<List<SpecialtyModel>> fetchSpecialties() async {
    if (error != null) throw error!;
    return specialties;
  }
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
  FakeAdminDoctorsRepository({
    this.doctors = const [],
    this.specialties = const [],
  });

  final List<DoctorModel> doctors;
  final List<SpecialtyModel> specialties;
  final activeChanges = <(String id, bool isActive)>[];

  @override
  Stream<List<DoctorModel>> streamDoctors() => Stream.value(doctors);

  @override
  Future<List<SpecialtyModel>> fetchSpecialties() async => specialties;

  @override
  Future<void> setActive(String id, bool isActive) async {
    activeChanges.add((id, isActive));
  }
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
    required double consultationFee,
    String? imageUrl,
  }) async {}

  @override
  Future<void> updateDoctor({
    required String id,
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    required double consultationFee,
    String? imageUrl,
  }) async {}
}

/// Drive auth and favorites by adding to [userIds] / [favoriteIds].
class FakeFavoritesRepository implements FavoritesRepository {
  FakeFavoritesRepository({
    this.setFavoriteError,
    this.initialUserId,
    this.initialFavorites,
  });

  final userIds = StreamController<String?>.broadcast();
  final favoriteIds = StreamController<Set<String>>.broadcast();
  final watchedUserIds = <String>[];
  final writes = <(String userId, String doctorId, bool isFavorite)>[];
  Object? setFavoriteError;
  String? initialUserId;
  Set<String>? initialFavorites;

  @override
  Stream<String?> userIdChanges() {
    if (initialUserId != null) {
      return Stream.value(initialUserId);
    }
    return userIds.stream;
  }

  @override
  Stream<Set<String>> watchFavoriteIds(String userId) {
    watchedUserIds.add(userId);
    if (initialFavorites != null) {
      return Stream.value(initialFavorites!);
    }
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
  String? lastUpdatedUid;
  String? lastUpdatedDisplayName;
  String? lastUpdatedPhone;
  DateTime? lastUpdatedDob;
  String? lastUpdatedGender;
  String? lastUpdatedPhotoUrl;

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
  }) async {
    lastUpdatedUid = uid;
    lastUpdatedDisplayName = displayName;
    lastUpdatedPhone = phone;
    lastUpdatedDob = dob;
    lastUpdatedGender = gender;
    lastUpdatedPhotoUrl = photoUrl;
  }

  @override
  Future<void> saveProfile({
    required String uid,
    required String name,
    required String phone,
    DateTime? dob,
    String? gender,
    String? currentPhotoUrl,
    Uint8List? newImageBytes,
    String? newImageName,
  }) {
    return updateProfile(
      uid: uid,
      displayName: name,
      phone: phone,
      dob: dob,
      gender: gender,
      photoUrl: currentPhotoUrl,
    );
  }
}

class FakeBookingRepository implements BookingRepository {
  FakeBookingRepository({this.booked = const [], this.bookError});

  /// Booked slot starts; only those on the requested day are returned.
  final List<DateTime> booked;

  /// Thrown by [book], e.g. `SlotAlreadyBookedException()`.
  Object? bookError;
  final bookedDrafts = <BookingDraft>[];
  final clinic = StreamController<ClinicModel?>.broadcast();

  @override
  Future<Set<DateTime>> fetchBookedStarts(String doctorId, DateTime day) async {
    return booked
        .where(
          (b) => b.year == day.year && b.month == day.month && b.day == day.day,
        )
        .toSet();
  }

  @override
  Stream<ClinicModel?> watchClinic() => clinic.stream;

  @override
  Future<void> book(BookingDraft draft) async {
    if (bookError != null) throw bookError!;
    bookedDrafts.add(draft);
  }
}

class FakeDoctorDetailsRepository implements DoctorDetailsRepository {
  FakeDoctorDetailsRepository({
    this.reviews = const [],
    this.clinic,
    this.error,
  });

  final List<ReviewModel> reviews;
  final ClinicModel? clinic;
  final Object? error;

  @override
  Future<List<ReviewModel>> fetchRecentReviews(String doctorId) async {
    if (error != null) throw error!;
    return reviews;
  }

  @override
  Future<ClinicModel?> fetchClinic() async => clinic;
}

class FakePatientAppointmentsRepository
    implements PatientAppointmentsRepository {
  FakePatientAppointmentsRepository({
    this.appointments = const [],
    this.specialties = const [],
    this.streamError,
    this.cancelError,
  }) {
    _controller = StreamController<List<AppointmentModel>>.broadcast();
  }

  final List<AppointmentModel> appointments;
  final List<SpecialtyModel> specialties;
  final Object? streamError;
  final Object? cancelError;
  late final StreamController<List<AppointmentModel>> _controller;
  final List<AppointmentModel> cancelledAppointments = [];

  void emitAppointments(List<AppointmentModel> appts) {
    if (!_controller.isClosed) _controller.add(appts);
  }

  @override
  Stream<List<AppointmentModel>> watchPatientAppointments(String patientId) {
    if (streamError != null) return Stream.error(streamError!);
    scheduleMicrotask(() {
      if (!_controller.isClosed) _controller.add(appointments);
    });
    return _controller.stream;
  }

  @override
  Future<void> cancelAppointment(AppointmentModel appointment) async {
    if (cancelError != null) throw cancelError!;
    cancelledAppointments.add(appointment);
  }

  @override
  Future<List<SpecialtyModel>> getSpecialties() async => specialties;
}
