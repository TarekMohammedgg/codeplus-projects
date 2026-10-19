import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/features/admin/profile/data/repositories/admin_profile_repository.dart';
import 'package:doctor_hunt/apps/features/admin/profile/presentation/controller/cubit/admin_profile_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/profile/presentation/controller/cubit/admin_profile_state.dart';
import 'package:doctor_hunt/apps/features/admin/profile/presentation/screens/admin_profile_screen.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../../../../../helpers/test_app.dart';

class _FakeAdminProfileRepository implements AdminProfileRepository {
  UserProfileModel profileToReturn = const UserProfileModel(
    uid: 'admin_123',
    name: 'Admin Boss',
    email: 'admin@hunt.com',
  );
  ClinicModel? clinicToReturn = const ClinicModel(
    addressAr: 'شارع التحرير',
    addressEn: 'Tahrir Street',
    location: LatLng(30.0444, 31.2357),
  );

  bool shouldThrow = false;
  String? lastUpdatedUid;

  @override
  String? currentUid = 'admin_123';
  String? lastUpdatedName;
  String? lastUpdatedEmail;
  String? lastUpdatedPhotoUrl;
  String? lastUpdatedAddressAr;
  String? lastUpdatedAddressEn;
  LatLng? lastUpdatedLocation;

  @override
  Future<UserProfileModel> fetchAdminProfile(String uid) async {
    if (shouldThrow) throw Exception('Fetch profile failed');
    return profileToReturn;
  }

  @override
  Future<ClinicModel?> fetchClinic() async {
    if (shouldThrow) throw Exception('Fetch clinic failed');
    return clinicToReturn;
  }

  @override
  Future<String> uploadPhoto({
    required Uint8List bytes,
    required String fileName,
  }) async => 'https://cloudinary.com/uploaded/$fileName';

  @override
  Future<void> updateAdminProfileAndClinic({
    required String uid,
    required String displayName,
    String? photoUrl,
    required String addressAr,
    required String addressEn,
    required LatLng location,
  }) async {
    if (shouldThrow) throw Exception('Update failed');
    lastUpdatedUid = uid;
    lastUpdatedName = displayName;
    lastUpdatedPhotoUrl = photoUrl;
    lastUpdatedAddressAr = addressAr;
    lastUpdatedAddressEn = addressEn;
    lastUpdatedLocation = location;
  }

  Object? emailChangeError;

  @override
  Future<void> requestEmailChange(String newEmail) async {
    if (emailChangeError != null) throw emailChangeError!;
    lastUpdatedEmail = newEmail;
  }
}

