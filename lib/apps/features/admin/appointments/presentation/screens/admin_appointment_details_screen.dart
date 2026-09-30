import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';

class AdminAppointmentDetailsScreen extends StatelessWidget {
  const AdminAppointmentDetailsScreen({super.key, required this.appointment});

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Admin Appointment Details')),
    );
  }
}
