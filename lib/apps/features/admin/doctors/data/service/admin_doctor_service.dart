import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/services/doctor_service.dart';

class AdminDoctorService {
  //CR Bad DI: Avoid mixing static singletons and swallowing Firebase uninitialized errors with catch (_) => null.
  //CR Inject non-nullable `FirebaseFirestore` via constructor.
  // solved

  //CR Bad DI: Avoid mixing static singletons and swallowing Firebase uninitialized errors with catch (_) => null.
  //CR Inject non-nullable `FirebaseFirestore` via constructor.
  // solved
  AdminDoctorService({required this.doctorService});

  final DoctorService doctorService;

  //CR Bad DI: Avoid mixing static singletons and swallowing Firebase uninitialized errors with catch (_) => null.
  //CR Inject non-nullable `FirebaseFirestore` via constructor.
  // solved
  Stream<List<DoctorModel>> streamDoctors() => doctorService.streamAllDoctors();

  Stream<DoctorModel?> streamDoctor(String id) =>
      doctorService.streamDoctor(id);

  Future<void> createDoctor({
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    required double consultationFee,
    String? imageUrl,
  }) {
    return doctorService.createDoctor(
      fullNameAr: fullNameAr,
      fullNameEn: fullNameEn,
      specialtyId: specialtyId,
      consultationFee: consultationFee,
      imageUrl: imageUrl,
    );
  }

  Future<void> updateDoctor({
    required String id,
    required String fullNameAr,
    required String fullNameEn,
    required String specialtyId,
    required double consultationFee,
    String? imageUrl,
  }) {
    return doctorService.updateDoctor(
      id: id,
      fullNameAr: fullNameAr,
      fullNameEn: fullNameEn,
      specialtyId: specialtyId,
      consultationFee: consultationFee,
      imageUrl: imageUrl,
    );
  }

  Future<void> setActive(String id, bool isActive) =>
      doctorService.setActive(id, isActive);

  Future<void> updateAvailability(String id, DoctorAvailability availability) =>
      doctorService.updateAvailability(id, availability);
}
