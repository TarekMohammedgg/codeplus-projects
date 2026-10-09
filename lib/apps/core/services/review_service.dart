import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/review_model.dart';
import 'package:doctor_hunt/apps/core/utils/rating_utils.dart';

class ReviewService {
  ReviewService({required FirebaseFirestore firestore})
    // ignore: prefer_initializing_formals
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _reviews =>
      _firestore.collection('reviews');

  Future<List<ReviewModel>> fetchRecentReviews(
    String doctorId, {
    int limit = 5,
  }) async {
    final snapshot = await _reviews
        .where('doctorId', isEqualTo: doctorId)
        .get();
    final reviews =
        snapshot.docs
            .map((doc) => ReviewModel.fromFirestore(doc.id, doc.data()))
            .toList()
          ..sort(
            (a, b) => (b.createdAt ?? DateTime(0)).compareTo(
              a.createdAt ?? DateTime(0),
            ),
          );
    return reviews.take(limit).toList();
  }

  Future<void> submitReview({
    required AppointmentModel appointment,
    required int rating,
    required String patientName,
    String comment = '',
  }) async {
    if (appointment.status != AppointmentStatus.completed ||
        appointment.isReviewed) {
      throw const ReviewNotAllowedException();
    }
    final doctorRef = _firestore
        .collection('doctors')
        .doc(appointment.doctorId);
    final reviewRef = _reviews.doc(appointment.id);
    final appointmentRef = _firestore
        .collection('appointments')
        .doc(appointment.id);

    await _firestore.runTransaction((transaction) async {
      final doctorData = (await transaction.get(doctorRef)).data();
      final count = (doctorData?['reviewsCount'] as num?)?.toInt() ?? 0;
      final average = (doctorData?['rating'] as num?)?.toDouble() ?? 0;

      transaction.set(reviewRef, {
        'appointmentId': appointment.id,
        'patientId': appointment.patientId,
        'patientName': patientName,
        'doctorId': appointment.doctorId,
        'rating': rating,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
      });
      transaction.update(doctorRef, {
        'rating': double.parse(
          nextAverage(average, count, rating).toStringAsFixed(2),
        ),
        'reviewsCount': count + 1,
        'lastReviewId': appointment.id,
      });
      transaction.update(appointmentRef, {'isReviewed': true});
    });
  }
}
