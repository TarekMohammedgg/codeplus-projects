import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:doctor_hunt/generated/i18n/translations.g.dart';

enum AppointmentStatus { upcoming, completed, cancelled }

enum CancelledBy { patient, admin }

class AppointmentModel {
  const AppointmentModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.patientEmail,
    required this.patientPhone,
    required this.doctorId,
    required this.doctorNameAr,
    required this.doctorNameEn,
    required this.startAt,
    required this.slotId,
    required this.status,
    this.specialtyId,
    this.doctorImageUrl,
    this.fee = 0,
    this.cancelledBy,
    this.isReviewed = false,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String patientId;
  final String patientName;
  final String patientEmail;
  final String patientPhone;
  final String doctorId;
  final String doctorNameAr;
  final String doctorNameEn;
  final String? specialtyId;
  final String? doctorImageUrl;
  final double fee;
  final DateTime startAt;
  final String slotId;
  final AppointmentStatus status;
  final CancelledBy? cancelledBy;
  final bool isReviewed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get doctorName => LocaleSettings.currentLocale == AppLocale.ar
      ? doctorNameAr
      : doctorNameEn;

  factory AppointmentModel.fromFirestore(String id, Map<String, dynamic> data) {
    final doctorName = data['doctorName'] is Map
        ? Map<String, dynamic>.from(data['doctorName'] as Map)
        : const <String, dynamic>{};
    return AppointmentModel(
      id: id,
      patientId: data['patientId'] as String,
      patientName: data['patientName'] as String? ?? '',
      patientEmail: data['patientEmail'] as String? ?? '',
      patientPhone: data['patientPhone'] as String? ?? '',
      doctorId: data['doctorId'] as String,
      doctorNameAr: doctorName['ar'] as String? ?? '',
      doctorNameEn: doctorName['en'] as String? ?? '',
      specialtyId: data['specialtyId'] as String?,
      doctorImageUrl: data['doctorImageUrl'] as String?,
      fee: (data['fee'] as num?)?.toDouble() ?? 0,
      startAt: (data['startAt'] as Timestamp).toDate(),
      slotId: data['slotId'] as String,
      status: AppointmentStatus.values.byName(data['status'] as String),
      cancelledBy: switch (data['cancelledBy']) {
        final String name => CancelledBy.values.byName(name),
        _ => null,
      },
      isReviewed: data['isReviewed'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
