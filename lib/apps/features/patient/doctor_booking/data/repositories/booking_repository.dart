import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/services/appointment_service.dart';
import 'package:doctor_hunt/apps/core/services/clinic_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_booking/data/models/booking_draft.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/service/profile_service.dart';

abstract interface class BookingRepository {
  Future<Set<DateTime>> fetchBookedStarts(String doctorId, DateTime day);

  Stream<ClinicModel?> watchClinic();

  Future<void> book(BookingDraft draft);
}

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl({
    required this.appointmentService,
    required this.clinicService,
    required this.authService,
    required this.profileService,
  });

  final AppointmentService appointmentService;
  final ClinicService clinicService;
  final AuthService authService;
  final ProfileService profileService;

  @override
  Future<Set<DateTime>> fetchBookedStarts(String doctorId, DateTime day) {
    return appointmentService.fetchBookedStarts(doctorId, day);
  }

  @override
  Stream<ClinicModel?> watchClinic() => clinicService.streamClinic();

  @override
  Future<void> book(BookingDraft draft) async {
    final user = authService.currentUser;
    if (user == null) throw StateError('Booking requires a signed-in patient');
    final profile = await profileService.streamProfile(user.uid).first;
    await appointmentService.book(
      doctor: draft.doctor,
      startAt: draft.startAt,
      patientId: user.uid,
      patientName: profile.name.isNotEmpty
          ? profile.name
          : (user.displayName ?? ''),
      patientEmail: profile.email.isNotEmpty
          ? profile.email
          : (user.email ?? ''),
      patientPhone: profile.phone,
    );
  }
}
