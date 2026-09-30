import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/services/cloudinary_upload_service.dart';
import 'package:doctor_hunt/apps/features/admin/profile/data/repositories/admin_profile_repository.dart';
import 'package:doctor_hunt/apps/features/admin/profile/presentation/controller/cubit/admin_profile_cubit.dart';
import 'package:doctor_hunt/apps/features/admin/profile/presentation/controller/cubit/admin_profile_state.dart';
import 'package:doctor_hunt/apps/features/admin/profile/presentation/screens/admin_profile_screen.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

import '../../../helpers/test_app.dart';

class _FakeAdminProfileRepository implements AdminProfileRepository {
  UserProfileModel? profileToReturn = const UserProfileModel(
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
  String? lastUpdatedName;
  String? lastUpdatedEmail;
  String? lastUpdatedPhotoUrl;
  String? lastUpdatedAddressAr;
  String? lastUpdatedAddressEn;
  LatLng? lastUpdatedLocation;

  @override
  Future<UserProfileModel?> fetchAdminProfile(String uid) async {
    if (shouldThrow) throw Exception('Fetch profile failed');
    return profileToReturn;
  }

  @override
  Future<ClinicModel?> fetchClinic() async {
    if (shouldThrow) throw Exception('Fetch clinic failed');
    return clinicToReturn;
  }

  @override
  Future<void> updateAdminProfileAndClinic({
    required String uid,
    required String displayName,
    String? photoUrl,
    String? newEmail,
    required String addressAr,
    required String addressEn,
    required LatLng location,
  }) async {
    if (shouldThrow) throw Exception('Update failed');
    lastUpdatedUid = uid;
    lastUpdatedName = displayName;
    lastUpdatedEmail = newEmail;
    lastUpdatedPhotoUrl = photoUrl;
    lastUpdatedAddressAr = addressAr;
    lastUpdatedAddressEn = addressEn;
    lastUpdatedLocation = location;
  }
}

class _FakeCloudinaryUploadService extends Fake
    implements CloudinaryUploadService {
  @override
  Future<String> uploadImage({
    required Uint8List bytes,
    required String fileName,
  }) async {
    return 'https://cloudinary.com/uploaded/$fileName';
  }
}

void main() {
  group('AdminProfileCubit', () {
    late _FakeAdminProfileRepository repository;
    late _FakeCloudinaryUploadService uploadService;
    late AdminProfileCubit cubit;

    setUp(() {
      repository = _FakeAdminProfileRepository();
      uploadService = _FakeCloudinaryUploadService();
      cubit = AdminProfileCubit(
        repository: repository,
        uploadService: uploadService,
      );
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
        uid: 'admin_123',
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

    test('saveProfileAndClinic reports failure when update throws', () async {
      repository.shouldThrow = true;

      final success = await cubit.saveProfileAndClinic(
        uid: 'admin_123',
        displayName: 'New Admin',
        email: 'admin@hunt.com',
        addressAr: 'العنوان',
        addressEn: 'Address',
        location: const LatLng(30.0, 31.0),
      );

      expect(success, isFalse);
      expect(cubit.state.status, AdminProfileStatus.failure);
      expect(cubit.state.errorMessage, contains('Update failed'));
    });
  });

  group('AdminProfileScreen Widget Tests', () {
    testWidgets('renders all fields and prefilled values', (
      WidgetTester tester,
    ) async {
      final repository = _FakeAdminProfileRepository();
      final uploadService = _FakeCloudinaryUploadService();
      final cubit = AdminProfileCubit(
        repository: repository,
        uploadService: uploadService,
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
          AdminProfileScreen(
            cubit: cubit,
            repository: repository,
            uploadService: uploadService,
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
      final uploadService = _FakeCloudinaryUploadService();
      final cubit = AdminProfileCubit(
        repository: repository,
        uploadService: uploadService,
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
          AdminProfileScreen(
            cubit: cubit,
            repository: repository,
            uploadService: uploadService,
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
        final uploadService = _FakeCloudinaryUploadService();
        final cubit = AdminProfileCubit(
          repository: repository,
          uploadService: uploadService,
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
            AdminProfileScreen(
              cubit: cubit,
              repository: repository,
              uploadService: uploadService,
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
