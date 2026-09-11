import 'dart:typed_data';

import 'package:doctor_hunt/apps/features/admin/data/service/admin_doctor_service.dart';
import 'package:doctor_hunt/apps/features/admin/data/service/cloudinary_upload_service.dart';
import 'package:doctor_hunt/apps/features/specialty/data/models/specialty_model.dart';
import 'package:doctor_hunt/apps/features/specialty/data/service/specialty_service.dart';

abstract interface class CreateDoctorRepository {
  Future<List<SpecialtyModel>> fetchSpecialties();

  Future<String> uploadImage({
    required Uint8List bytes,
    required String fileName,
  });

  Future<void> createDoctor({
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    String? imageUrl,
  });

  Future<void> updateDoctor({
    required String id,
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    String? imageUrl,
  });
}

class FirebaseCreateDoctorRepository implements CreateDoctorRepository {
  FirebaseCreateDoctorRepository({
    required this.doctorService,
    required this.specialtyService,
    required this.uploadService,
  });

  final AdminDoctorService doctorService;
  final SpecialtyService specialtyService;
  final CloudinaryUploadService uploadService;

  @override
  Future<List<SpecialtyModel>> fetchSpecialties() {
    return specialtyService.fetchActiveSpecialties();
  }

  @override
  Future<String> uploadImage({
    required Uint8List bytes,
    required String fileName,
  }) {
    return uploadService.uploadImage(bytes: bytes, fileName: fileName);
  }

  @override
  Future<void> createDoctor({
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    String? imageUrl,
  }) {
    return doctorService.createDoctor(
      fullNameAr: fullNameAr,
      fullNameEn: fullNameEn,
      specialtyId: specialtyId,
      imageUrl: imageUrl,
    );
  }

  @override
  Future<void> updateDoctor({
    required String id,
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    String? imageUrl,
  }) {
    return doctorService.updateDoctor(
      id: id,
      fullNameAr: fullNameAr,
      fullNameEn: fullNameEn,
      specialtyId: specialtyId,
      imageUrl: imageUrl,
    );
  }
}
