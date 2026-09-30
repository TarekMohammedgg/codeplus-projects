import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/utils/slot_generator.dart';

/// Single Firestore access point for `appointments` and their
/// `bookedSlots` locks, shared by the patient and admin features.
class AppointmentService {
  AppointmentService({required FirebaseFirestore firestore})
    // ignore: prefer_initializing_formals
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _appointments =>
      _firestore.collection('appointments');

  CollectionReference<Map<String, dynamic>> get _bookedSlots =>
      _firestore.collection('bookedSlots');

  Future<Set<DateTime>> fetchBookedStarts(String doctorId, DateTime day) async {
    final snapshot = await _bookedSlots
        .where('doctorId', isEqualTo: doctorId)
        .where('dateKey', isEqualTo: dateKeyFor(day))
        .get();
    return {
      for (final doc in snapshot.docs)
        (doc.data()['startAt'] as Timestamp).toDate(),
    };
  }

  /// Books [startAt] for the patient. The `bookedSlots` lock document and the
  /// appointment are written in one transaction, so two patients can never
  /// hold the same slot. Throws [SlotAlreadyBookedException] when taken.
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

    await _firestore.runTransaction((transaction) async {
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
        'doctorName': {'ar': doctor.nameAr ?? '', 'en': doctor.nameEn ?? ''},
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

  /// Soonest first.
  Stream<List<AppointmentModel>> streamPatientAppointments(String patientId) {
    return _appointments
        .where('patientId', isEqualTo: patientId)
        .snapshots()
        .map((snapshot) => _parse(snapshot)..sort(_bySoonest));
  }

  /// Latest first.
  Stream<List<AppointmentModel>> streamAllAppointments() {
    return _appointments
        .orderBy('startAt', descending: true)
        .snapshots()
        .map(_parse);
  }

  /// Cancels the appointment and deletes its slot lock so the slot can be
  /// booked again.
  Future<void> cancel(
    AppointmentModel appointment, {
    required CancelledBy cancelledBy,
  }) {
    return (_firestore.batch()
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

  int _bySoonest(AppointmentModel a, AppointmentModel b) =>
      a.startAt.compareTo(b.startAt);
}