void main() {
  group('AdminProfileCubit', () {
    late _FakeAdminProfileRepository repository;
    late AdminProfileCubit cubit;

    setUp(() {
      repository = _FakeAdminProfileRepository();
      cubit = AdminProfileCubit(repository: repository);
    });

    test('loadProfile updates state with profile and clinic data', () async {
      await cubit.loadProfile('admin_123');

      expect(cubit.state.status, AdminProfileStatus.loaded);
      expect(cubit.state.displayName, 'Admin Boss');
      expect(cubit.state.email, 'admin@hunt.com');
      expect(cubit.state.addressAr, 'شارع التحرير');
      expect(cubit.state.addressEn, 'Tahrir Street');
      expect(cubit.state.location, const LatLng(30.0444, 31.2357));
    });

    test('setLocation updates state location', () {
      const newLoc = LatLng(31.2001, 29.9187);
      cubit.setLocation(newLoc);
      expect(cubit.state.location, newLoc);
    });

    test('saveProfileAndClinic uploads image and updates repository', () async {
      cubit.emit(
        cubit.state.copyWith(
          displayName: 'Admin Boss',
          email: 'admin@hunt.com',
        ),
      );

      final success = await cubit.saveProfileAndClinic(
        displayName: 'New Admin',
        email: 'newadmin@hunt.com',
        addressAr: 'العنوان الجديد',
        addressEn: 'New Address',
        location: const LatLng(31.2, 29.9),
        newImageBytes: Uint8List.fromList([1, 2, 3]),
        newImageName: 'avatar.jpg',
      );

      expect(success, isTrue);
      expect(cubit.state.status, AdminProfileStatus.success);
      expect(cubit.state.emailVerificationSent, isTrue);
      expect(repository.lastUpdatedName, 'New Admin');
      expect(repository.lastUpdatedEmail, 'newadmin@hunt.com');
      expect(
        repository.lastUpdatedPhotoUrl,
        'https://cloudinary.com/uploaded/avatar.jpg',
      );
      expect(repository.lastUpdatedAddressAr, 'العنوان الجديد');
      expect(repository.lastUpdatedAddressEn, 'New Address');
      expect(repository.lastUpdatedLocation, const LatLng(31.2, 29.9));
    });

    test(
      'a failed email change still saves the clinic location and profile',
      () async {
        repository.emailChangeError = const AppException(
          AppErrorCode.requiresRecentLogin,
        );

        final success = await cubit.saveProfileAndClinic(
          displayName: 'New Admin',
          email: 'changed@hunt.com',
          addressAr: 'العنوان',
          addressEn: 'Address',
          location: const LatLng(30.0, 31.0),
        );

        expect(success, isTrue);
        expect(cubit.state.status, AdminProfileStatus.success);
        expect(cubit.state.error, AppErrorCode.requiresRecentLogin);
        expect(cubit.state.emailVerificationSent, isFalse);
        expect(repository.lastUpdatedLocation, const LatLng(30.0, 31.0));
        expect(repository.lastUpdatedName, 'New Admin');
        expect(repository.lastUpdatedEmail, isNull);
      },
    );

    test('saveProfileAndClinic reports failure when update throws', () async {
      repository.shouldThrow = true;

      final success = await cubit.saveProfileAndClinic(
        displayName: 'New Admin',
        email: 'admin@hunt.com',
        addressAr: 'العنوان',
        addressEn: 'Address',
        location: const LatLng(30.0, 31.0),
      );

      expect(success, isFalse);
      expect(cubit.state.status, AdminProfileStatus.failure);
      expect(cubit.state.error, AppErrorCode.unexpected);
    });
  });

  group('AdminProfileScreen Widget Tests', () {
    testWidgets('renders all fields and prefilled values', (
      WidgetTester tester,
    ) async {
      final repository = _FakeAdminProfileRepository();
      final cubit = AdminProfileCubit(
        repository: repository,
        initialState: const AdminProfileState(
          status: AdminProfileStatus.loaded,
          displayName: 'Admin Boss',
          email: 'admin@hunt.com',
          addressAr: 'شارع التحرير',
          addressEn: 'Tahrir Street',
          location: LatLng(30.0444, 31.2357),
        ),
      );

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<AdminProfileCubit>.value(
            value: cubit,
            child: const AdminProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(tr.adminProfile), findsOneWidget);
      expect(find.text('Admin Boss'), findsOneWidget);
      expect(find.text('admin@hunt.com'), findsOneWidget);
      expect(find.text('شارع التحرير'), findsOneWidget);
      expect(find.text('Tahrir Street'), findsOneWidget);
      expect(find.byKey(const Key('admin_profile_map')), findsOneWidget);
      expect(
        find.byKey(const Key('admin_profile_save_button')),
        findsOneWidget,
      );
    });

    testWidgets('validation prevents saving when required fields are empty', (
      WidgetTester tester,
    ) async {
      final repository = _FakeAdminProfileRepository();
      final cubit = AdminProfileCubit(
        repository: repository,
        initialState: const AdminProfileState(
          status: AdminProfileStatus.loaded,
          displayName: '',
          email: '',
          addressAr: '',
          addressEn: '',
          location: LatLng(30.0444, 31.2357),
        ),
      );

      await tester.pumpWidget(
        buildTestApp(
          BlocProvider<AdminProfileCubit>.value(
            value: cubit,
            child: const AdminProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final saveBtn = find.byKey(const Key('admin_profile_save_button'));
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(repository.lastUpdatedName, isNull);
      expect(find.text(tr.enterFullName), findsAtLeastNWidgets(1));
    });

    testWidgets(
      'successful save calls repository and displays success SnackBar',
      (WidgetTester tester) async {
        final repository = _FakeAdminProfileRepository();
        final cubit = AdminProfileCubit(
          repository: repository,
          initialState: const AdminProfileState(
            status: AdminProfileStatus.loaded,
            displayName: 'Admin Boss',
            email: 'admin@hunt.com',
            addressAr: 'شارع التحرير',
            addressEn: 'Tahrir Street',
            location: LatLng(30.0444, 31.2357),
          ),
        );

        await tester.pumpWidget(
          buildTestApp(
            BlocProvider<AdminProfileCubit>.value(
              value: cubit,
              child: const AdminProfileScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final saveBtn = find.byKey(const Key('admin_profile_save_button'));
        await tester.ensureVisible(saveBtn);
        await tester.tap(saveBtn);
        await tester.pumpAndSettle();

        expect(repository.lastUpdatedName, 'Admin Boss');
        expect(repository.lastUpdatedAddressAr, 'شارع التحرير');
        expect(find.text(tr.adminProfileUpdatedSuccess), findsOneWidget);
      },
    );
  });
}
