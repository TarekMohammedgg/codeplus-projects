import 'package:flutter/foundation.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';

enum AdminAppointmentTab { all, upcoming, completed, cancelled }

enum AdminAppointmentsStatus { initial, loading, loaded, failure }

List<AppointmentModel> filterAppointmentsByTab(
  List<AppointmentModel> appointments,
  AdminAppointmentTab tab,
) {
  switch (tab) {
    case AdminAppointmentTab.all:
      return appointments;
    case AdminAppointmentTab.upcoming:
      return appointments
          .where((a) => a.status == AppointmentStatus.upcoming)
          .toList();
    case AdminAppointmentTab.completed:
      return appointments
          .where((a) => a.status == AppointmentStatus.completed)
          .toList();
    case AdminAppointmentTab.cancelled:
      return appointments
          .where((a) => a.status == AppointmentStatus.cancelled)
          .toList();
  }
}

@immutable
class AdminAppointmentsState {
  const AdminAppointmentsState({
    this.status = AdminAppointmentsStatus.initial,
    this.appointments = const [],
    this.selectedTab = AdminAppointmentTab.all,
    this.specialties = const {},
    this.patientPhotos = const {},
    this.errorMessage,
  });

  final AdminAppointmentsStatus status;
  final List<AppointmentModel> appointments;
  final AdminAppointmentTab selectedTab;
  final Map<String, SpecialtyModel> specialties;
  final Map<String, String> patientPhotos;
  final String? errorMessage;

  List<AppointmentModel> get currentAppointments =>
      filterAppointmentsByTab(appointments, selectedTab);

  AdminAppointmentsState copyWith({
    AdminAppointmentsStatus? status,
    List<AppointmentModel>? appointments,
    AdminAppointmentTab? selectedTab,
    Map<String, SpecialtyModel>? specialties,
    Map<String, String>? patientPhotos,
    String? errorMessage,
  }) {
    return AdminAppointmentsState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      selectedTab: selectedTab ?? this.selectedTab,
      specialties: specialties ?? this.specialties,
      patientPhotos: patientPhotos ?? this.patientPhotos,
      errorMessage: errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminAppointmentsState &&
          other.status == status &&
          listEquals(other.appointments, appointments) &&
          other.selectedTab == selectedTab &&
          mapEquals(other.specialties, specialties) &&
          mapEquals(other.patientPhotos, patientPhotos) &&
          other.errorMessage == errorMessage;

  @override
  int get hashCode => Object.hash(
    status,
    Object.hashAll(appointments),
    selectedTab,
    Object.hashAll(specialties.entries),
    Object.hashAll(patientPhotos.entries),
    errorMessage,
  );
}
