import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/specialty_model.dart';

enum AdminAppointmentTab { all, upcoming, completed, cancelled }

enum AdminAppointmentsStatus { initial, loading, loaded, failure }

List<AppointmentModel> filterAppointmentsByTab(
  List<AppointmentModel> appointments,
  AdminAppointmentTab tab,
) => tab == AdminAppointmentTab.all
    ? appointments
    : appointments.where((a) => a.status.name == tab.name).toList();

class AdminAppointmentsState {
  const AdminAppointmentsState({
    this.status = AdminAppointmentsStatus.initial,
    this.appointments = const [],
    this.selectedTab = AdminAppointmentTab.all,
    this.specialties = const {},
    this.patientPhotos = const {},
    this.error,
  });

  final AdminAppointmentsStatus status;
  final List<AppointmentModel> appointments;
  final AdminAppointmentTab selectedTab;
  final Map<String, SpecialtyModel> specialties;
  final Map<String, String> patientPhotos;
  final AppErrorCode? error;

  List<AppointmentModel> get currentAppointments =>
      filterAppointmentsByTab(appointments, selectedTab);

  AdminAppointmentsState copyWith({
    AdminAppointmentsStatus? status,
    List<AppointmentModel>? appointments,
    AdminAppointmentTab? selectedTab,
    Map<String, SpecialtyModel>? specialties,
    Map<String, String>? patientPhotos,
    AppErrorCode? error,
  }) {
    return AdminAppointmentsState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      selectedTab: selectedTab ?? this.selectedTab,
      specialties: specialties ?? this.specialties,
      patientPhotos: patientPhotos ?? this.patientPhotos,
      error: error,
    );
  }
}
