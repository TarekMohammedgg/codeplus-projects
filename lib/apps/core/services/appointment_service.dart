import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/doctor_availability.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/utils/slot_generator.dart';

class AppointmentService {
  AppointmentService({required this.firestore});

  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> get _appointments =>
      firestore.collection('appointments');

  CollectionReference<Map<String, dynamic>> get _bookedSlots =>
      firestore.collection('bookedSlots');

  /// Live booked starts for [days], so a slot freed by a cancel (patient or
  /// admin) or taken by another patient updates open booking screens.
  Stream<Set<DateTime>> watchBookedStarts(
    String doctorId,
    List<DateTime> days,
  ) {
    return _bookedSlots
        .where('doctorId', isEqualTo: doctorId)
        .where('dateKey', whereIn: days.map(dateKeyFor).toList())
        .snapshots()
        .map(
          (snapshot) => {
            for (final doc in snapshot.docs)
              (doc.data()['startAt'] as Timestamp).toDate(),
          },
        );
  }

  Future<void> book({
    required DoctorModel doctor,
    required DateTime startAt,
    required String patientId,
    required String patientName,
    required String patientEmail,
    required String patientPhone,
  }) async {
    final slotId = slotIdFor(doctor.id, startAt);
    final slotRef = _bookedSlots.doc(slotId);
    final appointmentRef = _appointments.doc();
    final startTimestamp = Timestamp.fromDate(startAt);

    await firestore.runTransaction((transaction) async {
      final doctorDoc = await transaction.get(
        firestore.collection('doctors').doc(doctor.id),
      );
      final doctorData = doctorDoc.data();
      final availability = DoctorAvailability.tryParse(
        doctorData?['availability'],
      );
      final isBookable =
          doctorData != null &&
          doctorData['isActive'] != false &&
          availability != null &&
          slotsForDay(
            availability,
            startAt,
            const {},
            DateTime.now(),
          ).contains(startAt);
      if (!isBookable) throw const DoctorUnavailableException();
      if ((await transaction.get(slotRef)).exists) {
        throw const SlotAlreadyBookedException();
      }
      transaction.set(slotRef, {
        'doctorId': doctor.id,
        'dateKey': dateKeyFor(startAt),
        'startAt': startTimestamp,
        'patientId': patientId,
        'appointmentId': appointmentRef.id,
      });
      transaction.set(appointmentRef, {
        'patientId': patientId,
        'patientName': patientName,
        'patientEmail': patientEmail,
        'patientPhone': patientPhone,
        'doctorId': doctor.id,
        'doctorName': {'ar': doctor.nameAr, 'en': doctor.nameEn},
        'specialtyId': doctor.specialtyId,
        'doctorImageUrl': doctor.imageUrl,
        'fee': doctor.consultationFee,
        'startAt': startTimestamp,
        'slotId': slotId,
        'status': AppointmentStatus.upcoming.name,
        'cancelledBy': null,
        'isReviewed': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Stream<List<AppointmentModel>> streamPatientAppointments(String patientId) {
    return _appointments
        .where('patientId', isEqualTo: patientId)
        .snapshots()
        .map(_parse);
  }

  Stream<AppointmentModel?> streamAppointment(String id) {
    return _appointments.doc(id).snapshots().map((doc) {
      final data = doc.data();
      return data == null ? null : AppointmentModel.fromFirestore(doc.id, data);
    });
  }

  Stream<List<AppointmentModel>> streamAllAppointments() {
    return _appointments
        .orderBy('startAt', descending: true)
        .snapshots()
        .map(_parse);
  }

  Future<void> cancel(
    AppointmentModel appointment, {
    required CancelledBy cancelledBy,
  }) {
    return (firestore.batch()
          ..update(_appointments.doc(appointment.id), {
            'status': AppointmentStatus.cancelled.name,
            'cancelledBy': cancelledBy.name,
            'updatedAt': FieldValue.serverTimestamp(),
          })
          ..delete(_bookedSlots.doc(appointment.slotId)))
        .commit();
  }

  Future<void> markCompleted(String appointmentId) {
    return _appointments.doc(appointmentId).update({
      'status': AppointmentStatus.completed.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  List<AppointmentModel> _parse(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs
        .map((doc) => AppointmentModel.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}
