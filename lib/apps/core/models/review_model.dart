import 'package:cloud_firestore/cloud_firestore.dart';

/// Max review comment length (also enforced in firestore.rules).
const reviewCommentMaxLength = 500;

class ReviewModel {
  const ReviewModel({
    required this.appointmentId,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.rating,
    this.comment = '',
    this.createdAt,
  });

  final String appointmentId;
  final String patientId;
  final String patientName;
  final String doctorId;
  final int rating;
  final String comment;
  final DateTime? createdAt;

  factory ReviewModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ReviewModel(
      appointmentId: id,
      patientId: data['patientId'] as String,
      patientName: data['patientName'] as String? ?? '',
      doctorId: data['doctorId'] as String,
      rating: (data['rating'] as num).toInt(),
      comment: data['comment'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
